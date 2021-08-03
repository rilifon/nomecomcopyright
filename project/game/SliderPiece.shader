shader_type canvas_item;

uniform sampler2D tex;
uniform vec2 dimensions;
uniform int id;

void fragment(){
	float w = 1.0/float(dimensions.x);
	float h = 1.0/float(dimensions.y);
	COLOR = vec4(1.0, 1.0, 1.0, 1.0);
}