uniform mat4 sgModelViewProj;
uniform mat4 sgModelView;

attribute vec3 sgVertex;
attribute vec3 sgNormal;

varying vec3 vFlatPos; // TEXCOORD0
varying vec3 viewSpacePosition; // TEXCOORD1;

void main() {
	vec4 position = sgModelViewProj * vec4(sgVertex, 1));
	
	// Assume the camera for the off screen texture is in the same position
	// as the current camera and translate to the camera's coordinate space
	vFlatPos = (sgModelView * vec4(position.xy,0.02, 1)).xyz; // Note: model is transformed to sea level so don't adjust (or you get double images)
	
	viewSpacePosition = (sgModelView * vec4(position, 1)).xyz;
    
    gl_Position = position;
}



