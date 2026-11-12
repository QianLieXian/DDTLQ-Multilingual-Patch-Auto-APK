var key=argument0,mode=argument1,pad=false,oldpad=false;
if(variable_global_exists("zh_pad_device")){
 var l=global.zh_pad_down[8],r=global.zh_pad_down[9];
 var pl=(l&&!global.zh_pad_pressed[8])||global.zh_pad_released[8];
 var pr=(r&&!global.zh_pad_pressed[9])||global.zh_pad_released[9];
 if(key==mb_left){pad=l;oldpad=pl;}
 if(key==mb_right){pad=r;oldpad=pr;}
 if(key==mb_any){pad=l||r;oldpad=pl||pr;}
}
var real=mouse_check_button(key),realpress=mouse_check_button_pressed(key),realrelease=mouse_check_button_released(key);
var current=real||pad,previous=(real&&!realpress)||realrelease||oldpad;
if(mode==1)return current&&!previous;
if(mode==2)return !current&&previous;
return current;
