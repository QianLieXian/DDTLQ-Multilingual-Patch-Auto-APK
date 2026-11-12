if(!variable_global_exists("zh_pad_device"))return false;
var slot=-1;
switch(argument0){
case vk_up:case ord("W"):slot=0;break;
case vk_down:case ord("S"):slot=1;break;
case vk_left:case ord("A"):slot=2;break;
case vk_right:case ord("D"):slot=3;break;
case ord("Z"):case ord("K"):case vk_space:slot=4;break;
case ord("X"):case ord("L"):case ord("Q"):case vk_escape:slot=5;break;
case vk_enter:case vk_tab:slot=6;break;
case vk_f9:slot=7;break;
}
if(slot<0)return false;
if(argument1)return global.zh_pad_pressed[slot];
return global.zh_pad_down[slot];
