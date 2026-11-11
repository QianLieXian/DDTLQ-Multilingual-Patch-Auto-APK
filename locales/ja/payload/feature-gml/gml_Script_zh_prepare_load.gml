global.zh_load_active=false;
global.zh_load_error="";
var fn="Memory Quartz Line "+string(argument0)+".ini";
if(!file_exists(fn)){global.zh_load_error="該当するセーブデータが見つかりませんでした。";return false;}
if(!instance_exists(o_line_overworld)){global.zh_load_error="セーブデータを読み込む前にタイトルメニューへ戻ってください。";return false;}
ini_open(fn);
var target=ini_read_real("Globals","room",-1);
var tx=ini_read_real("Globals","x",256),ty=ini_read_real("Globals","y",288);
var auxiliary=(argument0==99 || ini_read_real("PatchMetadata","SafeCopy",0)>=3);
ini_close();
if(auxiliary && (target==rm_start || target==rm_Main_menu)){target=rm_City;tx=256;ty=288;}
if(target<0 || target>=__ZH_ROOM_COUNT__ || target!=floor(target)){
 global.zh_load_error="無効なセーブシーンです。シーンの切り替えを中止しました。";return false;
}
global.zh_load_target=target;global.zh_load_x=tx;global.zh_load_y=ty;
global.zh_load_active=true;global.zh_load_wait=180;global.zh_load_stable=0;
global.zh_input_cooldown=5;
o_start_variables.xx=tx;o_start_variables.yy=ty;
return true;
