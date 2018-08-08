#include "../glsl_conditionals_util"
#include "../texture_helpers"
#include "../remap"
#include "../fluid_algos"

//  SUBTRACT GRADIENT

// INPUTS
#define PRESSURE 0
#define VELOCITY 1



layout(location=0) out vec2 oVelocity;

void main(){

	oVelocity = subtractGradient(PRESSURE, VELOCITY);
}