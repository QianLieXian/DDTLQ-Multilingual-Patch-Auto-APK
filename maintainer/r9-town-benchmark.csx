using System;using System.IO;using UndertaleModLib.Compiler;
var q=new CodeImportGroup(Data);q.QueueAppend("gml_Object_o_start_variables_Create_0","\nglobal.perf_boot=0;global.perf_town=0;\n");
q.QueueAppend("gml_Object_o_start_variables_Step_0",@"
if(global.perf_boot==0 && room==rm_Main_menu && !instance_exists(o_fade_room)){
 global.perf_boot=1;scr_load_game(99);show_debug_message(""PERF_LOAD_99"");
}
if(room==rm_City && !global.zh_load_active){
 global.time=0.9;global.perf_town+=1;
 if(global.perf_town==1)show_debug_message(""PERF_TOWN|instances=""+string(instance_count));
 if(global.perf_town==360)show_debug_message(""PERF_TOWN_360|filter=""+string(gpu_get_texfilter())+""|time=""+string(global.time));
}
");var result=q.Import();if(!result.Successful)throw new Exception(result.PrintAllErrors(true));