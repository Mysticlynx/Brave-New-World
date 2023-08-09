#define ground_level 0.27

uniform mat4 sgModel;
uniform mat4 sgViewProj;

uniform mat4[30] sgJoints;

// Vertex formats:
// UnitGroupStack:		P3F_N3F_T2F_NW1F_W4F_J4F 
// ResourceExtractor:	P3F_N3F_T2F_NW1F_W4F_J4F_W4F_J4F

// T = TEXCOORD
// C = COLOR
// N = NORMAL
// P = POS
// NW = NUM_WEIGHTS
// W = WEIGHT
// J = JOINT_INDEX

// one pair of weights and indices
mat4 generateSkinningTransform(
	float numWeights,
	vec4 weights0,
	vec4 indices0
)
{
	mat4 transform = mat4(0.0);
	transform += ((sgJoints[int(indices0.x)] * weights0.x) * float(numWeights >= 1.0));
	transform += ((sgJoints[int(indices0.y)] * weights0.y) * float(numWeights >= 2.0));
	transform += ((sgJoints[int(indices0.z)] * weights0.z) * float(numWeights >= 3.0));
	transform += ((sgJoints[int(indices0.w)] * weights0.w) * float(numWeights >= 4.0));
	return transform;
}

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
attribute float sgNumWeights;
attribute vec4 sgWeights0;
attribute vec4 sgIndices0;

varying vec4 color;
varying vec2 texCoord;

void main() {
	mat4 skinToModel = generateSkinningTransform(sgNumWeights, sgWeights0, sgIndices0);
	vec4 modelSpacePos = skinToModel * vec4(sgVertex, 1);
    vec4 worldPos = sgModel * modelSpacePos;
    
	color = vec4(0,0,0,1);
	texCoord = sgTexCoord0;
	gl_Position = calculateShadowVertex(worldPos);
}
