# ZIP entry headers must agree with the central directory. Android 12 checks
# data descriptors that generic ZIP readers and APK signature checks may ignore.
if (-not ('DdtlqApkZip' -as [type])) {
$apkZipSource = @'
using System;
using System.IO;
using System.IO.Compression;
using System.Collections.Generic;
public static class DdtlqApkZip {
 sealed class Entry { public string Name; public long Central,Local,Data; public ushort Flags; public uint Crc,Compressed,Size; }
 static ushort U16(byte[] b,int p){return BitConverter.ToUInt16(b,p);}
 static uint U32(byte[] b,int p){return BitConverter.ToUInt32(b,p);}
 static byte[] Read(FileStream f,long p,int n){f.Position=p;byte[] b=new byte[n];int k=0,r;while(k<n&&(r=f.Read(b,k,n-k))>0)k+=r;if(k!=n)throw new InvalidDataException("Truncated ZIP");return b;}
 static void Put(FileStream f,long p,byte[] b){f.Position=p;f.Write(b,0,b.Length);}
 static readonly uint[] Table=MakeTable();
 static uint[] MakeTable(){uint[] t=new uint[256];for(uint i=0;i<256;i++){uint c=i;for(int j=0;j<8;j++)c=(c&1)!=0?0xedb88320^(c>>1):c>>1;t[i]=c;}return t;}
 public static string Check(string path,bool repair) {
  var entries=new List<Entry>();int descriptors=0,bad=0;
  using(var f=new FileStream(path,FileMode.Open,repair?FileAccess.ReadWrite:FileAccess.Read,FileShare.Read)){
   int tail=(int)Math.Min(f.Length,65557);byte[] end=Read(f,f.Length-tail,tail);int eo=-1;
   for(int i=tail-22;i>=0;i--)if(U32(end,i)==0x06054b50&&i+22+U16(end,i+20)==tail){eo=i;break;}
   if(eo<0||U16(end,eo+4)!=0||U16(end,eo+6)!=0)throw new InvalidDataException("Unsupported ZIP directory");
   uint central=U32(end,eo+16);int count=U16(end,eo+10);long pos=central;var names=new HashSet<string>();
   for(int i=0;i<count;i++){
    byte[] h=Read(f,pos,46);if(U32(h,0)!=0x02014b50)throw new InvalidDataException("Invalid central header");
    int nl=U16(h,28),xl=U16(h,30),cl=U16(h,32);string name=System.Text.Encoding.UTF8.GetString(Read(f,pos+46,nl));
    if(!names.Add(name))throw new InvalidDataException("Duplicate entry: "+name);
    var e=new Entry{Name=name,Central=pos,Local=U32(h,42),Flags=U16(h,8),Crc=U32(h,16),Compressed=U32(h,20),Size=U32(h,24)};
    byte[] l=Read(f,e.Local,30);if(U32(l,0)!=0x04034b50||U16(l,8)!=U16(h,10)||U16(l,6)!=e.Flags)throw new InvalidDataException("Entry header mismatch: "+name);
    if(System.Text.Encoding.UTF8.GetString(Read(f,e.Local+30,U16(l,26)))!=name)throw new InvalidDataException("Entry name mismatch: "+name);
    e.Data=e.Local+30+U16(l,26)+U16(l,28);if(e.Data+e.Compressed>central)throw new InvalidDataException("Entry out of bounds: "+name);
    if((e.Flags&8)!=0){
     descriptors++;byte[] d=Read(f,e.Data+e.Compressed,16);int k=U32(d,0)==0x08074b50?4:0;
     if(U32(d,k)!=e.Crc||U32(d,k+4)!=e.Compressed||U32(d,k+8)!=e.Size)bad++;
    }else if(U32(l,14)!=e.Crc||U32(l,18)!=e.Compressed||U32(l,22)!=e.Size)throw new InvalidDataException("Entry sizes/CRC mismatch: "+name);
    entries.Add(e);pos+=46+nl+xl+cl;
   }
   // Verify actual decompressed bytes before allowing any header normalization.
   using(var z=new ZipArchive(f,ZipArchiveMode.Read,true)){
    byte[] buf=new byte[131072];foreach(var e in entries){var ze=z.GetEntry(e.Name);uint crc=0xffffffff;long n=0;
     using(var s=ze.Open()){int r;while((r=s.Read(buf,0,buf.Length))>0){n+=r;for(int i=0;i<r;i++)crc=Table[(crc^buf[i])&255]^(crc>>8);}}
     if(n!=e.Size||(crc^0xffffffff)!=e.Crc)throw new InvalidDataException("Payload CRC/size mismatch: "+e.Name);
    }
   }
   if(repair){foreach(var e in entries)if((e.Flags&8)!=0){
    ushort flags=(ushort)(e.Flags&~8);Put(f,e.Local+6,BitConverter.GetBytes(flags));Put(f,e.Central+8,BitConverter.GetBytes(flags));
    Put(f,e.Local+14,BitConverter.GetBytes(e.Crc));Put(f,e.Local+18,BitConverter.GetBytes(e.Compressed));Put(f,e.Local+22,BitConverter.GetBytes(e.Size));
   }f.Flush(true);}else if(bad!=0)throw new InvalidDataException("Invalid ZIP data descriptors: "+bad);
  }
  return "entries="+entries.Count+"; descriptors="+descriptors+"; invalidDescriptors="+bad+"; normalized="+repair+"; allPayloadCRCs=OK";
 }
}
'@
if ($PSVersionTable.PSVersion.Major -ge 7) { Add-Type -TypeDefinition $apkZipSource -ErrorAction Stop } else { Add-Type -ReferencedAssemblies 'System.dll','System.Core.dll','System.IO.Compression.dll' -TypeDefinition $apkZipSource -ErrorAction Stop }
}
function Repair-ApkZipHeaders([string]$Path) { [DdtlqApkZip]::Check($Path,$true) }
function Test-ApkZipHeaders([string]$Path) { [DdtlqApkZip]::Check($Path,$false) }
