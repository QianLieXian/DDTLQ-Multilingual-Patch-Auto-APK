if(global.zh_load_active){zh_finish_load();return;}
if(global.zh_fix_countdown>0){global.zh_fix_countdown-=1;if(global.zh_fix_countdown==0){with(o_line_overworld)zh_safe_spawn();}}
if(hint_timer>0)hint_timer-=1;
var action=-1;
if(keyboard_check_pressed(vk_f5))action=6;
if(keyboard_check_pressed(vk_f6))action=0;
if(keyboard_check_pressed(vk_f7))action=2;
if(keyboard_check_pressed(vk_f8))action=1;
if(keyboard_check_pressed(vk_f10))action=3;
if(keyboard_check_pressed(vk_f11))action=4;
if(keyboard_check_pressed(vk_f12))action=5;
if(global.zh_input_cooldown>0)global.zh_input_cooldown-=1;
if((keyboard_check_pressed(vk_f9) || zh_pad_key(vk_f9,true))){panel=!panel;zh_tap_wait=0;zh_tap_x=-1;zh_tap_y=-1;global.zh_input_cooldown=3;}
if(panel){
 if((keyboard_check_pressed(vk_up) || zh_pad_key(vk_up,true)))zh_choice=(zh_choice+6) mod 7;
 if((keyboard_check_pressed(vk_down) || zh_pad_key(vk_down,true)))zh_choice=(zh_choice+1) mod 7;
 if((keyboard_check_pressed(ord("X")) || zh_pad_key(ord("X"),true))||keyboard_check_pressed(vk_escape)){panel=false;global.zh_input_cooldown=3;}
 else if(global.zh_input_cooldown==0 && ((keyboard_check_pressed(ord("Z")) || zh_pad_key(ord("Z"),true))||keyboard_check_pressed(vk_enter))){action=zh_choice;global.zh_input_cooldown=3;}
}
// Sample one frame after release: Android updates cursor coordinates after Step.
if(zh_tap_wait>0){
 zh_tap_wait-=1;
 if(zh_tap_wait==0){
  var px=zh_device_mouse_x_to_gui(0),py=zh_device_mouse_y_to_gui(0);
  if(!global.zh_port_mode && px>=342 && px<384 && py>=2 && py<24 && zh_tap_x>=342 && zh_tap_y<24){panel=!panel;global.zh_input_cooldown=3;}
  else if(panel && global.zh_input_cooldown==0 && px>=42 && px<342 && py>=40 && py<180 && zh_tap_x>=42 && zh_tap_x<342 && zh_tap_y>=40 && zh_tap_y<180 && floor((py-40)/20)==floor((zh_tap_y-40)/20) && point_distance(px,py,zh_tap_x,zh_tap_y)<=10){
   var row=floor((py-40)/20);
   zh_choice=row;action=row;global.zh_input_cooldown=3;
  }
 }
}
if(zh_mouse_raw(mb_left,1)){if(global.zh_input_cooldown==0){zh_tap_x=zh_device_mouse_x_to_gui(0);zh_tap_y=zh_device_mouse_y_to_gui(0);}else{zh_tap_x=-1;zh_tap_y=-1;}}
if(zh_mouse_raw(mb_left,2))zh_tap_wait=1;
global.zh_panel=panel;
if(action==6){global.zh_dex=1-global.zh_dex;hint="全图鉴开关已更新，剧情击败记录不变。";zh_settings_save();}
if(action==0){global.zh_gallery=1-global.zh_gallery;with(o_gallery)event_perform(ev_create,0);hint="画廊开关已更新。";zh_settings_save();}
if(action==1){global.zh_cheat=1-global.zh_cheat;hint="持续回血回蓝开关已更新。";zh_settings_save();}
if(action==2){o_start_variables.Arcs+=100000;hint="已增加十万弧币。";}
if(action==3){global.Dev=1-global.Dev;hint="原版调试开关已更新。";zh_settings_save();}
if(action==4){if(zh_full_save())hint="已生成资源副本，保留当前剧情进度。";else hint="请在城镇自由行动时生成存档。";}
if(action==5){if(instance_exists(o_textbox)||instance_exists(o_cutscene)||instance_exists(o_brain)||(instance_exists(o_pause)&&!instance_exists(o_start_menu))||instance_exists(o_fade_room)){hint="请先结束对白、战斗或过场再读档。";}else if(file_exists("Memory Quartz Line 99.ini")){
 if(file_exists("Memory Quartz Line 0.ini"))file_copy("Memory Quartz Line 0.ini","Memory Quartz Line 0.before-fullsave-"+string(date_current_datetime())+"-"+string(current_time)+".ini");
 scr_load_game(99);if(global.zh_load_active){with(o_brain_dressup){Actual_Menu="winky";pause=0;}panel=false;global.zh_panel=false;global.zh_input_cooldown=4;hint="正在读取存档并切换场景……";}else hint=global.zh_load_error;
}else hint="尚未生成辅助副本。";}
if(action>=0)hint_timer=240;
if(global.zh_cheat){with(o_line){Hp=Max_Hp;Mp=Max_Mp;}with(o_companion){Hp=Max_Hp;}}
