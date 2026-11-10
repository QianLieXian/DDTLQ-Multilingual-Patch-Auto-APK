using System;
using System.IO;
using System.Linq;
using System.Text.Json;
using UndertaleModLib.Models;
using UndertaleModLib.Util;
var patchRoot=Path.GetDirectoryName(ScriptPath);
var glyphRows=JsonDocument.Parse(File.ReadAllText(Path.Combine(patchRoot,"cjk-glyphs.json"))).RootElement;
foreach(var font in Data.Fonts)
{
    var old=font.Texture;
    var original=old.TexturePage.TextureData.Image.ConvertToRawBgra();
    var source=original.GetRawImageData().ToArray();
    int cellW=16,cellH=24,atlasW=1024;
    int rows=(glyphRows.GetArrayLength()+atlasW/cellW-1)/(atlasW/cellW);
    int atlasH=256;while(atlasH<128+rows*cellH)atlasH*=2;
    if(atlasH>4096)throw new Exception("Font texture exceeds mobile texture limit");
    var pixels=new byte[atlasW*atlasH*4];
    for(int y=0;y<old.SourceHeight;y++)Array.Copy(source,((y+old.SourceY)*original.Width+old.SourceX)*4,pixels,y*atlasW*4,old.SourceWidth*4);
    int glyphHeight=font.Glyphs.Max(g=>(int)g.SourceHeight);
    int index=0;
    foreach(var row in glyphRows.EnumerateArray())
    {
        int cp=row.GetProperty("cp").GetInt32();
        if(font.Glyphs.Any(g=>g.Character==cp))continue;
        int x=index%(atlasW/cellW)*cellW,y=128+index/(atlasW/cellW)*cellH;
        int bw=row.GetProperty("width").GetInt32(),bh=row.GetProperty("height").GetInt32();
        int bx=row.GetProperty("xoff").GetInt32(),by=row.GetProperty("yoff").GetInt32();
        // Match the 12px CJK cell to the original pixel-font baseline.
        int top=(glyphHeight-12)/2+10-by-bh+(font.Name.Content=="fnt_heartbit2"?1:0);
        int yy=0;
        foreach(var bits in row.GetProperty("bits").EnumerateArray())
        {
            string hex=bits.GetString();
            for(int xx=0;xx<bw;xx++)
            {
                int nibble=Convert.ToInt32(hex[xx/4].ToString(),16);
                if((nibble&(8>>(xx%4)))!=0)
                {
                    int px=x+bx+xx,py=y+top+yy;
                    if(px<x||px>=x+cellW||py<y||py>=y+cellH)throw new Exception("Glyph bounds: "+cp);
                    int pos=(py*atlasW+px)*4;
                    pixels[pos]=255;pixels[pos+1]=255;pixels[pos+2]=255;pixels[pos+3]=255;
                }
            }
            yy++;
        }
        font.Glyphs.Add(new UndertaleFont.Glyph{Character=(ushort)cp,SourceX=(ushort)x,SourceY=(ushort)y,SourceWidth=(ushort)Math.Max(12,bw+bx),SourceHeight=(ushort)glyphHeight,Shift=(short)row.GetProperty("advance").GetInt32(),Offset=0});
        index++;
    }
    var image=new GMImage(atlasW,atlasH);pixels.AsSpan().CopyTo(image.GetRawImageData());
    var texture=new UndertaleEmbeddedTexture{Name=new UndertaleString("ZH_"+font.Name.Content),TextureData=new UndertaleEmbeddedTexture.TexData{Image=image.ConvertToPng()}};
    Data.EmbeddedTextures.Add(texture);
    var page=new UndertaleTexturePageItem{Name=new UndertaleString("ZH_"+font.Name.Content),SourceWidth=(ushort)atlasW,SourceHeight=(ushort)atlasH,TargetWidth=(ushort)atlasW,TargetHeight=(ushort)atlasH,BoundingWidth=(ushort)atlasW,BoundingHeight=(ushort)atlasH,TexturePage=texture};
    Data.TexturePageItems.Add(page);font.Texture=page;font.RangeEnd=65535;
    // Glyph arrays are searched by Unicode code point in the runner.
    var ordered=font.Glyphs.OrderBy(g=>g.Character).ToArray();font.Glyphs.Clear();foreach(var g in ordered)font.Glyphs.Add(g);
    Console.WriteLine($"CJK FONT {font.Name.Content}: {font.Glyphs.Count} glyphs, {atlasW}x{atlasH}");
}
// A distinct 10px UI font keeps status/result text smaller without shrinking dialogue.
var smallRows=JsonDocument.Parse(File.ReadAllText(Path.Combine(patchRoot,"ui10-glyphs.json"))).RootElement;
int swidth=1024,sheight=1024,cellWidth=14,cellHeight=16;
if(smallRows.GetArrayLength()>swidth/cellWidth*sheight/cellHeight)throw new Exception("UI font atlas full");
var smallPixels=new byte[swidth*sheight*4];
var smallFont=new UndertaleFont{Name=Data.Strings.MakeString("fnt_zh_ui10"),DisplayName=Data.Strings.MakeString("Fusion Pixel UI 10"),EmSize=10,RangeStart=32,RangeEnd=65535,ScaleX=1,ScaleY=1};
int smallIndex=0;
foreach(var row in smallRows.EnumerateArray()) {
 int cp=row.GetProperty("cp").GetInt32(),bw=row.GetProperty("width").GetInt32(),bh=row.GetProperty("height").GetInt32(),bx=row.GetProperty("xoff").GetInt32(),by=row.GetProperty("yoff").GetInt32();
 int x=smallIndex%(swidth/cellWidth)*cellWidth,y=smallIndex/(swidth/cellWidth)*cellHeight,yy=0;
 foreach(var bits in row.GetProperty("bits").EnumerateArray()) {
  string hex=bits.GetString();for(int xx=0;xx<bw;xx++)if((Convert.ToInt32(hex[xx/4].ToString(),16)&(8>>(xx%4)))!=0) {
   int px=x+bx+xx,py=y+1+9-by-bh+yy+(cp>126?1:0);
   if(px<x||px>=x+cellWidth||py<y||py>=y+12)throw new Exception("UI glyph bounds "+cp);
   int p=(py*swidth+px)*4;for(int k=0;k<4;k++)smallPixels[p+k]=255;
  }yy++;
 }
 smallFont.Glyphs.Add(new UndertaleFont.Glyph{Character=(ushort)cp,SourceX=(ushort)x,SourceY=(ushort)y,SourceWidth=(ushort)Math.Max(1,bw+bx),SourceHeight=12,Shift=(short)row.GetProperty("advance").GetInt32()});smallIndex++;
}
var orderedSmall=smallFont.Glyphs.OrderBy(g=>g.Character).ToArray();smallFont.Glyphs.Clear();foreach(var g in orderedSmall)smallFont.Glyphs.Add(g);
var smallImage=new GMImage(swidth,sheight);smallPixels.AsSpan().CopyTo(smallImage.GetRawImageData());
var smallTexture=new UndertaleEmbeddedTexture{Name=Data.Strings.MakeString("ZH_UI10"),TextureData=new UndertaleEmbeddedTexture.TexData{Image=smallImage.ConvertToPng()}};Data.EmbeddedTextures.Add(smallTexture);
var smallPage=new UndertaleTexturePageItem{Name=Data.Strings.MakeString("ZH_UI10"),SourceWidth=1024,SourceHeight=1024,TargetWidth=1024,TargetHeight=1024,BoundingWidth=1024,BoundingHeight=1024,TexturePage=smallTexture};Data.TexturePageItems.Add(smallPage);smallFont.Texture=smallPage;Data.Fonts.Add(smallFont);
Console.WriteLine("Compact UI font: "+smallFont.Glyphs.Count+" glyphs");
