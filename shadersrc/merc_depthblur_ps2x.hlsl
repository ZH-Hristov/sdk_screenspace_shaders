#include "common.hlsl"


float2 rand( float2  p ) { p = float2( dot(p,float2(127.1,311.7)), dot(p,float2(269.5,183.3)) ); return frac(sin(p)*43758.5453); }

float4 main( PS_INPUT i ) : COLOR
{
    float depthStart = Constants0.x;
    float depthEnd = Constants0.y;   
    float strength = Constants0.z; 

    float4 color = tex2D(TexBase, i.uv);
    float4 fullDepth = tex2D(Tex1, i.uv);
    float4 blurred = tex2D(TexBase, i.uv + strength*(rand(i.uv)-0.5));
    float4 result = lerp(color.rgba, blurred.rgba, smoothstep(depthStart, depthEnd, fullDepth.r) );
    result.a = color.a;
	
	return result;
}