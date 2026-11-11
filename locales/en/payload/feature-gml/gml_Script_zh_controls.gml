var oldfont=fnt_heartbit2, oldcolor=draw_get_color(), oldalpha=draw_get_alpha();
var oldh=fa_left,oldv=fa_top;
draw_set_alpha(1); draw_set_color(make_color_rgb(34,34,34)); draw_rectangle(0,0,384,216,false);
draw_set_font(3); draw_set_color(c_white); draw_set_halign(fa_left);draw_set_valign(fa_top);
var scheme=argument0, moving="Directional buttons", accept="Z", back="X", pause="Enter";
if(scheme==1){moving="W A S D";accept="K";back="L";}
if(scheme==2){moving="W A S D";accept="Spacebar";back="Q";pause="Tab";}
if(os_type==os_android){moving="Left analog stick";accept="Confirm button on the right / Z";back="Back button on the right / X";pause="Pause button at the bottom";}
draw_text(20,52,moving+": Move");
draw_text(20,84,accept+": Confirm / Talk / Interact / Run");
draw_text(20,116,back+": Cancel / Back");
draw_text(20,148,pause+": Menu / Pause / Quit battle");
draw_text(20,180,"Touch or mouse: drag blocks    N: Fullscreen");
draw_set_font(oldfont);draw_set_color(oldcolor);draw_set_alpha(oldalpha);draw_set_halign(oldh);draw_set_valign(oldv);
