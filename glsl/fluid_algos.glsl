//glsl


// TODO:
// OBSTACLES
// BENCHMARK AGAINST TEXELFETCH

uniform float timestep; // 1 / FPS
uniform float dissipation; // 0-1

vec4 advection4(int vInput, int xInput) {
  vec2 v = texture(sTD2DInputs[vInput], vUV.st).rg;
  // follow the velocity field "back in time"
  vec2 pos = vUV.st - timestep * v;

  return dissipation * texture(sTD2DInputs[xInput], pos);
}

vec2 advection2(int vInput, int xInput) {
	return advection4(vInput, xInput).rg;
}


// takes the intermediate velocity field as parameter
// output is divergence - the b param of jacobi

float divergence(int vInput) {
	NeighborSamples vN = texFetchNeighbors(vInput);

	float halfInverseCellSize = 0.5;

	// Compute the velocity's divergence using central differences
	float divergence = halfInverseCellSize * ((vN.Right.x - vN.Left.x) + (vN.Top.y - vN.Bottom.y));

	return divergence;
}

// JACOBI
uniform float alpha; // aka centerFactor - 1 -> zero viscosity, 3-4 - watercolor look
uniform float rBeta; // aka stencilFactor - should be 0.25 
// some computations use:
// alpha = _dx * _dx / (_rViscosity * _rTimestep);
// beta = 1 / (4 * alpha)



// pressure begins as all 0
float jacobi(int pInput, int dInput){
	vec2 oL = vec2(-1,0);
	vec2 oR = vec2(1,0);
	vec2 oB = vec2(0,-1);
	vec2 oT = vec2(0,1);
	vec2 oC = vec2(0,0);

	EdgeCases edge = checkEdges();

	oL.y += edge.Bottom - edge.Top;
	oR.y += edge.Bottom - edge.Top;
	oB.y += edge.Bottom - edge.Top;
	oT.y += edge.Bottom - edge.Top;
	oC.y += edge.Bottom - edge.Top;

	oL.x += edge.Left - edge.Right;
	oR.x += edge.Left - edge.Right;
	oB.x += edge.Left - edge.Right;
	oT.x += edge.Left - edge.Right;
	oC.x += edge.Left - edge.Right;

	// adjacent pressure samples
	// mac users are getting an error here due to the use of variables for the lookup offset
	// still looking for a fix but the brute force way is to rewrite this whole jacobi method longhand
  	float pL = textureOffset(sTD2DInputs[pInput], vUV.st, ivec2(oL.x, oL.y)).r;
  	float pR = textureOffset(sTD2DInputs[pInput], vUV.st, ivec2(oR.x, oR.y)).r;
  	float pB = textureOffset(sTD2DInputs[pInput], vUV.st, ivec2(oB.x, oB.y)).r;
  	float pT = textureOffset(sTD2DInputs[pInput], vUV.st, ivec2(oT.x, oT.y)).r;
  
  	// b (DIVERGENCE) sample, from center
  	float bC = textureOffset(sTD2DInputs[dInput], vUV.st, ivec2(oC.x, oC.y)).r;

	return (pL + pR + pB + pT - alpha * bC) * rBeta;
}


uniform float uGradientScale;

vec2 subtractGradient(int pInput, int vInput)
{
	NeighborSamples pN = texFetchNeighbors(pInput);

	float halfInverseCellSize = 0.5;

	vec2 oldV = texture(sTD2DInputs[vInput], vUV.st).xy;
	// compute the gradient
	vec2 grad = vec2(pN.Right.x - pN.Left.x, pN.Top.x - pN.Bottom.x) * uGradientScale * halfInverseCellSize;
	// velocity with zero divergence
	vec2 newV = oldV - grad;

  return newV; 
}


uniform float uScale;

vec4 boundaryEnforced(int xInput){

	float scale = 1;
	float x = 0;
	float y = 0;

	EdgeCases edge = checkEdges();

	x += edge.Left;
	x += edge.Right * -1;
	y += edge.Bottom;
	y += edge.Top * -1;

	ivec2 offset = ivec2(x,y);

	// scale is 1 unless it's an edge, in which case it's the uniform value uScale
	scale += uScale * or( when_neq(x,0), when_neq(y,0) ) - when_neq(x,0);

	return scale * textureOffset(sTD2DInputs[xInput], vUV.st, offset);
}


float computeVorticity(int vInput)
{
	float halfReciprocalGridScale = 0.5;
	NeighborSamples vNeighbors = texFetchNeighbors(vInput);
	return halfReciprocalGridScale * ((vNeighbors.Right.y - vNeighbors.Left.y) - (vNeighbors.Top.x - vNeighbors.Bottom.x));
}

uniform vec2 uVortConfinementScale;
uniform float uTimeStep;


// not currently in use because I don't see the effect enough to justify the compute cost. Maybe you do?
vec2 vorticityConfinement( int vortInput, int velInput)
{
	float halfReciprocalGridScale = 0.5;
	NeighborSamples vorticity = texFetchNeighbors(vortInput);
	vec2 force = halfReciprocalGridScale * vec2(abs(vorticity.Top.x) - abs(vorticity.Bottom.x), abs(vorticity.Right.x) - abs(vorticity.Left.x));

	// Safe normalize
	float epsilon = 2.4414e-4; // 2^-12
	float magnitudeSquared = max(epsilon, dot(force, force));
	float vortCenter = texture(sTD2DInputs[vortInput], vUV.st).x;

	force *= inversesqrt(magnitudeSquared);
	force *= uVortConfinementScale * vortCenter * vec2(1, -1);

	vec2 velocityNew = texture(sTD2DInputs[velInput], vUV.st).rg;
	return velocityNew + uTimeStep * force;
} 

uniform float uDisplayScale;
uniform vec4 uBias;

// re-ranges input float texture to a visible range for debug purposes
vec4 displayScalar(int xInput)
{
	return uBias + uDisplayScale * texture(sTD2DInputs[xInput], vUV.st).xxxx;
}

// re-ranges input float texture to a visible range for debug purposes
vec4 displayVec2(int xInput)
{
	vec2 inValue = texture(sTD2DInputs[xInput], vUV.st).xy;


	return uBias + uDisplayScale * vec4(inValue, 0, 1 );
}