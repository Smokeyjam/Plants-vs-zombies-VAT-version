shader_type spatial;
render_mode cull_front, blend_mix, shadows_disabled, specular_disabled, unshaded, depth_prepass_alpha;

uniform sampler2D offset_map;
uniform sampler2D normal_map;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
uniform float alpha_hash_scale : hint_range(0.0, 2.0, 0.01);

uniform vec4 albedo : source_color;
uniform float point_size : hint_range(0.1, 128.0, 0.1);

uniform float fps = 24.0;

uniform float specular : hint_range(0, 1);
uniform float metallic : hint_range(0, 1);
uniform float roughness : hint_range(0, 1);

varying flat vec4 custom_data;

void vertex() {
	custom_data = INSTANCE_CUSTOM;

	// frame
	float start_frame = custom_data.g;
	float end_frame = custom_data.b;
	float num_frames = end_frame - start_frame;
	int frame_count = int(end_frame - start_frame);

	// time
	float time_scale_normalized = fps / num_frames;
	float time = mod(TIME * time_scale_normalized, 1.0);

	float frame_offset = num_frames * custom_data.r;
	float current_frame = start_frame + mod((time * num_frames) + frame_offset, num_frames);

	ivec2 tex_size = textureSize(offset_map, 0);
	float pixel_size = 1.0 / float(tex_size.y);

	float frame_floor = clamp(floor(current_frame), start_frame, end_frame);
	float frame_ceil = float(int(ceil(current_frame) - start_frame) % frame_count) + start_frame;

	vec2 frame_floor_uv_offset = vec2(0.0, -((frame_floor + 0.5) * pixel_size));
	vec2 frame_ceil_uv_offset = vec2(0.0, -((frame_ceil + 0.5) * pixel_size));

	float lerp_factor = current_frame - frame_floor;

	vec3 offset_floor = texture(offset_map, UV2 + frame_floor_uv_offset).xyz;
	vec3 offset_ceil = texture(offset_map, UV2 + frame_ceil_uv_offset).xyz;
	vec3 offset_lerp = mix(offset_floor, offset_ceil, lerp_factor);
	vec3 new_offset = vec3(offset_lerp.x, offset_lerp.z, offset_lerp.y);

	VERTEX += new_offset;

	vec3 normal_floor = texture(normal_map, UV2 + frame_floor_uv_offset).xyz;
	vec3 normal_ceil = texture(normal_map, UV2 + frame_ceil_uv_offset).xyz;
	vec3 normal_lerp = mix(normal_floor, normal_ceil, lerp_factor);
	vec3 new_normal = vec3((normal_lerp.x * 2.0) - 1.0, (normal_lerp.z * 2.0) - 1.0, (normal_lerp.y * 2.0) - 1.0);

	NORMAL = new_normal;
// 🔁 One-shot squash/stretch animation
// float state = custom_data.r;  // 0 = no, 1 = playing
float squash_amplitude = 0.2;
float squash_speed = 5.0;

// Time-based sine progression remapped to [0, 1]
float wave = (sin(TIME * squash_speed) + 1.0) * 0.5;
float squash_amount = 0.0;

// PLAY ONLY if in 'playing' state
if (custom_data.r == 1.0) {
    squash_amount = wave * squash_amplitude;

    // Apply squash only to top half
    vec3 center = vec3(0.0);
    vec3 local_pos = VERTEX - center;

    float squash_factor = 1.0 + squash_amount;

    // Only affect vertices above a certain Y threshold (e.g., top half)
    if (local_pos.y > 1.5) {
        local_pos.z *= squash_factor;
    }

    VERTEX = local_pos + center;
}

}

void fragment() {
	vec2 base_uv = UV;

	vec4 albedo_tex = texture(texture_albedo, base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;

	METALLIC = metallic;
	SPECULAR = specular;

	ROUGHNESS = roughness;
	ALPHA *= albedo.a * albedo_tex.a;
	ALPHA_HASH_SCALE = alpha_hash_scale;
}
