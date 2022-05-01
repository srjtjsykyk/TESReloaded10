//
// Generated by Microsoft (R) HLSL Shader Compiler 9.23.949.2378
//
// Parameters:

float4 AmbientColor : register(c1);
sampler2D BaseMap : register(s0);
sampler2D HeightMap : register(s3);
sampler2D NormalMap : register(s1);
float4 PSLightColor[10] : register(c3);

float4 TESR_ShadowData : register(c30);
sampler2D TESR_ShadowMapBufferNear : register(s14) = sampler_state { ADDRESSU = CLAMP; ADDRESSV = CLAMP; MAGFILTER = LINEAR; MINFILTER = LINEAR; MIPFILTER = LINEAR; };
sampler2D TESR_ShadowMapBufferFar : register(s15) = sampler_state { ADDRESSU = CLAMP; ADDRESSV = CLAMP; MAGFILTER = LINEAR; MINFILTER = LINEAR; MIPFILTER = LINEAR; };

// Registers:
//
//   Name         Reg   Size
//   ------------ ----- ----
//   AmbientColor const_1       1
//   PSLightColor[0] const_3       1
//   BaseMap      texture_0       1
//   NormalMap    texture_1       1
//   HeightMap    texture_3       1
//


// Structures:

struct VS_INPUT {
    float2 BaseUV : TEXCOORD0;
    float3 texcoord_6 : TEXCOORD6_centroid;			// partial precision
    float3 color_0 : COLOR0;
    float4 color_1 : COLOR1;
    float3 texcoord_1 : TEXCOORD1_centroid;			// partial precision

    float4 texcoord_8 : TEXCOORD8;
    float4 texcoord_9 : TEXCOORD9;

};

struct VS_OUTPUT {
    float4 color_0 : COLOR0;
};

// Code:
#include "Includes/Shadow.hlsl"

VS_OUTPUT main(VS_INPUT IN) {
    VS_OUTPUT OUT;

#define	expand(v)		(((v) - 0.5) / 0.5)
#define	compress(v)		(((v) * 0.5) + 0.5)
#define	uvtile(w)		(((w) * 0.04) - 0.02)
#define	shade(n, l)		max(dot(n, l), 0)
#define	shades(n, l)		saturate(dot(n, l))

    float3 noxel1;
    float3 q2;
    float3 q4;
    float4 r0;
    float4 r2;
    float2 uv0;

    r0.xyzw = tex2D(HeightMap, IN.BaseUV.xy);			// partial precision
    r2.xyzw = tex2D(BaseMap, IN.BaseUV.xy);			// partial precision
    uv0.xy = ((IN.texcoord_6.xy / length(IN.texcoord_6.xyz)) * uvtile(r0.x)) + IN.BaseUV.xy;			// partial precision
    noxel1.xyz = tex2D(NormalMap, uv0.xy);			// partial precision
    r0.xyzw = tex2D(BaseMap, uv0.xy);			// partial precision
    q4.xyz = r0.xyz * IN.color_0.rgb;			// partial precision
    q2.xyz = GetLightAmount(IN.texcoord_8, IN.texcoord_9) * (shades(normalize(expand(noxel1.xyz)), IN.texcoord_1.xyz) * PSLightColor[0].rgb) + AmbientColor.rgb;			// partial precision
    OUT.color_0.a = r2.w * AmbientColor.a;			// partial precision
    OUT.color_0.rgb = (IN.color_1.a * (IN.color_1.rgb - (q4.xyz * max(q2.xyz, 0)))) + (q4.xyz * max(q2.xyz, 0));			// partial precision

    return OUT;
};

// approximately 24 instruction slots used (4 texture, 20 arithmetic)
 
