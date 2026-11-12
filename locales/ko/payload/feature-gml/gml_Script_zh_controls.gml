var oldfont=fnt_heartbit2, oldcolor=draw_get_color(), oldalpha=draw_get_alpha();
var oldh=fa_left,oldv=fa_top;
draw_set_alpha(1); draw_set_color(make_color_rgb(34,34,34)); draw_rectangle(0,0,384,216,false);
draw_set_font(3); draw_set_color(c_white); draw_set_halign(fa_left);draw_set_valign(fa_top);
var scheme=argument0, moving="방향키", accept="Z", back="X", pause="Enter";
if(scheme==1){moving="W A S D";accept="K";back="L";}
if(scheme==2){moving="W A S D";accept="스페이스바";back="Q";pause="Tab";}
if(os_type==os_android){moving="왼쪽 스틱";accept="오른쪽 확인 버튼(Z)";back="오른쪽 뒤로 가기 버튼(X)";pause="하단 일시정지 버튼";}
if(variable_global_exists("zh_pad_device") && global.zh_pad_device>=0){moving="Xbox LS / D-Pad";accept="A";back="B";pause="Start";}
draw_text(20,52,moving+"：이동");
draw_text(20,84,accept+"：확인／대화／상호작용／달리기");
draw_text(20,116,back+"：취소／뒤로");
draw_text(20,148,pause+"：메뉴／일시정지／전투 종료");
if(variable_global_exists("zh_pad_device") && global.zh_pad_device>=0)draw_text(20,180,"RS + RT/X | LT | LB/RB | Y/View");else draw_text(20,180,"터치 또는 마우스: 블록 드래그    N: 전체 화면");
draw_set_font(oldfont);draw_set_color(oldcolor);draw_set_alpha(oldalpha);draw_set_halign(oldh);draw_set_valign(oldv);
