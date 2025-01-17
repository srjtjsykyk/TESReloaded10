//
// Generated by Microsoft (R) HLSL Shader Compiler 9.23.949.2378
//
// Parameters:

float4 AmbientColor : register(c1);
sampler2D BaseMap[7] : register(s0);
sampler2D NormalMap[7] : register(s7);
float4 PSLightColor[10] : register(c3);
float4 TESR_FogColor : register(c15);
float4 PSLightDir : register(c18);
float4 PSLightPosition[8] : register(c19);
float4 TESR_ShadowData : register(c32);
sampler2D TESR_ShadowMapBufferNear : register(s14) = sampler_state { ADDRESSU = CLAMP; ADDRESSV = CLAMP; MAGFILTER = LINEAR; MINFILTER = LINEAR; MIPFILTER = LINEAR; };
sampler2D TESR_ShadowMapBufferFar : register(s15) = sampler_state { ADDRESSU = CLAMP; ADDRESSV = CLAMP; MAGFILTER = LINEAR; MINFILTER = LINEAR; MIPFILTER = LINEAR; };

// Registers:
//
//   Name            Reg   Size
//   --------------- ----- ----
//   AmbientColor    const_1       1
//   PSLightColor[0]    const_3       4
//   PSLightDir      const_18      1
//   PSLightPosition[0] const_19      3
//   BaseMap         texture_0       2
//   NormalMap       texture_7       2
//


// Structures:

struct VS_INPUT {
	float3 LCOLOR_0 : COLOR0;
    float3 BaseUV : TEXCOORD0;
    float3 texcoord_1 : TEXCOORD1_centroid;
	float3 texcoord_2 : TEXCOORD2_centroid;
    float3 texcoord_3 : TEXCOORD3_centroid;
    float3 texcoord_4 : TEXCOORD4_centroid;
    float3 texcoord_5 : TEXCOORD5_centroid;
	float4 texcoord_6 : TEXCOORD6;
    float4 texcoord_7 : TEXCOORD7;
};

struct PS_OUTPUT {
    float4 color_0 : COLOR0;
};

#include "Includes/Shadow.hlsl"

PS_OUTPUT main(VS_INPUT IN) {
    PS_OUTPUT OUT;

#define	expand(v)		(((v) - 0.5) / 0.5)
#define	compress(v)		(((v) * 0.5) + 0.5)
#define	shade(n, l)		max(dot(n, l), 0)
#define	shades(n, l)		saturate(dot(n, l))

    float3 m43;
    float3 m45;
    float3 m47;
    float3 m49;
    float3 q0;
    float3 q1;
    float3 q2;
    float3 q3;
    float3 q4;
    float3 q48;
    float3 q5;
    float3 q52;
    float3 q6;
    float3 q7;
    float3 q70;
    float3 q8;
    float4 r0;
    float4 r1;
    float4 r2;
    float4 r3;
    float3 r4;

    r0.xyzw = tex2D(NormalMap[1], IN.BaseUV.xy);
    r1.xyzw = tex2D(NormalMap[0], IN.BaseUV.xy);
    r2.xyzw = tex2D(BaseMap[1], IN.BaseUV.xy);
    r3.xyzw = tex2D(BaseMap[0], IN.BaseUV.xy);
    q0.xyz = normalize(IN.texcoord_5.xyz);
    q1.xyz = normalize(IN.texcoord_4.xyz);
    q3.xyz = normalize(IN.texcoord_3.xyz);
    q52.xyz = normalize((2 * ((r1.xyz - 0.5) * IN.LCOLOR_0.x)) + (2 * ((r0.xyz - 0.5) * IN.LCOLOR_0.y)));	// [0,1] to [-1,+1]
    r1.xyz = r2.xyz * IN.LCOLOR_0.y;
    m45.xyz = mul(float3x3(q3.xyz, q1.xyz, q0.xyz), PSLightDir.xyz);
    q7.xyz = PSLightPosition[2].xyz - IN.texcoord_2.xyz;
    q8.xyz = q7.xyz / PSLightPosition[2].w;
    m47.xyz = mul(float3x3(q3.xyz, q1.xyz, q0.xyz), q7.xyz);
    q5.xyz = PSLightPosition[1].xyz - IN.texcoord_2.xyz;
    r2.w = shades(q52.xyz, normalize(m47.xyz)) * (1 - shades(q8.xyz, q8.xyz));
    r0.w = shades(q52.xyz, m45.xyz);
    q6.xyz = q5.xyz / PSLightPosition[1].w;
    m49.xyz = mul(float3x3(q3.xyz, q1.xyz, q0.xyz), q5.xyz);
    q2.xyz = PSLightPosition[0].xyz - IN.texcoord_2.xyz;
    q4.xyz = q2.xyz / PSLightPosition[0].w;
    m43.xyz = mul(float3x3(q3.xyz, q1.xyz, q0.xyz), q2.xyz);
    r4.xyz = normalize(m43.xyz);
    q48.xyz = (r0.w * PSLightColor[0].rgb) + (((1 - shades(q4.xyz, q4.xyz)) * shades(q52.xyz, r4.xyz)) * PSLightColor[1].xyz);
    q70.xyz = ((shades(q52.xyz, normalize(m49.xyz)) * (1 - shades(q6.xyz, q6.xyz))) * PSLightColor[2].xyz) + q48.xyz;
    r0.xyz = ((GetLightAmount(IN.texcoord_6, IN.texcoord_7) * ((r2.w * PSLightColor[3].xyz) + q70.xyz)) + AmbientColor.rgb) * ((IN.LCOLOR_0.x * r3.xyz) + r1.xyz);
    r1.xyz = r0.xyz * IN.texcoord_1.xyz;
    OUT.color_0.a = 1;
    OUT.color_0.rgb = (IN.BaseUV.z * (TESR_FogColor.xyz - (IN.texcoord_1.xyz * r0.xyz))) + r1.xyz;

    return OUT;
};

// approximately 79 instruction slots used (4 texture, 75 arithmetic)
