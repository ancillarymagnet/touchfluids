//glsl

uniform vec2 uMouse;
uniform float uR;
uniform float uSolidCenter;
uniform samplerBuffer uCircleArray;
uniform float uCircleArrayLength;

float donut(vec2 pos, float r, float emptyCenter){ 
    
    emptyCenter = min(emptyCenter,r-0.01);
    vec2 dist = vUV.st - pos;
	return 1.-smoothstep(emptyCenter,0,
                         dot(dist,dist)*4.0)- smoothstep(0,r,
                         dot(dist,dist)*4.0);
}

float donutArray(){
	float thisTex = 0.0;

	for( int i = 0; i < uCircleArrayLength; i++){

		vec4 aCircle = texelFetchBuffer(uCircleArray, i);
		thisTex += donut(vec2(aCircle.x, aCircle.y), aCircle.z, aCircle.w);
	}

	return thisTex;

}

out vec4 fragColor;
void main()
{
	vec4 color = vec4(1.0);
	
	float d = donutArray();
	fragColor = mix(vec4(0),color,d);
}
	