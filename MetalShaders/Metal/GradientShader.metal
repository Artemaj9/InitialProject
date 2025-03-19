#include <metal_stdlib>
using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float2 texCoord;
};

vertex VertexOut vertexShader(uint vertexID [[vertex_id]], constant float2 *vertices [[buffer(0)]]) {
    VertexOut out;
    out.position = float4(vertices[vertexID] * 2.0 - 1.0, 0.0, 1.0);
    out.texCoord = vertices[vertexID];
    return out;
}

fragment float4 gradientShader(VertexOut in [[stage_in]], constant float &time [[buffer(0)]], constant float2 &iResolution [[buffer(1)]]) {
  float2 uv = in.texCoord;
  
  
  float3 color = float3(0, 0, 0);
  return float4(color, 1);
}
