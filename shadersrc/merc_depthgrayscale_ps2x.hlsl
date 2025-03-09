#include "common.hlsl"

float4 main( PS_INPUT i ) : COLOR
{
	float depthStart = Constants0.x;
	float depthEnd = Constants0.y;

	float4 tex = tex2D(TexBase, i.uv);
	float4 depthTex = tex2D(Tex1, i.uv);

	float3 greyscale = float3(.5, .5, .5);
    float3 dotty = dot( float3(tex.r, tex.g, tex.b), greyscale );
	float iDepth = depthTex.r;
    float3 clr = float3( lerp(tex.r, dotty.r, smoothstep(depthStart, depthEnd, iDepth) ), lerp( tex.g, dotty.g, smoothstep(depthStart, depthEnd, iDepth) ), lerp( tex.b, dotty.b, smoothstep(depthStart, depthEnd, iDepth) ));

	return float4( clr.r, clr.g, clr.b, tex.a );
}
