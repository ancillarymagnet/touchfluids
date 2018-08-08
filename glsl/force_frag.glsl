//glsl
// SPLAT

#include "glsl_conditionals_util"
#include "texture_helpers"
#include "remap"
#include "fluid_algos"

#define VELOCITY 0
#define NOISE 1

uniform vec2 uPoint;
uniform float uRadius; 
uniform vec4 uForceBiasAndScale; // xy 'bias', or new force, zw scale
uniform vec2 uMouseButtons;
uniform float uGForce;

layout(location=0) out vec2 oVSplat;


float circle(vec2 pos, float r){ 
    
    vec2 aspect = uTD2DInfos[0].res.zw / uTD2DInfos[0].res.w;
    vec2 uv = vUV.st;
    uv *= aspect;
    pos *= aspect;
    float len = length(uv - pos);
    return 1.-smoothstep(0.0, r, len);
}

void main() {

    // d is our 'painted' force value at this frag
    float d = circle(uPoint, uRadius) * uMouseButtons.x;
    
    vec2 inwardForceVector = uPoint - vUV.st;

    // sum input forces
    vec2 inForceSum = vec2(0.0);
    for( int i = 0; i < TD_NUM_2D_INPUTS; i++){
        inForceSum += texture(sTD2DInputs[i],vUV.st).rg;
    }

    // use d value to paint force scale onto the scene
    // apply bias and scale
    vec2 scaledForce = mix(inForceSum, inForceSum * uForceBiasAndScale.zw, d);

    oVSplat = mix(scaledForce, scaledForce + uForceBiasAndScale.xy, d);
}
