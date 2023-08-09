uniform vec2 tileMin;
uniform vec2 tileMax;
uniform mat4 sgModelViewProj;

attribute vec3 sgVertex;

varying vec2 uvTile;

void main() {
	gl_Position = sgModelViewProj * vec4(sgVertex, 1);
    
	// Assume the camera for the off screen texture is in the same position
	// as the current camera and translate to the camera's coordinate space
	
	uvTile = vec2( ( sgVertex.x - tileMin.x) / (tileMax.x - tileMin.x), 1.0 - (sgVertex.y - tileMin.y) / (tileMax.y - tileMin.y));	
}
