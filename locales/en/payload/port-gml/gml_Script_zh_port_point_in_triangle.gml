var px=argument0,py=argument1,ax=argument2,ay=argument3,bx=argument4,by=argument5,cx=argument6,cy=argument7;
if(abs((bx-ax)*(cy-ay)-(by-ay)*(cx-ax))<0.0001)return false;
var a=(px-bx)*(ay-by)-(ax-bx)*(py-by),b=(px-cx)*(by-cy)-(bx-cx)*(py-cy),c=(px-ax)*(cy-ay)-(cx-ax)*(py-ay);
return !((a<0||b<0||c<0)&&(a>0||b>0||c>0));
