var g=argument0,xx=argument1,yy=argument2,v=argument3;
if(xx<0||yy<0||xx>=ds_grid_width(g)||yy>=ds_grid_height(g))return 0;
var old=ds_grid_get(g,xx,yy);
if(is_string(v)){if(is_string(old))ds_grid_set(g,xx,yy,old+v);else ds_grid_set(g,xx,yy,v);}
else if(!is_string(old))ds_grid_set(g,xx,yy,old+v);
return 0;
