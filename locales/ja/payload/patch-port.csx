using System;
using System.IO;
using System.Linq;
using System.Text.Json;
using UndertaleModLib.Compiler;
using UndertaleModLib.Models;
var portRoot=Path.GetDirectoryName(ScriptPath);
var portImport=new CodeImportGroup(Data);
portImport.QueueAppend("gml_Script_scr_load_game","\nzh_repair_equipment();\n");
foreach(var f in Directory.GetFiles(Path.Combine(portRoot,"port-gml"),"*.gml"))portImport.QueueReplace(Path.GetFileNameWithoutExtension(f),File.ReadAllText(f));
// The Android host supplies real key events from its multitouch virtual controls.
portImport.QueueAppend("gml_Object_o_start_variables_Create_0","\nglobal.controls=0;global.zh_port_mode=true;zh_repair_equipment();\n");
portImport.QueueAppend("gml_Object_o_start_variables_Step_0","\nwith(o_fade_room){if(room==cuarto && step==1 && counter>=30){step=2;counter=60;}}\n");
foreach(var function in new[]{"keyboard_check","keyboard_check_pressed"}) {
 string prefix="if(global.zh_panel || global.zh_input_cooldown>0)return false;\nswitch(argument0){\n";
 foreach(var pair in new[]{new[]{"ord(\"W\")","vk_up"},new[]{"ord(\"S\")","vk_down"},new[]{"ord(\"A\")","vk_left"},new[]{"ord(\"D\")","vk_right"},new[]{"ord(\"K\")","ord(\"Z\")"},new[]{"vk_space","ord(\"Z\")"},new[]{"ord(\"L\")","ord(\"X\")"},new[]{"ord(\"Q\")","ord(\"X\")"},new[]{"vk_tab","vk_enter"}})
  prefix+="case "+pair[0]+": return "+function+"(argument0)||"+function+"("+pair[1]+");\n";
 prefix+="}\n";portImport.QueuePrepend("gml_Script_zh_"+function,prefix);
}
portImport.ThrowOnNoOpFindReplace=true;
portImport.QueueFindReplace("gml_Object_o_fade_room_Step_0","room = cuarto;","if(room!=cuarto)room=cuarto;",true);
var portResult=portImport.Import();if(!portResult.Successful)throw new Exception(portResult.PrintAllErrors(true));
var portNames=JsonDocument.Parse(File.ReadAllText(Path.Combine(portRoot,"port-functions.json"))).RootElement.EnumerateArray().Select(n=>n.GetString()).ToHashSet();
int portCalls=0;
foreach(var code in Data.Code.Where(c=>!c.Name.Content.StartsWith("gml_Script_zh_port_")))foreach(var ins in code.Instructions)
if(ins.Kind==UndertaleInstruction.Opcode.Call&&ins.ValueFunction!=null&&portNames.Contains(ins.ValueFunction.Name.Content)){
var target="zh_port_"+ins.ValueFunction.Name.Content;ins.ValueFunction=Data.Functions.First(f=>f.Name.Content==target);portCalls++;
}
Console.WriteLine("Open runner compatibility calls="+portCalls);
