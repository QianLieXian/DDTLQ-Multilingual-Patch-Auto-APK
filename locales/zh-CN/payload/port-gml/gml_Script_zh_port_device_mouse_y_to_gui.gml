if(argument0!=0)return 0;
var gw=display_get_gui_width(),gh=display_get_gui_height(),ww=max(1,window_get_width()),hh=max(1,window_get_height());
var scale=min(ww/gw,hh/gh),top=(hh-gh*scale)/2;
return (device_mouse_y_to_gui(0)*scale+top)/hh*gh;
