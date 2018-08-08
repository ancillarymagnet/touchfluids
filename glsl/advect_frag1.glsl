#include "glsl_conditionals_util"
#include "texture_helpers"
#include "remap"
#include "fluid_algos"

// ADVECTION SHADER
// INPUTS
#define VELOCITY 0
#define STUFF 1 // thing to advect (velocity, dye, etc)
#define OBSTACLES 2 // todo

layout(location=0) out vec4 oAdvectedQty;


void main() {

	oAdvectedQty = advection4(VELOCITY,STUFF);
}