struct SGLight {
	vec4 color;
	vec4 position;
};

#define MAX_LIGHTS 2

uniform mat4 sgModelView;
uniform mat4 sgModelViewProj;
uniform mat4 sgViewProj;

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

// two pairs of weights and indices 
mat4 generateSkinningTransform2(
	float numWeights,
	vec4 weights0,
	vec4 weights1,
	vec4 indices0,
	vec4 indices1
)
{
	mat4 transform = mat4(0.0);
	transform += ((sgJoints[int(indices0.x)] * weights0.x) * float(numWeights >= 1.0));
	transform += ((sgJoints[int(indices0.y)] * weights0.y) * float(numWeights >= 2.0));
	transform += ((sgJoints[int(indices0.z)] * weights0.z) * float(numWeights >= 3.0));
	transform += ((sgJoints[int(indices0.w)] * weights0.w) * float(numWeights >= 4.0));
	transform += ((sgJoints[int(indices1.x)] * weights1.x) * float(numWeights >= 5.0));
	transform += ((sgJoints[int(indices1.y)] * weights1.y) * float(numWeights >= 6.0));
	transform += ((sgJoints[int(indices1.z)] * weights1.z) * float(numWeights >= 7.0));
	transform += ((sgJoints[int(indices1.w)] * weights1.w) * float(numWeights >= 8.0));
	return transform;
}

attribute vec3 sgVertex;
attribute vec3 sgNormal;
attribute vec2 sgTexCoord0;
attribute float sgNumWeights;
attribute vec4 sgWeights0;
attribute vec4 sgWeights1;
attribute vec4 sgIndices0;
attribute vec4 sgIndices1;

// outputs to fragment shader
varying vec4 color;
varying vec2 texCoord;

void main() {
	mat4 skinToModel = generateSkinningTransform2(sgNumWeights, sgWeights0, sgWeights1, sgIndices0, sgIndices1);
	
	vec4 modelSpacePos = skinToModel * vec4(sgVertex, 1);
	vec3 modelSpaceNormal = normalize((skinToModel * vec4(sgNormal, 0)).xyz);

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
