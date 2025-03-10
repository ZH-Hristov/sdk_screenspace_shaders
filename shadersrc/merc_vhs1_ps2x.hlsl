#include "common.hlsl"

float rand(float2 co)
{
    float a = 12.9898;
    float b = 78.233;
    float c = 43758.5453;
    float dt= dot(co.xy ,float2(a,b));
    float sn= fmod(dt,3.14);
    return frac(sin(sn) * c);
}

float4 main( PS_INPUT i ) : COLOR
{
	float2 uv = i.uv;
    float iTime = Constants0.x;
    float redOffsetPower = Constants0.y;
    float greenOffsetPower = Constants0.z;
	
	float magnitude = 0.000003;
	
	// Set up offset
	float2 offsetRedUV = uv;
	offsetRedUV.x = uv.x + rand(float2(iTime*0.03,uv.y*0.42)) * redOffsetPower;
	offsetRedUV.x += sin(rand(float2(iTime*0.2, uv.y)))*magnitude;
	
	float2 offsetGreenUV = uv;
	offsetGreenUV.x = uv.x + rand(float2(iTime*0.004,uv.y*0.002)) * greenOffsetPower;
	offsetGreenUV.x += sin(iTime*9.0)*magnitude;
	
	float2 offsetBlueUV = uv;
	offsetBlueUV.x = uv.y;
	offsetBlueUV.x += rand(float2(cos(iTime*0.01),sin(uv.y)));
	
	// Load tex2D
	float r = tex2D(TexBase, offsetRedUV).r;
	float g = tex2D(TexBase, offsetGreenUV).g;
	float b = tex2D(TexBase, uv).b;
	
	float4 fragColor = float4(r,g,b,0);

    return fragColor;
}