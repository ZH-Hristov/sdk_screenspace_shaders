#include "common.hlsl"

//
// Description : Array and textureless GLSL 2D simplex noise function.
//      Author : Ian McEwan, Ashima Arts.
//  Maintainer : stegu
//     Lastmod : 20110822 (ijm)
//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
//               Distributed under the MIT License. See LICENSE file.
//               https://github.com/ashima/webgl-noise
//               https://github.com/stegu/webgl-noise
// 

float3 mod289(float3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

float2 mod289(float2 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

float3 permute(float3 x) {
  return mod289(((x*34.0)+1.0)*x);
}

float snoise(float2 v)
  {
  const float4 C = float4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                      0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                     -0.577350269189626,  // -1.0 + 2.0 * C.x
                      0.024390243902439); // 1.0 / 41.0
// First corner
  float2 i  = floor(v + dot(v, C.yy) );
  float2 x0 = v -   i + dot(i, C.xx);

// Other corners
  float2 i1;
  //i1.x = step( x0.y, x0.x ); // x0.x > x0.y ? 1.0 : 0.0
  //i1.y = 1.0 - i1.x;
  i1 = (x0.x > x0.y) ? float2(1.0, 0.0) : float2(0.0, 1.0);
  // x0 = x0 - 0.0 + 0.0 * C.xx ;
  // x1 = x0 - i1 + 1.0 * C.xx ;
  // x2 = x0 - 1.0 + 2.0 * C.xx ;
  float4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;

// Permutations
  i = mod289(i); // Avoid truncation effects in permutation
  float3 p = permute( permute( i.y + float3(0.0, i1.y, 1.0 ))
		+ i.x + float3(0.0, i1.x, 1.0 ));

  float3 m = max(0.5 - float3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
  m = m*m ;
  m = m*m ;

// Gradients: 41 points uniformly over a line, mapped onto a diamond.
// The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)

  float3 x = 2.0 * frac(p * C.www) - 1.0;
  float3 h = abs(x) - 0.5;
  float3 ox = floor(x + 0.5);
  float3 a0 = x - ox;

// Normalise gradients implicitly by scaling m
// Approximation of: m *= inversesqrt( a0*a0 + h*h );
  m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );

// Compute final noise value at P
  float3 g;
  g.x  = a0.x  * x0.x  + h.x  * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}

float rand(float2 co)
{
   return frac(sin(dot(co.xy,float2(12.9898,78.233))) * 43758.5453);
}

float4 main( PS_INPUT i ) : COLOR
{
	float2 uv = i.uv;    
    float time = Constants0.x * 2.0;
    float2 fragCoord = float2(TexBaseSize.x, TexBaseSize.y);
    float4 ogcol = tex2D(TexBase, uv);
    
    // Create large, incidental noise waves
    float noise = max(0.0, snoise(float2(time, uv.y * 0.3)) - 0.3) * (1.0 / 0.7);
    
    // Offset by smaller, constant noise waves
    noise = noise + (snoise(float2(time*10.0, uv.y * 2.4)) - 0.5) * 0.15;
    
    // Apply the noise as x displacement for every line
    float xpos = uv.x - noise * noise * 0.25;
	float4 fragColor = tex2D(TexBase, float2(xpos, uv.y));
    
    // Mix in some random interference for lines
    fragColor.rgb = lerp(fragColor.rgb, float3(rand(float2(uv.y * time, uv.y * time)), rand(float2(uv.y * time, uv.y * time)), rand(float2(uv.y * time, uv.y * time))), noise * 0.3).rgb;
    
    // Apply a line pattern every 4 pixels
    if (floor(fmod(fragCoord.y * 0.25, 2.0)) == 0.0)
    {
        fragColor.rgb *= 1.0 - (0.15 * noise);
    }
    
    // Shift green/blue channels (using the red channel)
    fragColor.g = lerp(fragColor.r, tex2D(TexBase, float2(xpos + noise * 0.05, uv.y)).g, 0.25);
    fragColor.b = lerp(fragColor.r, tex2D(TexBase, float2(xpos - noise * 0.05, uv.y)).b, 0.25);

    float4 finalcolor = lerp(ogcol, fragColor, Constants0.y);

    return finalcolor;
}