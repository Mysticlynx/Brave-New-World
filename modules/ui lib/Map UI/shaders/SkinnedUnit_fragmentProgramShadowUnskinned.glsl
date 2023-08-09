struct SGMaterial {
	sampler2D diffuseSampler;
};

uniform SGMaterial sgMaterial;

varying vec4 color;
varying vec2 texCoord;
varying float modelY;

void main() {
	vec4 texColor = texture2D(sgMaterial.diffuseSampler, texCoord);
    if (texColor.a < 0.5)
        discard;

    if (modelY < 0.0) // underground model parts don't cast a shadow
        discard;
        
    gl_FragColor = color;
}


