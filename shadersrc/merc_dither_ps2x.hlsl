#include "common.hlsl"

float4 main( PS_INPUT i ) : COLOR
{
    float2 fragCoord = i.uv * TexBaseSize;

    float3 src = tex2D(TexBase, i.uv).rgb;
    float lum = tex2D(Tex1, fragCoord / float2(8, 8)).r;
    float4 fragColor = float4(src.r >= lum ? 1.:0.,
                     src.g >= lum ? 1.:0.,
                     src.b >= lum ? 1.:0.,
                     1.);

    return fragColor;
}
