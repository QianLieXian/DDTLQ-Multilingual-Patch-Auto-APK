var src=string(argument0), limit=argument1;
if(limit<=0)return src;
var output="",line="",n=string_length(src),j=1;
while(j<=n){
 var ch=string_char_at(src,j), token=ch;
 if(ch=="\n"){output+="\n";line="";j+=1;continue;}
 var cp=ord(ch);
 // Latin, Greek and Cyrillic words stay together. CJK wraps by character.
 if(cp>32 && cp<12288){
  j+=1;
  while(j<=n){var next=string_char_at(src,j),code=ord(next);if(code<=32||code>=12288)break;token+=next;j+=1;}
 }else j+=1;
 if(line!="" && string_width(line+token)>limit){output+="\n";line="";}
 if(line=="" && token==" ")continue;
 if(string_width(token)<=limit){output+=token;line+=token;}
 else for(var k=1;k<=string_length(token);k+=1){var part=string_char_at(token,k);if(line!=""&&string_width(line+part)>limit){output+="\n";line="";}output+=part;line+=part;}
}
return output;
