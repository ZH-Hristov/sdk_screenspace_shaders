//Adapted from https://www.shadertoy.com/view/4sB3Rc

#include "common.hlsl"

float4 main( PS_INPUT i ) : COLOR
{
	float OuterVig = Constants0.x;
	float InnerVig = Constants0.y;
	float2 uv = i.uv;
	
	float4 color = tex2D(TexBase, uv);
	
	float2 center = float2(0.5,.5);
	
	float dist  = distance(center,uv )*1.414213;
	
	float vig = clamp((OuterVig-dist) / (OuterVig-InnerVig),0.0,1.0);
	
	color *= vig;
	
	return color;
}
