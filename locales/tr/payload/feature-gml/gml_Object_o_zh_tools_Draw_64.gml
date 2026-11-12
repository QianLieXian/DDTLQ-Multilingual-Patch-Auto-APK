if(room==rm_start)zh_controls(global.controls);
var of=fnt_heartbit2,oc=draw_get_color(),oa=draw_get_alpha(),oh=fa_left,ov=fa_top;
draw_set_font(fnt_heartbit2);draw_set_halign(fa_left);draw_set_valign(fa_top);draw_set_alpha(0.85);draw_set_color(c_black);
if(!global.zh_port_mode){draw_rectangle(342,2,384,24,false);draw_set_alpha(1);draw_set_color(c_white);draw_text(346,6,"Yardım");}
if(panel){
 draw_set_alpha(0.94);draw_set_color(c_black);draw_rectangle(42,8,342,186,false);draw_set_alpha(1);draw_set_color(c_white);
 draw_set_font(3);draw_text_ext(50,11,"Yön: seç; Onayla: uygula; Geri: kapat",10,284);
 draw_set_color(make_color_rgb(70,55,90));draw_rectangle(44,40+zh_choice*20,340,59+zh_choice*20,false);draw_set_color(c_white);
 draw_text(50,41,"F6 Galerinin kilidini tamamen aç: "+string(global.zh_gallery));
 draw_text(50,61,"F8 Sürekli Can ve Mana yenileme: "+string(global.zh_cheat));
 draw_text(50,81,"F7 100.000 Ark ekle");
 draw_text(50,101,"F10 Orijinal hata ayıklama: "+string(global.Dev));
 draw_text(50,121,"F11 Kaynak kopyası oluştur (hikâye ilerlemesi korunur)");
 draw_text(50,141,"F12 Yardımcı kopyayı yükle");
}
if(panel)draw_text(50,161,"F5 Tüm yaratık ansiklopedisi: "+string(global.zh_dex));
if(hint_timer>0){draw_set_alpha(0.95);draw_set_color(c_black);draw_rectangle(0,194,384,216,false);draw_set_alpha(1);draw_set_color(c_white);draw_set_font(3);draw_text(3,195,hint);}
draw_set_font(of);draw_set_color(oc);draw_set_alpha(oa);draw_set_halign(oh);draw_set_valign(ov);

zh_pad_cursor_draw();
