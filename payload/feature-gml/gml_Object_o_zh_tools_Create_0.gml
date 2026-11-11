persistent=true; visible=true; panel=false; hint=""; hint_timer=0;
global.zh_gallery=0;global.zh_dex=0;global.zh_cheat=0;global.zh_fix_countdown=0;
if(file_exists("DDTLQ_ZH.ini")) {
 ini_open("DDTLQ_ZH.ini");
 global.zh_dex=ini_read_real("Helper","Dex",0);
 global.zh_gallery=ini_read_real("Helper","Gallery",0);
 global.zh_cheat=ini_read_real("Helper","Recovery",0);
 global.Dev=ini_read_real("Helper","Debug",0);
 ini_close();
}

global.zh_port_mode=false;global.zh_panel=false;global.zh_input_cooldown=0;zh_choice=0;zh_tap_wait=0;zh_tap_x=-1;zh_tap_y=-1;

global.zh_load_active=false;global.zh_load_error="";