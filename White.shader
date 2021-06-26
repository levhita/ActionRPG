shader_type canvas_item;

uniform bool active = true;

void fragment(){
	vec4 previous_color = texture(TEXTURE, UV);
	if (active) {
		COLOR = vec4(
			(1.0 + previous_color.r)/2.0,
			(1.0 + previous_color.g)/2.0,
			(1.0 + previous_color.b)/2.0,
			previous_color.a
		);
	} else {
		COLOR = previous_color;
	}
}