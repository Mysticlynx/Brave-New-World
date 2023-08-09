struct SGMaterial {
	sampler2D diffuseSampler;
};

uniform SGMaterial sgMaterial;

varying vec4 color;
varying vec2 texCoord;

void main() {
    gl_FragColor = texture2D(sgMaterial.diffuseSampler, texCoord) * color;
}
