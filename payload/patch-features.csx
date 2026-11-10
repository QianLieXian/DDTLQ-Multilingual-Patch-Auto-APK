using System;
using System.IO;
using System.Linq;
using System.Text.Json;
using UndertaleModLib.Compiler;
using UndertaleModLib.Models;
var featureRoot=Path.GetDirectoryName(ScriptPath);
if(Data.GeneralInfo.BytecodeVersion!=17||Data.Fonts.Count!=3||!Data.Strings.Any(s=>s.Content.StartsWith("2.01.04"))||!Data.GameObjects.Any(o=>o.Name.Content=="o_start_variables"))throw new Exception("Unsupported game/version; expected original DDTLQ 2.01.04 VM17");
var import=new CodeImportGroup(Data);
foreach(var file in Directory.GetFiles(Path.Combine(featureRoot,"feature-gml"),"*.gml").OrderBy(x=>x))if(!Path.GetFileName(file).StartsWith("gml_Object_"))import.QueueReplace(Path.GetFileNameWithoutExtension(file),File.ReadAllText(file));
import.QueueReplace("gml_Script_string_wrap",File.ReadAllText(Path.Combine(featureRoot,"feature-gml","gml_Script_zh_wrap.gml")));
import.QueueAppend("gml_Object_o_start_variables_Create_0",File.ReadAllText(Path.Combine(featureRoot,"feature-gml","gml_Object_o_zh_tools_Create_0.gml")));
import.QueueAppend("gml_Object_o_start_variables_Create_0","\nif(os_type==os_android)global.controls=1;\n");
import.QueueAppend("gml_Object_o_start_variables_Step_0","zh_helper_step();");
import.QueueAppend("gml_Object_o_start_variables_Draw_75",File.ReadAllText(Path.Combine(featureRoot,"feature-gml","gml_Object_o_zh_tools_Draw_64.gml")));
import.QueueAppend("gml_Script_scr_load_game","\nglobal.zh_fix_countdown=3;\n");
import.QueueFindReplace("gml_Object_o_gallery_Create_0","limit_i = 18;","limit_i = 13;",true);
import.QueueFindReplace("gml_Object_o_gallery_Create_0","Total_pages = floor((p + 1) / limit_i);","Total_pages = max(0, ceil(p / 14) - 1);",true);
import.QueueAppend("gml_Object_o_gallery_Create_0","\nif(global.zh_gallery){for(var zh_i=0;zh_i<p;zh_i+=1)completed[zh_i]=1;}\nfor(var zh_i=p;zh_i<100;zh_i+=1)completed[zh_i]=0;\n");
import.QueueFindReplace("gml_Object_o_gallery_Draw_64","var space_ = 10;","var space_ = 14;",true);
import.QueueFindReplace("gml_Object_o_gallery_Draw_64","i < 19","i < 14",true);
import.QueueFindReplace("gml_Object_o_gallery_Draw_64","(19 * page)","(14 * page)",true);
import.QueueFindReplace("gml_Object_o_gallery_Draw_64","(page * 19)","(page * 14)",true);
import.QueueFindReplace("gml_Object_o_gallery_Step_0","(19 * page)","(14 * page)",true);
string controlsOriginal="draw_sprite_ext(spr_controls_squeme, index, 0, 0, image_xscale, image_yscale, image_angle, image_blend, image_alpha);";
import.ThrowOnNoOpFindReplace=true;
foreach(var code in new[]{"gml_Object_o_brain_Draw_64","gml_Object_o_brain1_Draw_64","gml_Object_o_brain2_Draw_64","gml_Object_o_brain_dressup_Draw_64","gml_Object_o_gallery_Draw_64"})import.QueueFindReplace(code,"set_font_vha(2,","set_font_vha(3,",true);
import.QueueFindReplace("gml_Object_o_brain_dressup_Draw_64","var next_l = string_width(\"Nature 50 \");","var next_l = 60;",true);
import.QueueFindReplace("gml_Object_o_brain_dressup_Draw_64","var next_int = string_width(\"Nature \");","var next_int = max(26, string_width(\"Nature \") + 6);",true);
import.QueueFindReplace("gml_Object_o_brain_dressup_Draw_64","var next_int2 = string_width(\"Piercing \");","var next_int2 = max(26, string_width(\"Piercing \") + 6);",true);
import.QueueFindReplace("gml_Object_o_brain_Draw_64","var space = 5;","var space = 6;",true);
foreach(var code in new[]{"gml_Object_o_start_menu_Draw_64","gml_Object_o_brain_dressup_Draw_64"})import.QueueFindReplace(code,controlsOriginal,"zh_controls(index);",true);
var result=import.Import();if(!result.Successful)throw new Exception(result.PrintAllErrors(true));
// Redirect only the original calls; wrappers keep their original built-in targets.
var wrapperNames=JsonDocument.Parse(File.ReadAllText(Path.Combine(featureRoot,"wrapper-functions.json"))).RootElement;
int redirected=0;
foreach(var code in Data.Code.Where(c=>!c.Name.Content.StartsWith("gml_Script_zh_")&&!c.Name.Content.StartsWith("gml_Object_o_zh_")))
 foreach(var ins in code.Instructions)
  if(ins.Kind==UndertaleInstruction.Opcode.Call&&ins.ValueFunction!=null)
   foreach(var name in wrapperNames.EnumerateArray())
    if(ins.ValueFunction.Name.Content==name.GetString()){
     string target="zh_"+name.GetString();
     var function=Data.Functions.FirstOrDefault(f=>f.Name.Content==target||f.Name.Content=="gml_Script_"+target);
     if(function==null)throw new Exception("Missing wrapper "+target+"; available="+string.Join(",",Data.Functions.Where(f=>f.Name.Content.Contains("zh_")).Select(f=>f.Name.Content)));
     ins.ValueFunction=function;redirected++;break;
    }
Console.WriteLine("Display calls redirected="+redirected);
