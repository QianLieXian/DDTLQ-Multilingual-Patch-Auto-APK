if(!global.zh_load_active)return;
global.zh_input_cooldown=5;
global.zh_load_wait-=1;
if(global.zh_load_wait==179){
 with(o_start_menu)instance_destroy();
 with(o_fade_room)instance_destroy();
}
if(room!=global.zh_load_target){
 global.zh_load_stable=0;
 // Use the same deferred room assignment as the game's own transitions.
 if(global.zh_load_wait==179 || (global.zh_load_wait mod 15)==0)room=global.zh_load_target;
}
else if(instance_exists(o_line_overworld) && !instance_exists(o_start_menu)){
 global.zh_load_stable+=1;
 with(o_line_overworld){x=global.zh_load_x;y=global.zh_load_y;hsp=0;vsp=0;show=1;visible=true;}
 o_start_variables.xx=global.zh_load_x;o_start_variables.yy=global.zh_load_y;
 with(o_brain_dressup){Actual_Menu="winky";pause=0;}
 if(global.zh_load_stable>=3){
  with(o_line_overworld)zh_safe_spawn();
  with(o_cam){x=o_line_overworld.x;y=o_line_overworld.y;}
  global.zh_load_active=false;global.zh_fix_countdown=3;
  panel=false;global.zh_panel=false;
  if(room==rm_City)hint="Has entrado en el pueblo. Partida cargada correctamente.";else hint="Se ha cambiado a la escena de la partida. Carga completada.";
  hint_timer=240;
 }
}
if(global.zh_load_active && global.zh_load_wait<=0){
 global.zh_load_active=false;global.zh_input_cooldown=3;
 hint="No se pudo cambiar de escena. Vuelve a cargar la partida.";hint_timer=300;
}
