var oldfont=fnt_heartbit2, oldcolor=draw_get_color(), oldalpha=draw_get_alpha();
var oldh=fa_left,oldv=fa_top;
draw_set_alpha(1); draw_set_color(make_color_rgb(34,34,34)); draw_rectangle(0,0,384,216,false);
draw_set_font(3); draw_set_color(c_white); draw_set_halign(fa_left);draw_set_valign(fa_top);
var scheme=argument0, moving="方向キー", accept="Z", back="X", pause="Enter";
if(scheme==1){moving="W A S D";accept="K";back="L";}
if(scheme==2){moving="W A S D";accept="スペースキー";back="Q";pause="Tab";}
if(os_type==os_android){moving="左スティック";accept="右側のZボタン";back="右側のXボタン";pause="画面下部の一時停止ボタン";}
if(variable_global_exists("zh_pad_device") && global.zh_pad_device>=0){moving="Xbox LS / D-Pad";accept="A";back="B";pause="Start";}
draw_text(20,52,moving+"：移動");
draw_text(20,84,accept+"：決定／会話／調べる／ダッシュ");
draw_text(20,116,back+"：キャンセル／戻る");
draw_text(20,148,pause+"：メニュー／一時停止／戦闘離脱");
if(variable_global_exists("zh_pad_device") && global.zh_pad_device>=0)draw_text(20,180,"RS + RT/X | LT | LB/RB | Y/View");else draw_text(20,180,"タッチまたはマウス：ブロックをドラッグ    N：全画面表示");
draw_set_font(oldfont);draw_set_color(oldcolor);draw_set_alpha(oldalpha);draw_set_halign(oldh);draw_set_valign(oldv);
