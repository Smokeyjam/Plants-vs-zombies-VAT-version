shader_type spatial;
render_mode unshaded;

uniform sampler2D TileMap;
uniform sampler2D color;
uniform float TileMapScale_X = 4;//2.29
uniform float TileMapScale_Y = 4;
//uniform vec2 TileMapScale = vec2(TileMapScale_X,TileMapScale_Y);
varying vec3 worldPos;

void vertex() {
	worldPos = (MODEL_MATRIX * vec4(VERTEX,1.0)).xyz;
	worldPos.x += 3.0;
	worldPos.z -= 1.0;
}

void fragment() {
	vec3 noiseLevel = texture(TileMap, vec2(worldPos.x / TileMapScale_X,worldPos.z/TileMapScale_Y)).rbg;
	ALBEDO = texture(color, vec2(1.0 - UV.y, 0)).rgb * noiseLevel;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
