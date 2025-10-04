shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest, repeat_disable;

uniform float pixelation_size : hint_range(1.0, 50.0) = 4.0;
uniform float displacement_amount : hint_range(0.0, 100.0) = 0.0;
uniform float interval : hint_range(0.01, 5.0) = 1.0;

float random(vec2 uv, float seed) {
	return fract(sin(dot(uv + seed, vec2(12.9898, 78.233))) * 43758.5453123);
}
void fragment() {
	vec2 uv = SCREEN_UV;
	ivec2 screen_size = textureSize(SCREEN_TEXTURE, 0);
	vec2 screen_uv = uv * vec2(screen_size);
	float time_step = floor(TIME / interval);
	vec2 block_size = vec2(pixelation_size);
	vec2 block_coord = floor(screen_uv / block_size);
	vec2 block_center = block_coord * block_size + block_size * 0.5;
	vec2 noise_offset = vec2(0.0);
	noise_offset = vec2(
		random(block_coord, time_step),
		random(block_coord + 0.5 * block_coord, time_step)
	) * displacement_amount * block_size;

	noise_offset = floor(noise_offset);
	ivec2 texel_coord = ivec2(block_center + noise_offset);
	texel_coord = clamp(texel_coord, ivec2(0), screen_size - ivec2(1));
	COLOR = texelFetch(SCREEN_TEXTURE, texel_coord, 0);
}