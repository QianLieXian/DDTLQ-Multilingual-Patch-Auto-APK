var g=argument0,x1=argument1,y1=argument2,x2=argument3,y2=argument4,value=argument5;
for(var yy=min(y1,y2);yy<=max(y1,y2);yy+=1)for(var xx=min(x1,x2);xx<=max(x1,x2);xx+=1)if(ds_grid_get(g,xx,yy)==value)return true;
return false;
