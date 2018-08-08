// glsl
struct NeighborSamples
{
  vec4 Left, Right, Bottom, Top;  
};

struct EdgeCases
{
  float Left, Right, Bottom, Top; 
};

NeighborSamples texFetchNeighbors(int texInput)
{
  vec4 left = textureOffset(sTD2DInputs[texInput], vUV.st, ivec2(-1, 0));
  vec4 right = textureOffset(sTD2DInputs[texInput], vUV.st, ivec2(1, 0));
  vec4 bottom = textureOffset(sTD2DInputs[texInput], vUV.st, ivec2(0,-1));
  vec4 top = textureOffset(sTD2DInputs[texInput], vUV.st, ivec2(0, 1));
  return NeighborSamples(left, right, bottom, top);
}

EdgeCases checkEdges()
{
	float left =   round( when_lt(vUV.s, uTD2DInfos[0].res.x)); 
	float right =  round( when_gt(vUV.s, 1.0 - uTD2DInfos[0].res.x)); 
	float bottom = round( when_lt(vUV.t, uTD2DInfos[0].res.y));
	float top = 	 round( when_gt(vUV.t, 1.0 - uTD2DInfos[0].res.y));
	return EdgeCases(left, right, bottom, top);
}
