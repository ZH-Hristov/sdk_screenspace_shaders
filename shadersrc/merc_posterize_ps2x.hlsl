#include "common.hlsl"

float4 Posterize(float4 inputColor, float gamma, float numColors){
  float3 c = inputColor.rgb;
  c = pow(c, float3(gamma, gamma, gamma));
  c = c * numColors;
  c = floor(c);
  c = c / numColors;
  c = pow(c, float3(1.0/gamma, 1.0/gamma, 1.0/gamma));
  
  return float4(c, inputColor.a);
}

float4 main( PS_INPUT i ) : COLOR
{
    int STEPS = Constants0.x;
    float GAMMA = Constants0.y;
    float4 col = tex2D(TexBase, i.uv);
    
    float4 fragColor = Posterize(col, GAMMA, STEPS);
    return fragColor;
}
