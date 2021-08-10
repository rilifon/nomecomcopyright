shader_type canvas_item;

uniform sampler2D tex;
uniform vec2 dimensions;
uniform int id;

void fragment(){
	float w = 1.0/float(dimensions.x);
	float h = 1.0/float(dimensions.y);
	float u = float(id%int(dimensions.y))*w;
	float v = float(id/int(dimensions.x))*h;
	COLOR = texture(tex, vec2(UV.x*w, UV.y*h)+vec2(u,v));
}