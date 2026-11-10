var src = string(argument0), limit = argument1;
if (limit <= 0) return src;
var output = "", line = "", n = string_length(src);
for (var j = 1; j <= n; j += 1) {
 var ch = string_char_at(src,j);
 if (ch == "\n") {output += "\n"; line = ""; continue;}
 if (line != "" && string_width(line + ch) > limit) {output += "\n"; line = "";}
 if (line == "" && ch == " ") continue;
 output += ch; line += ch;
}
return output;
