var oldfont=fnt_heartbit2, oldcolor=draw_get_color(), oldalpha=draw_get_alpha();
var oldh=fa_left,oldv=fa_top;
draw_set_alpha(1); draw_set_color(make_color_rgb(34,34,34)); draw_rectangle(0,0,384,216,false);
draw_set_font(fnt_heartbit2); draw_set_color(c_white); draw_set_halign(fa_left);draw_set_valign(fa_top);
var scheme=argument0, moving="方向键", accept="Z", back="X", pause="Enter";
if(scheme==1){moving="W A S D";accept="K";back="L";}
if(scheme==2){moving="W A S D";accept="空格";back="Q";pause="Tab";}
if(os_type==os_android){moving="左侧摇杆";accept="右侧 K";back="右侧 L";pause="左侧暂停键";}
draw_text(20,52,moving+"：移动");
draw_text(20,84,accept+"：确认／交谈／交互／奔跑");
draw_text(20,116,back+"：取消／返回");
draw_text(20,148,pause+"：菜单／暂停／退出战斗");
draw_text(20,180,"触摸或鼠标：拖动方块    N：全屏");
draw_set_font(oldfont);draw_set_color(oldcolor);draw_set_alpha(oldalpha);draw_set_halign(oldh);draw_set_valign(oldv);
