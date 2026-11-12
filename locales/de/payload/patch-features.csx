using System;
using System.IO;
using System.Linq;
using System.Text.Json;
using UndertaleModLib.Compiler;
using UndertaleModLib.Models;
var featureRoot=Path.GetDirectoryName(ScriptPath);
if(Data.GeneralInfo.BytecodeVersion!=17||Data.Fonts.Count!=3||!Data.Strings.Any(s=>s.Content.StartsWith("2.01.04"))||!Data.GameObjects.Any(o=>o.Name.Content=="o_start_variables"))throw new Exception("Unsupported game/version; expected original DDTLQ 2.01.04 VM17");
var import=new CodeImportGroup(Data);
foreach(var file in Directory.GetFiles(Path.Combine(featureRoot,"feature-gml"),"*.gml").OrderBy(x=>x))if(!Path.GetFileName(file).StartsWith("gml_Object_"))import.QueueReplace(Path.GetFileNameWithoutExtension(file),File.ReadAllText(file).Replace("__ZH_ROOM_COUNT__",Data.Rooms.Count.ToString()));

// Rewrite only real mouse-coordinate identifiers, preserving quoted game text.
var padDecompile=new UndertaleModLib.Decompiler.GlobalDecompileContext(Data);
foreach(var code in Data.Code.ToArray()){
 if(!code.Instructions.Any(i=>i.ValueVariable!=null && (i.ValueVariable.Name.Content=="mouse_x" || i.ValueVariable.Name.Content=="mouse_y")))continue;
 var original=new Underanalyzer.Decompiler.DecompileContext(padDecompile,code,Data.ToolInfo.DecompilerSettings).DecompileToString();
 var rewritten=System.Text.RegularExpressions.Regex.Replace(original,@"""(?:\\.|[^""\\])*""|\bmouse_[xy]\b",m=>m.Value.StartsWith("\"")?m.Value:(m.Value=="mouse_x"?"zh_mouse_x()":"zh_mouse_y()"));
 import.QueueReplace(code,rewritten);
}
import.QueueAppend(Data.GameObjects.First(o=>o.Name.Content=="o_start_variables").EventHandlerFor(EventType.Step,EventSubtypeStep.BeginStep,Data),"zh_pad_poll();");
import.QueueAppend("gml_Object_o_start_variables_Create_0","\nzh_pad_init();\n");

import.QueueReplace("gml_Script_string_wrap",File.ReadAllText(Path.Combine(featureRoot,"feature-gml","gml_Script_zh_wrap.gml")));
import.QueueAppend("gml_Object_o_start_variables_Create_0",File.ReadAllText(Path.Combine(featureRoot,"feature-gml","gml_Object_o_zh_tools_Create_0.gml")));
import.QueueAppend("gml_Object_o_start_variables_Create_0","\nif(os_type==os_android)global.controls=1;\n");
import.QueueAppend("gml_Object_o_start_variables_Step_0","zh_helper_step();");
import.QueueAppend("gml_Object_o_start_variables_Draw_75",File.ReadAllText(Path.Combine(featureRoot,"feature-gml","gml_Object_o_zh_tools_Draw_64.gml")));
import.QueueAppend("gml_Script_scr_load_game","\nglobal.zh_fix_countdown=3;\n");
import.QueuePrepend("gml_Script_scr_load_game","if(!zh_prepare_load(argument0))exit;\n");
import.QueueFindReplace("gml_Script_scr_load_game","room_goto(ini_read_real(sect[0], \"room\", 2));","o_start_variables.xx=global.zh_load_x;o_start_variables.yy=global.zh_load_y;",true);
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

// Display-only unlock: never mark enemies defeated or modify plot flags.
foreach(var code in new[]{"gml_Object_o_brain_dressup_Step_0","gml_Object_o_brain_dressup_Draw_64"})import.QueueFindReplace(code,"var ntw = enemy_index(80085, 0);","var ntw = 65;",true);
import.QueueFindReplace("gml_Object_o_brain_dressup_Step_0","var wp = waifu_page * 12;","if(index + waifu_page*12 >= 65){if(key_down_prs){index=0;waifu_page=0;}else index=max(0,64-waifu_page*12);} var wp = waifu_page * 12;",true);
import.QueueFindReplace("gml_Object_o_brain_dressup_Step_0","global.waifu[index + wp] == 1","(index + wp < 65 && (global.zh_dex || global.waifu[index + wp] == 1))",true);
import.QueueFindReplace("gml_Object_o_brain_dressup_Step_0","global.waifu[i + wp] == 1","(i + wp < 65 && (global.zh_dex || global.waifu[i + wp] == 1))",true);
import.QueueFindReplace("gml_Object_o_brain_dressup_Step_0","waif_text[i] = \"????\";","waif_text[i] = (i+wp>=65) ? \"\" : \"????\";",true);
foreach(var pair in new[]{new[]{"\"Strong against : \" + strong","\"Strong against : \" + zh_display(strong)"},new[]{"\"Weak against : \" + weak","\"Weak against : \" + zh_display(weak)"},new[]{"\"Name : \" + waif_text[index]","\"Name : \" + zh_display(waif_text[index])"},new[]{"\"Weak against : \" + str_wk","\"Weak against : \" + zh_display(str_wk)"},new[]{"\"Afinnity : \" + str_aff","\"Afinnity : \" + zh_display(str_aff)"}})import.QueueFindReplace("gml_Object_o_brain_dressup_Draw_64",pair[0],pair[1],true);
import.QueueAppend("gml_Script_scr_load_game","\nzh_migrate_synthetic_save(argument0);\n");

// Original bug: this fortune hint passes the list name inside the string.
var fortuneRows=JsonDocument.Parse(File.ReadAllText(Path.Combine(featureRoot,"translations.json"))).RootElement;
string fortuneHint=fortuneRows.EnumerateArray().First(r=>r.GetProperty("id").GetInt32()==4463).GetProperty("zh").GetString();
if(fortuneHint.StartsWith("text_adv_list,"))fortuneHint=fortuneHint.Substring("text_adv_list,".Length).TrimStart();
string fortuneLiteral="\""+fortuneHint.Replace("\\","\\\\").Replace("\"","\\\"").Replace("\n","\\n").Replace("\r","\\r")+"\"";
import.QueueFindReplace("gml_Object_o_shop_fortuneteller_Create_0","ds_list_add(\"text_adv_list,On the top floor, you will be met by someone whose attention has been captivated by your potential.\");","ds_list_add(text_adv_list, "+fortuneLiteral+");",true);

// Mouse events bypass polling wrappers: block clicks through the helper overlay.
foreach(var obj in new[]{"o_square","o_square_respald"})import.QueuePrepend("gml_Object_"+obj+"_Mouse_4","if(global.zh_load_active || global.zh_panel || global.zh_input_cooldown>0 || keyboard_check_pressed(vk_f9) || zh_pad_key(vk_f9,1))exit;\n");
import.QueuePrepend("gml_Object_o_square_Mouse_7","if(zh_mouse_raw(mb_left,0))exit;\n");

var result=import.Import();if(!result.Successful)throw new Exception(result.PrintAllErrors(true));
// Redirect only the original calls; wrappers keep their original built-in targets.
var wrapperNames=JsonDocument.Parse(File.ReadAllText(Path.Combine(featureRoot,"wrapper-functions.json"))).RootElement;
int redirected=0;
foreach(var code in Data.Code.Where(c=>!c.Name.Content.StartsWith("gml_Script_zh_")&&!c.Name.Content.StartsWith("gml_Object_o_zh_")&&c.Name.Content!="gml_Object_o_start_variables_Draw_75"))
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
