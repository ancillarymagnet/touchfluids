//glsl
// SPLAT

uniform vec2 uPoint;
uniform float uRadius; 
uniform vec2 uMouseButtons;
uniform vec4 uStuffColorBias;
uniform vec4 uStuffColorScale;


layout(location=0) out vec4 oSplat;

float circle(vec2 pos, float r){ 
    
    vec2 aspect = uTD2DInfos[0].res.zw / uTD2DInfos[0].res.w;
    vec2 uv = vUV.st;
    uv *= aspect;
    pos *= aspect;
    float len = length(uv - pos);
    return 1.-smoothstep(0.0, r, len);
}

void main() {

	float d = circle(uPoint, uRadius) * uMouseButtons.x;

    vec4 inColorSum = vec4(0.0);
    for( int i = 0; i < TD_NUM_2D_INPUTS; i++){
    	inColorSum += texture(sTD2DInputs[i],vUV.st);
    }
    
    // apply bias and scale,
    // mix with input
    oSplat = clamp(mix(inColorSum , inColorSum * uStuffColorScale , d ) 
        + uStuffColorBias * d, 0., 1.);
}
