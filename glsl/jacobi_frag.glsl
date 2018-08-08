#include "../glsl_conditionals_util"
#include "../texture_helpers"
#include "../remap"
#include "../fluid_algos"

// JACOBI

// INPUTS
#define PRESSURE 0 // PRESSURE
#define DIVERGENCE 1 // DIVERGENCE

layout(location=0) out float oDiffusedQty;

void main(){

	oDiffusedQty = jacobi(PRESSURE, DIVERGENCE);
	//oDiffusedQty = boundJacobi(PRESSURE, DIVERGENCE);
}