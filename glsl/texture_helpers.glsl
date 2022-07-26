// glsl
struct NeighborSamples
{
  vec4 Left, Right, Bottom, Top;  
};

struct EdgeCases
{
  float Left, Right, Bottom, Top; 
};

ivec2 GetUVAsPixelCoord(vec2 uv)
{
  vec2 res = uTD2DInfos[0].res.zw;
  return ivec2(uv * res);
}

NeighborSamples texFetchNeighbors(int texInput)
{
  ivec2 coord = GetUVAsPixelCoord(vUV.st);
  vec4 left = texelFetch(sTD2DInputs[texInput], coord + ivec2(-1, 0), 0);
  vec4 right = texelFetch(sTD2DInputs[texInput], coord + ivec2(1, 0), 0);
  vec4 bottom = texelFetch(sTD2DInputs[texInput], coord + ivec2(0, -1), 0);
  vec4 top = texelFetch(sTD2DInputs[texInput], coord + ivec2(0, 1), 0);
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
