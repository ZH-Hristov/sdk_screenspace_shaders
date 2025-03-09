#include "common.hlsl"

float4 main( PS_INPUT i ) : COLOR
{
    float2 center = float2(Constants0.x, Constants0.y);
	float blurStart = 1.0;
    float blurWidth = Constants0.z;
    
    float2 nuv = i.uv;
    nuv -= center;
    float precompute = blurWidth * (1.0 / float(10 - 1));
    
    float4 color = float4(0, 0, 0, 0);
    for(int i = 0; i < 10; i++)
    {
        float scale = blurStart + (float(i)* precompute);
        color += tex2D(TexBase, nuv * scale + center);
    }
    
    
    color /= float(10);
    
	return color;
}