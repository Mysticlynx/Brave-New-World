uniform sampler2D TileSampler; // Combined tile texture
uniform sampler2D shadowSampler; 

varying vec2 uvTile;
varying vec4 uvShadow;
    
void main() {

    
    // get shadow.  Could soften by averaging multiple samples
    float view_x = uvShadow.x / uvShadow.w;
    float view_y = uvShadow.y / uvShadow.w;
    vec2 uv = vec2(0.5 + 0.5*view_x, 0.5-0.5*view_y);    
    float shadow_alpha = 0.5 - texture2D(shadowSampler, uv).r * 0.5;
    
    // get precalculated combined texture color
    vec3 color = texture2D(TileSampler, uvTile).rgb;
    
    vec3 shadow_color = vec3(0,0,0);
        
    gl_FragColor = vec4(mix(color.rgb,shadow_color,shadow_alpha), 1);
}