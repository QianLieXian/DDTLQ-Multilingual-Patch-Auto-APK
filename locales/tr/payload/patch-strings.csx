using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using System.Text.Json;
using UndertaleModLib;
using UndertaleModLib.Models;
var stringsRoot=Path.GetDirectoryName(ScriptPath);
var stringMap=new Dictionary<string,string>();
foreach(var row in JsonDocument.Parse(File.ReadAllText(Path.Combine(stringsRoot,"translations.json"))).RootElement.EnumerateArray()) {
 string en=row.GetProperty("source").GetString(),zh=row.GetProperty("zh").GetString();
 if(en!=zh)stringMap.Add(en,zh);
}
var protectedText=new HashSet<string>(Data.Variables.Select(v=>v.Name.Content));
foreach(var function in Data.Functions)protectedText.Add(function.Name.Content);
foreach(var code in Data.Code)protectedText.Add(code.Name.Content);
foreach(var s in new[]{"Natural","natural","Controls","Settings"})protectedText.Add(s);
foreach(var row in JsonDocument.Parse(File.ReadAllText(Path.Combine(stringsRoot,"translations.json"))).RootElement.EnumerateArray()) {
 int id=row.GetProperty("id").GetInt32();if(id>=727&&id<=768)protectedText.Add(row.GetProperty("source").GetString());
}
int changed=0;
var touched=new HashSet<string>();
foreach(var code in Data.Code) {
 string name=code.Name.Content;
 if(name.StartsWith("gml_Script_zh_")||name.StartsWith("gml_Object_o_zh_")||name.StartsWith("gml_Script_scr_save")||name.StartsWith("gml_Script_scr_load"))continue;
 foreach(var ins in code.Instructions) {
  if(ins.ValueString==null||ins.Type1!=UndertaleInstruction.DataType.String)continue;
  string en=ins.ValueString.Resource.Content;
  if(protectedText.Contains(en)||!stringMap.TryGetValue(en,out var zh))continue;
  ins.ValueString=new UndertaleResourceById<UndertaleString,UndertaleChunkSTRG>{Resource=Data.Strings.MakeString(zh)};
  touched.Add(en);changed++;
 }
}
Console.WriteLine($"Translated literal references={changed}; unique={touched.Count}");
