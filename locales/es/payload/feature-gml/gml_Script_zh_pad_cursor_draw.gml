if(!variable_global_exists("zh_pad_device") || !global.zh_pad_cursor)return;
var color=draw_get_color(),alpha=draw_get_alpha(),px=global.zh_pad_x,py=global.zh_pad_y;
draw_set_alpha(1);draw_set_color(c_black);draw_circle(px,py,4,false);
draw_set_color(c_yellow);draw_line(px-6,py,px+6,py);draw_line(px,py-6,px,py+6);
draw_set_color(color);draw_set_alpha(alpha);
