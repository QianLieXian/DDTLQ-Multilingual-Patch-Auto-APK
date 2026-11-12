if(!global.qa_visual_done){
 global.qa_visual_done=true;
 var old_a=draw_get_alpha(),cas=0; var atlas=surface_create(7200,2880);surface_set_target(atlas);draw_clear_alpha(c_black,0);
 var ss;ss[0]=spr_square_box;ss[1]=spr_sex_scene_square;ss[2]=spr_text_box;
 var ww;ww[0]=0;ww[1]=5;ww[2]=17;ww[3]=192;ww[4]=293;ww[5]=-2;
 var hh;hh[0]=0;hh[1]=5;hh[2]=13;hh[3]=186;hh[4]=93;hh[5]=0;
 var aa;aa[0]=0;aa[1]=0.35;aa[2]=1;
 for(var f=0;f<2;f+=1){gpu_set_texfilter(f);
 for(var s=0;s<3;s+=1)for(var d=0;d<6;d+=1)for(var a=0;a<3;a+=1){
  for(var mode=0;mode<2;mode+=1){
   var sf=surface_create(400,240);surface_set_target(sf);draw_clear_alpha(c_blue,0.25);draw_set_alpha(aa[a]);
   if(mode==0)qa_original_nineslice(ss[s],12.25,8.75,12.25+ww[d],8.75+hh[d]);
   else NineSliceBox(ss[s],12.25,8.75,12.25+ww[d],8.75+hh[d]);
   surface_reset_target();draw_set_alpha(1);draw_surface(sf,mode*3600+(cas mod 9)*400,(cas div 9)*240);surface_free(sf);
  }
  cas+=1;
 }
 }
 surface_reset_target();gpu_set_texfilter(false);draw_set_alpha(old_a);show_debug_message("VISUAL_DONE|"+string(cas));
}