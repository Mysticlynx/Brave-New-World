uniform sampler2D TileSampler; // Combined tile texture

varying vec2 uvTile;

void main() {
	// get precalculated combined texture color
	vec3 color = texture2D(TileSampler, uvTile).rgb;
    
    gl_FragColor = vec4(color,1);
}
