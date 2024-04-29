shader_type canvas_item;

uniform bool active = false;
uniform vec4 flash_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	vec4 prev_color = texture(TEXTURE, UV);
	vec4 new_color = prev_color;
	if (active == true)
	{
		new_color = flash_color;
	}
	COLOR = new_color;
	COLOR.a = prev_color.a;
}