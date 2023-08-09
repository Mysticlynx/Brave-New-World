uniform mat4 sgModelViewProj;

// vertex inputs
attribute vec3 sgVertex;
attribute vec2 sgTexCoord0;

// outputs (other than gl_Position)
varying vec2 texCoord;
varying vec4 uvShadow;
    
void main() {
    vec4 pos = sgModelViewProj * vec4(sgVertex, 1);
    gl_Position = pos;
	texCoord = sgTexCoord0;
    uvShadow = pos;    
}
