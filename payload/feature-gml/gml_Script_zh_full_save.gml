if(instance_exists(o_start_menu) || instance_exists(o_introduction) || !instance_exists(o_line_overworld) || !instance_exists(o_quest_system) || instance_exists(o_brain) || instance_exists(o_textbox)) return false;
with(o_line_overworld){if(place_meeting(x,y,o_wall))return false;}
var qu=o_quest_system, ac=o_achievements;
var oldmoney=o_start_variables.Arcs;
for(var j=0;j<qu.ds_quest_number;j+=1) {
 oldq[j]=ds_grid_get(qu.ds_quest,1,j);
 var stages=ds_grid_get(qu.ds_quest,2,j);
 ds_grid_set(qu.ds_quest,1,j,array_length_1d(stages)-1);
}
for(var j=0;j<ac.ds_quest_number;j+=1) {
 olda[j]=ds_grid_get(ac.ds_quest,1,j);ds_grid_set(ac.ds_quest,1,j,1);
}
o_start_variables.Arcs=max(oldmoney,999999);
scr_save_game(99);
for(var j=0;j<qu.ds_quest_number;j+=1)ds_grid_set(qu.ds_quest,1,j,oldq[j]);
for(var j=0;j<ac.ds_quest_number;j+=1)ds_grid_set(ac.ds_quest,1,j,olda[j]);
o_start_variables.Arcs=oldmoney;
return true;
