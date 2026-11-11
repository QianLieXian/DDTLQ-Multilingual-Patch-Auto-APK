if(argument0!=0)return 0;
var gw=display_get_gui_width(),gh=display_get_gui_height(),ww=max(1,window_get_width()),hh=max(1,window_get_height());
var scale=min(ww/gw,hh/gh),left=(ww-gw*scale)/2;
return (device_mouse_x_to_gui(0)*scale+left)/ww*gw;
