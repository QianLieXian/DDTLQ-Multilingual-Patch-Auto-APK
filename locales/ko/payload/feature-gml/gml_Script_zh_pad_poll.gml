if(!variable_global_exists("zh_pad_device"))zh_pad_init();
var old_device=global.zh_pad_device,device=old_device;
if(device<0 || !gamepad_is_connected(device)){
 device=-1;
 for(var j=0;j<12;j+=1)if(gamepad_is_connected(j)){device=j;break;}
}
if(device!=old_device || room!=global.zh_pad_room){global.zh_pad_ready=false;global.zh_pad_cursor=false;}
global.zh_pad_room=room;global.zh_pad_device=device;
var next;
var focused=window_has_focus() && !global.zh_load_active;
if(!focused){global.zh_pad_ready=false;global.zh_pad_cursor=false;}
var lx=0,ly=0,rx=0,ry=0,neutral=true;
for(var i=0;i<12;i+=1)next[i]=false;
if(device>=0 && focused){
 lx=gamepad_axis_value(device,gp_axislh);ly=gamepad_axis_value(device,gp_axislv);
 rx=gamepad_axis_value(device,gp_axisrh);ry=gamepad_axis_value(device,gp_axisrv);
 next[0]=gamepad_button_check(device,gp_padu) || ly<-(global.zh_pad_down[0]?0.20:0.28);
 next[1]=gamepad_button_check(device,gp_padd) || ly>(global.zh_pad_down[1]?0.20:0.28);
 next[2]=gamepad_button_check(device,gp_padl) || lx<-(global.zh_pad_down[2]?0.20:0.28);
 next[3]=gamepad_button_check(device,gp_padr) || lx>(global.zh_pad_down[3]?0.20:0.28);
 next[4]=gamepad_button_check(device,gp_face1);
 next[5]=gamepad_button_check(device,gp_face2);
 next[6]=gamepad_button_check(device,gp_start);
 next[7]=gamepad_button_check(device,gp_face4) || gamepad_button_check(device,gp_select);
 next[8]=gamepad_button_check(device,gp_shoulderrb) || gamepad_button_check(device,gp_face3);
 next[9]=gamepad_button_check(device,gp_shoulderlb);
 next[10]=gamepad_button_check(device,gp_shoulderl);
 next[11]=gamepad_button_check(device,gp_shoulderr);
 for(var i=0;i<12;i+=1)if(next[i])neutral=false;
 if(abs(lx)>0.20 || abs(ly)>0.20 || abs(rx)>0.20 || abs(ry)>0.20)neutral=false;
 if(next[0]&&next[1]){next[0]=false;next[1]=false;}
 if(next[2]&&next[3]){next[2]=false;next[3]=false;}
}
if(!global.zh_pad_ready){
 if(device>=0 && focused && neutral)global.zh_pad_ready=true;
 for(var i=0;i<12;i+=1)next[i]=false;
 rx=0;ry=0;
}
if(device<0){global.zh_pad_ready=false;global.zh_pad_cursor=false;}
for(var i=0;i<12;i+=1){
 var before=global.zh_pad_down[i];
 global.zh_pad_down[i]=next[i];
 global.zh_pad_pressed[i]=next[i] && !before;
 global.zh_pad_released[i]=!next[i] && before;
 if(next[i])global.zh_pad_hold[i]+=1;else global.zh_pad_hold[i]=0;
 if(i<4 && global.zh_pad_hold[i]>=24 && (global.zh_pad_hold[i]-24) mod 6==0)global.zh_pad_pressed[i]=true;
}
var mx=device_mouse_x_to_gui(0),my=device_mouse_y_to_gui(0);
if(point_distance(mx,my,global.zh_pad_real_x,global.zh_pad_real_y)>1)global.zh_pad_cursor=false;
global.zh_pad_real_x=mx;global.zh_pad_real_y=my;
var vx=0,vy=0;
if(abs(rx)>0.20)vx=sign(rx)*(abs(rx)-0.20)/0.80;
if(abs(ry)>0.20)vy=sign(ry)*(abs(ry)-0.20)/0.80;
if(vx!=0 || vy!=0 || global.zh_pad_pressed[8] || global.zh_pad_pressed[9]){
 if(!global.zh_pad_cursor){global.zh_pad_x=clamp(mx,0,display_get_gui_width()-1);global.zh_pad_y=clamp(my,0,display_get_gui_height()-1);}
 global.zh_pad_cursor=true;
 var pace=3;if(global.zh_pad_down[10])pace=1;if(global.zh_pad_down[11])pace=6;
 global.zh_pad_x=clamp(global.zh_pad_x+vx*pace,0,display_get_gui_width()-1);
 global.zh_pad_y=clamp(global.zh_pad_y+vy*pace,0,display_get_gui_height()-1);
}
// Native mouse-event objects need an explicit event for the virtual cursor.
if(global.zh_pad_released[8] && !mouse_check_button(mb_left)){
 with(o_square)if(state=="dragging")event_perform(ev_mouse,ev_left_release);
 with(o_square_respald)if(dragging && !swiped){dragging=0;stable=1;selected=0;global.freeze=0;}
}
if(global.zh_pad_pressed[8] && !mouse_check_button(mb_left) && global.zh_pad_cursor && !global.zh_panel && global.zh_input_cooldown<=0 && !global.zh_pad_pressed[7]){
 var wx=zh_mouse_x(),wy=zh_mouse_y();
 var target=collision_point(wx,wy,o_square,true,true);
 if(target==noone)target=collision_point(wx,wy,o_square_respald,true,true);
 if(target!=noone)with(target)event_perform(ev_mouse,ev_left_press);
}
