if(argument0==0 && variable_global_exists("zh_pad_device") && global.zh_pad_cursor)return global.zh_pad_y;
return device_mouse_y_to_gui(argument0);
