using System;using System.IO;using System.Linq;using UndertaleModLib.Compiler;using UndertaleModLib.Decompiler;
// Run against a translated r8 data file, never against the released game in place.
var original=Data.Code.First(c=>c.Name.Content=="gml_Script_NineSliceBox");
if(original.Instructions.Any(i=>i.ValueFunction!=null&&i.ValueFunction.Name.Content=="gpu_get_texfilter"))throw new Exception("Render comparison needs pre-r9 translated data as its reference.");
var ctx=new GlobalDecompileContext(Data);var text=new Underanalyzer.Decompiler.DecompileContext(ctx,original,Data.ToolInfo.DecompilerSettings).DecompileToString();
var root=Path.GetDirectoryName(ScriptPath);var q=new CodeImportGroup(Data);
q.QueueReplace("gml_Script_qa_original_nineslice",text);
q.QueueReplace("gml_Script_NineSliceBox",File.ReadAllText(Path.Combine(root,"..","payload","feature-gml","gml_Script_NineSliceBox.gml")));
q.QueueAppend("gml_Object_o_start_variables_Create_0","\nglobal.qa_visual_done=false;\n");
q.QueueAppend("gml_Object_o_start_variables_Draw_75",File.ReadAllText(Path.Combine(root,"r9-qa-render.gml")));
var result=q.Import();if(!result.Successful)throw new Exception(result.PrintAllErrors(true));