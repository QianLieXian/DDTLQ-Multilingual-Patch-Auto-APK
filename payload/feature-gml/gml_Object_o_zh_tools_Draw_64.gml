var of=fnt_heartbit2,oc=draw_get_color(),oa=draw_get_alpha(),oh=fa_left,ov=fa_top;
draw_set_font(fnt_heartbit2);draw_set_halign(fa_left);draw_set_valign(fa_top);draw_set_alpha(0.85);draw_set_color(c_black);
if(!global.zh_port_mode){draw_rectangle(346,2,384,24,false);draw_set_alpha(1);draw_set_color(c_white);draw_text(350,6,"助手");}
if(panel){
 draw_set_alpha(0.94);draw_set_color(c_black);draw_rectangle(62,20,322,176,false);draw_set_alpha(1);draw_set_color(c_white);
 draw_text(70,23,"助手：方向选择，确认执行，返回关闭");
 draw_set_color(make_color_rgb(70,55,90));draw_rectangle(64,40+zh_choice*22,320,61+zh_choice*22,false);draw_set_color(c_white);
 draw_text(70,42,"F6 画廊全开："+string(global.zh_gallery));
 draw_text(70,64,"F8 持续回血回蓝："+string(global.zh_cheat));
 draw_text(70,86,"F7 弧币增加十万");
 draw_text(70,108,"F10 原版调试："+string(global.Dev));
 draw_text(70,130,"F11 生成全任务状态副本");
 draw_text(70,152,"F12 读取全任务状态副本");
}
if(hint_timer>0){draw_set_alpha(0.95);draw_set_color(c_black);draw_rectangle(0,194,384,216,false);draw_set_alpha(1);draw_set_color(c_white);draw_text(3,196,hint);}
draw_set_font(of);draw_set_color(oc);draw_set_alpha(oa);draw_set_halign(oh);draw_set_valign(ov);
