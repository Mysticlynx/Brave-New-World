
#define ground_level 0.27

uniform mat4 sgModel;
uniform mat4 sgViewProj;

vec4 calculateShadowVertex(vec4 worldPos)
{    
    float shadow_length = (worldPos.z - ground_level);
    vec4 flatPos = vec4(
        worldPos.x - 0.707 * shadow_length, 
        worldPos.y - 0.707 * shadow_length,
        ground_level,
        worldPos.w);
    return sgViewProj * flatPos;
}

attribute vec3 sgVertex;
attribute vec3 sgNormal;
attribute vec2 sgTexCoord0;

varying vec4 color;
varying vec2 texCoord;
varying float modelY;

void main() {
	vec4 modelSpacePos = vec4(sgVertex,1);
    vec4 worldPos = sgModel * modelSpacePos;

	gl_Position = calculateShadowVertex(worldPos);    
	color = vec4(0,0,0,1);
	texCoord = sgTexCoord0;
    modelY = worldPos.z - ground_level;
}
