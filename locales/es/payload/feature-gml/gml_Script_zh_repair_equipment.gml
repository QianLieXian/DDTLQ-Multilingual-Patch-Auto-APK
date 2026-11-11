with(o_start_variables){
 for(var k=0;k<8;k+=1){var itemid=ds_grid_get(current_cloths,0,k);ds_grid_set(current_cloths,1,k,zh_equipment_name(itemid));}
 var grids;grids[0]=bra;grids[1]=undies;grids[2]=stockings;grids[3]=hat;grids[4]=tshirt;grids[5]=pants;grids[6]=shoes;grids[7]=accessories;
 for(var k=0;k<8;k+=1)for(var row=0;row<ds_grid_height(grids[k]);row+=1){var itemid=ds_grid_get(grids[k],0,row);ds_grid_set(grids[k],1,row,zh_equipment_name(itemid));}
}
