if(variable_global_exists("zh_pad_device") && global.zh_pad_cursor){
 if(view_enabled)return view_yview[0]+global.zh_pad_y/max(1,display_get_gui_height())*view_hview[0];
 return global.zh_pad_y/max(1,display_get_gui_height())*room_height;
}
return mouse_y;
