#include "../glsl_conditionals_util"
#include "../texture_helpers"
#include "../remap"
#include "../fluid_algos"

// COMPUTE DIVERGENCE

// INPUTS
#define VELOCITY 0 

layout(location=0) out float oDivergence;

void main(){

	oDivergence = divergence(VELOCITY);
}