#include "../glsl_conditionals_util"
#include "../texture_helpers"
#include "../remap"
#include "../fluid_algos"

// DISPLAY

// INPUTS
#define INPUT 0 

layout(location=0) out vec4 oDisplay;

// note - greg pointed out to me that this
// can now be done with a Math TOP
// -N
void main(){

	oDisplay = displayVec2(INPUT);
}