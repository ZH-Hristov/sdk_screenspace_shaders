#include "common.hlsl"

float3 channel_mix(float3 a, float3 b, float3 w) {
    return float3(lerp(a.r, b.r, w.r), lerp(a.g, b.g, w.g), lerp(a.b, b.b, w.b));
}

float gaussian(float z, float u, float o) {
    return (1.0 / (o * sqrt(2.0 * 3.1415))) * exp(-(((z - u) * (z - u)) / (2.0 * (o * o))));
}

float3 madd(float3 a, float3 b, float w) {
    return a + a * b * w;
}

float3 screen(float3 a, float3 b, float w) {
    return lerp(a, float3(1.0, 1.0, 1.0) - (float3(1.0, 1.0, 1.0) - a) * (float3(1.0, 1.0, 1.0) - b), w);
}

float3 overlay(float3 a, float3 b, float w) {
    return lerp(a, channel_mix(
        2.0 * a * b,
        float3(1, 1, 1) - 2.0 * (float3(1, 1, 1) - a) * (float3(1, 1, 1) - b),
        step(float3(0.5, 0.5, 0.5), a)
    ), w);
}

float3 soft_light(float3 a, float3 b, float w) {
    return lerp(a, pow(a, pow(float3(2, 2, 2), 2.0 * (float3(0.5, 0.5, 0.5) - b))), w);
}

float4 main( PS_INPUT i ) : COLOR
{
    float time = Constants0.x;
    float BLEND_MODE = Constants0.y;
    float SPEED = Constants0.z;
    float INTENSITY = Constants0.w;
    float MEAN = Constants1.x;
    float VARIANCE = Constants1.y;

    float4 color = tex2D(TexBase, i.uv);

    // SRGB Conversion
    color = pow(color, float4(2.2, 2.2, 2.2, 2.2));

    float t = time * float(SPEED);
    float seed = dot(i.uv, float2(12.9898, 78.233));
    float noise = frac(sin(seed) * 43758.5453 + t);
    noise = gaussian(noise, float(MEAN), float(VARIANCE) * float(VARIANCE));
     
    float w = float(INTENSITY);
	
    float3 grain = float3(noise, noise, noise) * (1.0 - color.rgb);
    
    switch( abs(BLEND_MODE) )
    {
        case 0:
            color.rgb += grain * w; break;
        case 1:
            color.rgb = screen(color.rgb, grain, w); break;
        case 2:
            color.rgb = overlay(color.rgb, grain, w); break;
        case 3:
            color.rgb = soft_light(color.rgb, grain, w); break;
        case 4:
            color.rgb = max(color.rgb, grain * w); break;
    }

    // SRGB Conversion
    color = pow(color, float4(1.0 / 2.2, 1.0 / 2.2, 1.0 / 2.2, 1.0 / 2.2) );
    return color;
}
