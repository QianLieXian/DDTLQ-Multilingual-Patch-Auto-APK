// Transparent panels have no visible effect; do not submit thousands of tiles.
if(draw_get_alpha()<=0)return 0;
var _size = sprite_get_width(argument0) / 3;
var _x1 = argument1;
var _y1 = argument2;
var _x2 = argument3;
var _y2 = argument4;
var _w = _x2 - _x1;
var _h = _y2 - _y1;
var _columns = _w div _size;
var _rows = _h div _size;
draw_sprite_part(argument0, 0, 0, 0, _size, _size, _x1, _y1);
draw_sprite_part(argument0, 0, _size * 2, 0, _size, _size, _x1 + (_columns * _size), _y1);
draw_sprite_part(argument0, 0, 0, _size * 2, _size, _size, _x1, _y1 + (_rows * _size));
draw_sprite_part(argument0, 0, _size * 2, _size * 2, _size, _size, _x1 + (_columns * _size), _y1 + (_rows * _size));
// These three shipped skins have a uniform centre and repeat-invariant edges.
// Sample one inner pixel along each stretched direction to preserve filtering.
if(!gpu_get_texfilter() && (argument0==spr_square_box || argument0==spr_sex_scene_square || argument0==spr_text_box)){
 var _a=draw_get_alpha(),_sample=_size+floor(_size/2);
 var _iw=(_columns-1)*_size,_ih=(_rows-1)*_size;
 if(_rows>1){
  draw_sprite_part_ext(argument0,0,0,_sample,_size,1,_x1,_y1+_size,1,_ih,c_white,_a);
  draw_sprite_part_ext(argument0,0,_size*2,_sample,_size,1,_x1+_columns*_size,_y1+_size,1,_ih,c_white,_a);
 }
 if(_columns>1){
  draw_sprite_part_ext(argument0,0,_sample,0,1,_size,_x1+_size,_y1,_iw,1,c_white,_a);
  draw_sprite_part_ext(argument0,0,_sample,_size*2,1,_size,_x1+_size,_y1+_rows*_size,_iw,1,c_white,_a);
 }
 if(_columns>1 && _rows>1)draw_sprite_part_ext(argument0,0,_sample,_sample,1,1,_x1+_size,_y1+_size,_iw,_ih,c_white,_a);
 return 0;
}
// Linear filtering can expose original tile seams; preserve that rendering exactly.
// Also preserve original tiling for any future patterned skin.
for (var i = 1; i < _rows; i++)
{
    draw_sprite_part(argument0, 0, 0, _size, _size, _size, _x1, _y1 + (i * _size));
    draw_sprite_part(argument0, 0, _size * 2, _size, _size, _size, _x1 + (_columns * _size), _y1 + (i * _size));
}
for (var i = 1; i < _columns; i++)
{
    draw_sprite_part(argument0, 0, _size, 0, _size, _size, _x1 + (i * _size), _y1);
    draw_sprite_part(argument0, 0, _size, _size * 2, _size, _size, _x1 + (i * _size), _y1 + (_rows * _size));
}
for (var i = 1; i < _columns; i++)
{
    for (var j = 1; j < _rows; j++)
    {
        draw_sprite_part(argument0, 0, _size, _size, _size, _size, _x1 + (i * _size), _y1 + (j * _size));
    }
}
