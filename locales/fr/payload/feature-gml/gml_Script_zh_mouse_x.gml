if(variable_global_exists("zh_pad_device") && global.zh_pad_cursor){
 if(view_enabled)return view_xview[0]+global.zh_pad_x/max(1,display_get_gui_width())*view_wview[0];
 return global.zh_pad_x/max(1,display_get_gui_width())*room_width;
}
return mouse_x;
