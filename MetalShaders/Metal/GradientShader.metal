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

fragment float4 gradShader(VertexOut in [[stage_in]], constant float &time [[buffer(0)]], constant float2 &iResolution [[buffer(1)]]) {
  float2 uv = in.texCoord;
  
  float3 color = float3(0,(0.5 - 0.5*sin(time))*0.2,(uv.x + uv.y - 0.3)*0.3);
  float3 rainbow = float3(abs(sin(time/5)), uv.y, uv.x);
  //uv.x = 1/cos(uv.x);
float f = 0.04*exp(-uv.x*2)*cos(time)*sin(uv.x*20 + time) + 0.5 + uv.x*uv.x;
  if (uv.y < f) {
    color = rainbow;
  }
  
  color = mix(color, rainbow, smoothstep(0.4*uv.x, 0,  uv.y - f));
  return float4(color, 1);
}

// ************************************************************
// Переписывали с shaderToy: vec -> float, mat2 -> float2x2, uv как в исходном шейдере,
// time глобально не доступна, нужно прокидывать в функции, где используется


float colormap_red(float x) {
    if (x < 0.0) {
        return 54.0 / 255.0;
    } else if (x < 20049.0 / 82979.0) {
        return (829.79 * x + 54.51) / 255.0;
    } else {
        return 1.0;
    }
}

float colormap_green(float x) {
    if (x < 20049.0 / 82979.0) {
        return 0.0;
    } else if (x < 327013.0 / 810990.0) {
        return (8546482679670.0 / 10875673217.0 * x - 2064961390770.0 / 10875673217.0) / 255.0;
    } else if (x <= 1.0) {
        return (103806720.0 / 483977.0 * x + 19607415.0 / 483977.0) / 255.0;
    } else {
        return 1.0;
    }
}

float colormap_blue(float x) {
    if (x < 0.0) {
        return 54.0 / 255.0;
    } else if (x < 7249.0 / 82979.0) {
        return (829.79 * x + 54.51) / 255.0;
    } else if (x < 20049.0 / 82979.0) {
        return 127.0 / 255.0;
    } else if (x < 327013.0 / 810990.0) {
        return (792.02249341361393720147485376583 * x - 64.364790735602331034989206222672) / 255.0;
    } else {
        return 1.0;
    }
}

float4 colormap(float x) {
    return float4(colormap_red(x), colormap_green(x), colormap_blue(x), 1.0);
}

float rand(float2 n) {
    return fract(sin(dot(n, float2(12.9898, 4.1414))) * 43758.5453);
}

float noise(float2 p){
    float2 ip = floor(p);
    float2 u = fract(p);
    u = u*u*(3.0-2.0*u);

    float res = mix(
        mix(rand(ip),rand(ip+float2(1.0,0.0)),u.x),
        mix(rand(ip+float2(0.0,1.0)),rand(ip+float2(1.0,1.0)),u.x),u.y);
    return res*res;
}

constant float2x2 mtx = float2x2( 0.80,  0.60, -0.60,  0.80 );

float fbm( float2 p, float time)
{
    float f = 0.0;

    f += 0.500000*noise( p + time); p = mtx*p*2.02;
    f += 0.031250*noise( p ); p = mtx*p*2.01;
    f += 0.250000*noise( p ); p = mtx*p*2.03;
    f += 0.125000*noise( p ); p = mtx*p*2.01;
    f += 0.062500*noise( p ); p = mtx*p*2.04;
    f += 0.015625*noise( p + sin(time) );

    return f/0.96875;
}

float pattern(float2 p, float time)
{
  return fbm( p + fbm( p + fbm( p, time ), time ), time);
}

fragment float4 gradientShader(VertexOut in [[stage_in]], constant float &time [[buffer(0)]], constant float2 &iResolution [[buffer(1)]]) {
  float2 uv = in.texCoord;
  float shade = pattern(uv, time);
  return float4(colormap(shade).rgb, shade);
}
