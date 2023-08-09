uniform sampler2D regionAndBorderOverlay;
uniform float fOffScreenCamLeft;
uniform float fOffScreenCamRight;
uniform float fOffScreenCamTop;
uniform float fOffScreenCamBottom;

varying vec3 vFlatPos; // TEXCOORD0
varying vec3 viewSpacePosition; // TEXCOORD1;

void main() {
	// Determine region/border texture coordinates

	// Find the off screen texture screen space coordinates for the position
	float fScreenX = (2.0 * vFlatPos.x + (fOffScreenCamRight + fOffScreenCamLeft)
			* vFlatPos.z) / (fOffScreenCamRight - fOffScreenCamLeft);
	float fScreenY = (2.0 * vFlatPos.y + (fOffScreenCamTop + fOffScreenCamBottom)
			* vFlatPos.z) / (fOffScreenCamTop - fOffScreenCamBottom);
	
	vec2 vScreenSpacePos = vec2(fScreenX, fScreenY) / -vFlatPos.z;
	vec2 uvRegionAndBorder = vec2(0.5 + 0.5*vScreenSpacePos.x, 0.5 - 0.5*vScreenSpacePos.y);
    
	
	// diffuse
	vec4 borderColor = texture2D(regionAndBorderOverlay, uvRegionAndBorder);
	vec4 oceanColor = vec4(0.164, 0.300, 0.480 ,0.918); // colEmission value="#2a4c7eFF", fTransparency value="0.618"
		
	gl_FragColor = vec4(mix(oceanColor, borderColor, borderColor.a));
}
