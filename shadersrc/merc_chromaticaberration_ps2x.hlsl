#include "common.hlsl"

float4 main( PS_INPUT i ) : COLOR
{
	float amount = Constants0.x;
    int centerfade = Constants0.y;

    float2 distFromCenter = i.uv - float2(0.5, 0.5);

    float2 aberrated = amount * pow(1, float2(3, 3));

    if (centerfade == 1) {
        aberrated = amount * pow(distFromCenter, float2(3.0, 3.0));
    }
	
    float3 abcol;
    abcol.r = tex2D( TexBase, i.uv - aberrated ).r;
    abcol.g = tex2D( TexBase, i.uv ).g;
    abcol.b = tex2D( TexBase, i.uv + aberrated ).b;

    float4 fragColor = float4(abcol, 1.0);
    
    return fragColor;
}
