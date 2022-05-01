//
// Generated by Microsoft (R) HLSL Shader Compiler 9.23.949.2378
//
// Parameters:

float4 FogParam : register(c13);
row_major float4x4 ModelViewProj : register(c0);

row_major float4x4 TESR_ShadowCameraToLightTransform[2] : register(c36);


// Registers:
//
//   Name          Reg   Size
//   ------------- ----- ----
//   ModelViewProj[0] const_0        1
//   ModelViewProj[1] const_1        1
//   ModelViewProj[2] const_2        1
//   ModelViewProj[3] const_3        1
//   FogParam      const_13      1
//


// Structures:

struct VS_INPUT {
    float4 position : POSITION;
    float4 color_0 : COLOR0;
};

struct VS_OUTPUT {
    float4 color_0 : COLOR0;
    float4 position : POSITION;
    float2 texcoord_0 : TEXCOORD0;

	float4 texcoord_6 : TEXCOORD6;
	float4 texcoord_7 : TEXCOORD7;

};

// Code:

float4 lit(float4 src){
    float4 dest = {1.0f, 0.0f, 0.0f, 1.0f};

    float power = src.w;
    const float MAXPOWER = 127.9961f;
    if (power < -MAXPOWER)
        power = -MAXPOWER;          // Fits into 8.8 fixed point format
    else if (power > MAXPOWER)
        power = MAXPOWER;          // Fits into 8.8 fixed point format

    if (src.x > 0) {
        dest.y = src.x;
        if (src.y > 0) {
            // Allowed approximation is EXP(power * LOG(src.y))
            dest.z = pow(src.y, power);
        }
    }
    return dest;
};

VS_OUTPUT main(VS_INPUT IN) {
    VS_OUTPUT OUT;

    const int4 const_4 = {0, 1, 0, 0};

    float3 mdl0;
    float4 r0;

    mdl0.xyz = mul(float3x4(ModelViewProj[0].xyzw, ModelViewProj[1].xyzw, ModelViewProj[2].xyzw), IN.position.xyzw);
    r0.zw = FogParam.z;
    r0.xy = 1 - saturate((FogParam.x - length(mdl0.xyz)) / FogParam.y);
    r0 = lit(r0);
    OUT.color_0.rgba = IN.color_0.rgba;
    OUT.position.xyz = mdl0.xyz;
    OUT.position.w = dot(ModelViewProj[3].xyzw, IN.position.xyzw);
    OUT.texcoord_0.xy = (r0.z * const_4.xy) + const_4.yx;

    OUT.texcoord_6 = mul(OUT.position, TESR_ShadowCameraToLightTransform[0]);
	OUT.texcoord_7 = mul(OUT.position, TESR_ShadowCameraToLightTransform[1]);

    return OUT;
};

// approximately 18 instruction slots used
 
