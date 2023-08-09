struct SGMaterial {
	sampler2D emissionSampler;
};

uniform SGMaterial sgMaterial;
uniform sampler2D shadowSampler; 
    
// inputs from fragment shader
varying vec2 texCoord;
varying vec4 uvShadow;
    
void main() {
    vec4 color = texture2D(sgMaterial.emissionSampler, texCoord);
    if (color.a < 0.1)
        discard;

    // get shadow.  Could soften by averaging multiple samples
    float view_x = uvShadow.x / uvShadow.w;
    float view_y = uvShadow.y / uvShadow.w;
    vec2 uv = vec2(0.5 + 0.5*view_x, 0.5-0.5*view_y);    
    float shadow_alpha = 0.5 - texture2D(shadowSampler, uv).r * 0.5;
    
    vec3 shadow_color = vec3(0,0,0);
        
	gl_FragColor = vec4(mix(color.rgb,shadow_color,shadow_alpha), color.a);       
}

