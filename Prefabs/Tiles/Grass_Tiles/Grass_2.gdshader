shader_type spatial;
render_mode unshaded,cull_back;


//uniform vec2 tiling = vec2(1.0,1.0);
//uniform vec2 offset;
//uniform vec2 Noise_Tiling;

uniform sampler2D texture_albedo;
uniform sampler2D Grass_Overlay;
uniform sampler2D Noise;

uniform float noise_intensity = 0.5;
uniform float noise_scale = 1.0;

uniform float Grass_intensity = 0.5;
uniform float Grass_scale = 1.0;

void vertex() {
	//UV = UV * tiling + offset;
}

void fragment() {
	// Get the world position of the fragment
	vec3 world_pos = (NODE_POSITION_WORLD + VERTEX).xyz; //(NODE_POSITION_WORLD * VERTEX).xyz
	// Map world position to a 2D coordinate space for the noise texture
	vec2 noise_uv = world_pos.xz * noise_scale; // Using the XZ plane
	vec2 grass_uv = world_pos.xz * Grass_scale;

	vec4 texture_colour = texture(texture_albedo,UV);
	vec4 Noise_Tex = texture(Noise,noise_uv);
	vec4 Grass_Tex = texture(Grass_Overlay,noise_uv);

	vec4 mixed_color = mix(texture_colour, Noise_Tex, noise_intensity) * mix(texture_colour, Grass_Tex, Grass_intensity);
	ALBEDO = mixed_color.rgb;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
