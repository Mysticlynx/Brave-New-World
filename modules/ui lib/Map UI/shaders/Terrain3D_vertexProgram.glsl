uniform vec3 mapMin;
uniform vec3 mapMax;
uniform vec2 tileMin;
uniform vec2 tileMax;
uniform float fDetailMultiplierX;
uniform float fDetailMultiplierY;
uniform float fSeaLevel;

uniform mat4 sgModelViewProj;
uniform mat4 sgModelView;

attribute vec3 sgVertex;
attribute vec3 sgNormal;

varying vec3 vFlatPos;
varying vec3 viewSpacePosition;
varying vec3 viewSpaceNormal;
varying vec2 uvBlend;
varying vec2 uvDiffuse;
varying vec2 uvNorm;

void main() {
	gl_Position = sgModelViewProj * vec4(sgVertex, 1);
	
	// Assume the camera for the off screen texture is in the same position
	// as the current camera and translate to the camera's coordinate space
	vFlatPos = (sgModelView * vec4(sgVertex.xy,fSeaLevel, 1)).xyz;
	
	viewSpacePosition = (sgModelView * vec4(sgVertex, 1)).xyz;
	viewSpaceNormal = (sgModelView * vec4(sgNormal, 0)).xyz;
	
	// Determine blend and diffuse texture coordinates
	uvNorm = vec2( ( sgVertex.x - tileMin.x) / (tileMax.x - tileMin.x), 1.0 - (sgVertex.y - tileMin.y) / (tileMax.y - tileMin.y));
	uvBlend = vec2( ( sgVertex.x - mapMin.x) / (mapMax.x - mapMin.x), 1.0 - (sgVertex.y - mapMin.y) / (mapMax.y - mapMin.y));
	uvDiffuse = uvBlend * vec2(fDetailMultiplierX, fDetailMultiplierY);	
}
