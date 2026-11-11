if(!place_meeting(x,y,o_wall))return true;
var ox=x,oy=y;
for(var radius=8;radius<=256;radius+=8)for(var angle=0;angle<360;angle+=45){
 var tx=ox+lengthdir_x(radius,angle),ty=oy+lengthdir_y(radius,angle);
 if(tx<8||ty<8||tx>room_width-8||ty>room_height-8)continue;
 if(!place_meeting(tx,ty,o_wall)&&!place_meeting(tx+8,ty,o_wall)&&!place_meeting(tx-8,ty,o_wall)&&!place_meeting(tx,ty+8,o_wall)&&!place_meeting(tx,ty-8,o_wall)){
  x=tx;y=ty;return true;
 }
}
return false;
