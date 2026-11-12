if(global.zh_load_active || global.zh_panel || global.zh_input_cooldown>0)return false;
var key=argument0, touched=false;
if(os_type==os_android && instance_exists(o_android_controls)) {
 var ctl=o_android_controls;
 switch(key) {
 case ord("K"): case ord("Z"): case vk_space: touched=ctl.button_K.button_pressionado; break;
 case ord("L"): case ord("X"): case ord("Q"): touched=ctl.button_L.button_pressionado; break;
 case vk_enter: case vk_tab: touched=ctl.button_tab.button_pressionado; break;
 }
}
return keyboard_check_pressed(key) || touched || zh_pad_key(key,1);
