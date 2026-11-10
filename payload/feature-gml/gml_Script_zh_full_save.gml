if(instance_exists(o_start_menu)||instance_exists(o_introduction)||!instance_exists(o_line_overworld)||!instance_exists(o_quest_system)||instance_exists(o_brain)||instance_exists(o_textbox)||instance_exists(o_cutscene)||instance_exists(o_fade_room))return false;
with(o_line_overworld){if(place_meeting(x,y,o_wall))return false;}
// Copy the real quest state. Terminal flags cannot substitute for a played story.
if(file_exists("Memory Quartz Line 99.ini"))file_copy("Memory Quartz Line 99.ini","Memory Quartz Line 99.before-copy-"+string(current_time)+".ini");
var oldmoney=o_start_variables.Arcs;
o_start_variables.Arcs=max(oldmoney,999999);scr_save_game(99);o_start_variables.Arcs=oldmoney;
ini_open("Memory Quartz Line 99.ini");ini_write_real("PatchMetadata","SafeCopy",3);ini_close();
return true;
