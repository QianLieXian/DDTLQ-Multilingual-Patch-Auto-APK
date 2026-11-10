if(global.zh_fix_countdown>0){global.zh_fix_countdown-=1;if(global.zh_fix_countdown==0){with(o_line_overworld)zh_safe_spawn();}}
if(hint_timer>0)hint_timer-=1;
var action=-1;
if(keyboard_check_pressed(vk_f6))action=0;
if(keyboard_check_pressed(vk_f7))action=2;
if(keyboard_check_pressed(vk_f8))action=1;
if(keyboard_check_pressed(vk_f10))action=3;
if(keyboard_check_pressed(vk_f11))action=4;
if(keyboard_check_pressed(vk_f12))action=5;
if(global.zh_input_cooldown>0)global.zh_input_cooldown-=1;
if(keyboard_check_pressed(vk_f9)){panel=!panel;zh_tap_wait=0;global.zh_input_cooldown=3;}
if(panel){
 if(keyboard_check_pressed(vk_up))zh_choice=(zh_choice+5) mod 6;
 if(keyboard_check_pressed(vk_down))zh_choice=(zh_choice+1) mod 6;
 if(keyboard_check_pressed(ord("X"))||keyboard_check_pressed(vk_escape)){panel=false;global.zh_input_cooldown=3;}
 else if(global.zh_input_cooldown==0 && (keyboard_check_pressed(ord("Z"))||keyboard_check_pressed(vk_enter))){action=zh_choice;global.zh_input_cooldown=3;}
}
// Sample one frame after release: Android updates cursor coordinates after Step.
if(zh_tap_wait>0){
 zh_tap_wait-=1;
 if(zh_tap_wait==0){
  var px=device_mouse_x_to_gui(0),py=device_mouse_y_to_gui(0);
  if(!global.zh_port_mode && px>=346 && px<384 && py>=2 && py<24 && zh_tap_x>=346 && zh_tap_y<24){panel=!panel;global.zh_input_cooldown=3;}
  else if(panel && px>=62 && px<322 && py>=40 && py<172 && zh_tap_x>=62 && zh_tap_x<322 && zh_tap_y>=40 && zh_tap_y<172){
   var row=floor((py-40)/22);
   if(row==floor((zh_tap_y-40)/22)){zh_choice=row;action=row;global.zh_input_cooldown=3;}
  }
 }
}
if(mouse_check_button(mb_left)){zh_tap_x=device_mouse_x_to_gui(0);zh_tap_y=device_mouse_y_to_gui(0);}
if(mouse_check_button_released(mb_left))zh_tap_wait=1;
global.zh_panel=panel;
if(action==0){global.zh_gallery=1-global.zh_gallery;hint="画廊开关已更新，重新打开画廊生效。";zh_settings_save();}
if(action==1){global.zh_cheat=1-global.zh_cheat;hint="持续回血回蓝开关已更新。";zh_settings_save();}
if(action==2){o_start_variables.Arcs+=100000;hint="已增加十万弧币。";}
if(action==3){global.Dev=1-global.Dev;hint="原版调试开关已更新。";zh_settings_save();}
if(action==4){if(zh_full_save())hint="已生成任务全进度副本，原进度未改变。";else hint="请在城镇自由行动时生成存档。";}
if(action==5){if(file_exists("Memory Quartz Line 99.ini")){
 if(file_exists("Memory Quartz Line 0.ini"))file_copy("Memory Quartz Line 0.ini","Memory Quartz Line 0.before-fullsave-"+string(date_current_datetime())+"-"+string(current_time)+".ini");
 scr_load_game(99);hint="已读取全进度副本。";
}else hint="尚未生成全进度副本。";}
if(action>=0)hint_timer=240;
if(global.zh_cheat){with(o_line){Hp=Max_Hp;Mp=Max_Mp;}with(o_companion){Hp=Max_Hp;}}
