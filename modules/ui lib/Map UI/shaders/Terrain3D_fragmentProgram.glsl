uniform sampler2D regionAndBorderOverlay;
uniform sampler2D TileSampler; // LuminanceMap
uniform sampler2D terrainBlend1;
uniform sampler2D terrainBlend2;
uniform sampler2D terrainDetailChannels;
uniform sampler2D terrainDiffuse5; // mountain
uniform float fOffScreenCamLeft;
uniform float fOffScreenCamRight;
uniform float fOffScreenCamTop;
uniform float fOffScreenCamBottom;

struct SGLight {
	vec4 color;
	vec4 position;
};
uniform SGLight sgLights[2];

varying vec3 vFlatPos;
varying vec3 viewSpacePosition;
varying vec3 viewSpaceNormal;
varying vec2 uvBlend;
varying vec2 uvDiffuse;
varying vec2 uvNorm;

void main() {
	// Determine region/border texture coordinates

	// Find the off screen texture screen space coordinates for the position
	float fScreenX = (2.0 * vFlatPos.x + (fOffScreenCamRight + fOffScreenCamLeft)
			* vFlatPos.z) / (fOffScreenCamRight - fOffScreenCamLeft);
	float fScreenY = (2.0 * vFlatPos.y + (fOffScreenCamTop + fOffScreenCamBottom)
			* vFlatPos.z) / (fOffScreenCamTop - fOffScreenCamBottom);
	
	vec2 vScreenSpacePos = vec2(fScreenX, fScreenY) / -vFlatPos.z;
	
    vec2 uvRegionAndBorder = vec2(0.5 + 0.5*vScreenSpacePos.x, 0.5 - 0.5*vScreenSpacePos.y);
	
	vec3 E = normalize(-viewSpacePosition); // we are in Eye Coordinates, so EyePos is (0,0,0)  
	
	// diffuse
	vec4 borderColor = texture2D(regionAndBorderOverlay, uvRegionAndBorder);
	vec3 blend1 = texture2D(terrainBlend1, uvBlend).rgb;
	vec4 blend2 = texture2D(terrainBlend2, uvBlend);
	vec3 detailChannels = texture2D(terrainDetailChannels, uvDiffuse).rgb;
	
	// terrain colors
	vec3 c1 = mix(vec3(0.604, 0.467, 0.302), vec3(0.710, 0.557, 0.357), detailChannels.b); // sand
	vec3 c2 = mix(vec3(0.322, 0.380, 0.145), vec3(0.598, 0.772, 0.280), detailChannels.r); // grass	
	vec3 c3 = mix(vec3(0.000, 0.012, 0.000), vec3(0.429, 0.610, 0.135), detailChannels.g); // hill
	vec3 c4 = mix(vec3(0.494, 0.294, 0.098), vec3(0.610, 0.457, 0.257), detailChannels.b); // dirt
	vec3 c5 = texture2D(terrainDiffuse5, uvDiffuse).rgb;                                            // mountain
	vec3 c6 = mix(vec3(0.800, 0.800, 0.900), vec3(1.000, 1.000, 1.000), detailChannels.b); // ice
	float texLuminance = ( texture2D(TileSampler, uvNorm).r * 1.33 ) - 0.33;
	
	// normalize blend
	const float nonZero = 0.004; // to avoid dividing by zero
	float blendTotal1 = max(blend1.r + blend1.g + blend1.b,nonZero);
	float blendTotal2 = max(blend2.r + blend2.g + blend2.b,nonZero);

	blend1 /= blendTotal1;
	blend2.rgb /= blendTotal2;
		
	vec3 baseColor = c1 * blend1.r + c2 * blend1.g + c3 * blend1.b;
	vec3 modColor = c4 * blend2.r + c5 * blend2.g + c6 * blend2.b;
	
	vec3 diffColor = mix(baseColor, modColor, blend2.a);
	
	// ambient color
	vec3 Iamb = diffColor * sgLights[1].color.rgb;
	
	vec3 Idiff = diffColor * texLuminance * sgLights[0].color.rgb;

	// scene color
	vec3 color = Iamb + Idiff;
		
    gl_FragColor = vec4(mix(color, borderColor.rgb, borderColor.a),1);
}