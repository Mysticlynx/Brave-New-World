struct SGMaterial {
	sampler2D diffuseSampler;
};

struct SGLight {
	vec4 color;
	vec4 position;
};

#define MAX_LIGHTS 2

uniform mat4 sgModelView;
uniform mat4 sgModelViewProj;

uniform SGMaterial sgMaterial;
uniform SGLight[MAX_LIGHTS] sgLights;
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

// input
attribute vec3 sgVertex;
attribute vec3 sgNormal;
attribute vec2 sgTexCoord0;
attribute float sgNumWeights;
attribute vec4 sgWeights0;
attribute vec4 sgIndices0;

// output
varying vec4 color;
varying vec2 texCoord;

void main() {
	mat4 skinToModel = generateSkinningTransform(sgNumWeights, sgWeights0, sgIndices0);
	
	vec4 modelSpacePos = skinToModel * vec4(sgVertex, 1);
	vec3 modelSpaceNormal = normalize( (skinToModel * vec4(sgNormal, 0)).xyz );

	vec4 viewSpacePos = sgModelView * modelSpacePos;
	vec3 viewSpaceNormal = normalize((sgModelView * vec4(modelSpaceNormal, 0)).xyz);

	 // ambient light
	vec3 diffuseColor = sgLights[1].color.rgb;
	
	// directional light
	vec3 dirToLight = normalize(-sgLights[0].position.xyz);
	float diffuseCoeff = max(dot(viewSpaceNormal, dirToLight), 0.0);
	diffuseColor += diffuseCoeff * sgLights[0].color.rgb;

	color = vec4(diffuseColor, 1);
	texCoord = sgTexCoord0;
	gl_Position = sgModelViewProj * modelSpacePos;
}
