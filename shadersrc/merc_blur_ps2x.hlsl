#include "common.hlsl"

float4 main( PS_INPUT i ) : COLOR
{
    float Pi = 6.28318530718; // Pi*2
    
    // GAUSSIAN BLUR SETTINGS {{{
    const float Directions = 16.0; // BLUR DIRECTIONS (Default 16.0 - More is better but slower)
    const float Quality = 3.0; // BLUR QUALITY (Default 4.0 - More is better but slower)
    float Size = Constants0.x; // BLUR SIZE (Radius)
    // GAUSSIAN BLUR SETTINGS }}}
   
    float2 Radius = Size / TexBaseSize.xy;
    Radius *= 0.0001;
    
    // Normalized pixel coordinates (from 0 to 1)
    float2 uv = i.uv;
    // Pixel colour
    float4 Color = tex2D(TexBase, uv);
    
    // Blur calculations
    for( float d=0.0; d<Pi; d+=Pi/Directions)
    {
		for(float i=1.0/Quality; i<=1.0; i+=1.0/Quality)
        {
			Color += tex2D( TexBase, uv+float2(cos(d),sin(d))*Radius*i);		
        }
    }
    
    // Output to screen
    Color /= Quality * Directions - 15.0;

    return Color;
}