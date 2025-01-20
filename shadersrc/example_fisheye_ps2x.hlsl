#include "common.hlsl"

float4 main( PS_INPUT i ) : COLOR
{
	float2 uv = i.uv;
    float aspectRatio = TexBaseSize.x / TexBaseSize.y;
    float strength = Constants0.x;
    
    float2 intensity = float2(strength * aspectRatio, strength * aspectRatio);

    float2 coords = uv;
    coords = (coords - 0.5) * 2.0;		
		
    float2 realCoordOffs;
    realCoordOffs.x = (1.0 - coords.y * coords.y) * intensity.y * (coords.x); 
    realCoordOffs.y = (1.0 - coords.x * coords.x) * intensity.x * (coords.y);
		
    float4 color = tex2D(TexBase, uv - realCoordOffs);
    
	return float4(color);
}
