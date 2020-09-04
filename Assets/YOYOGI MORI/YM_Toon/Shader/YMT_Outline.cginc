//UCTS_Outline.cginc
//Unitychan Toon Shader ver.2.0
//v.2.0.7.5
//nobuyuki@unity3d.com
//https://github.com/unity3d-jp/UnityChanToonShaderVer2_Project
//(C)Unity Technologies Japan/UCL
// 2018/08/23 N.Kobayashi (Unity Technologies Japan)
// カメラオフセット付きアウトライン（BaseColorライトカラー反映修正版）
// 2017/06/05 PS4対応版

uniform float4 _LightColor0;
uniform float4 _BaseColor;

uniform float _Unlit_Intensity;
uniform fixed _Is_Filter_LightColor;
uniform fixed _Is_LightColor_Outline;

uniform float4 _Color;
uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
uniform float _Outline_Width;
uniform float _Farthest_Distance;
uniform float _Nearest_Distance;
uniform sampler2D _CombinedMask; uniform float4 _CombinedMask_ST;
uniform float4 _Outline_Color;
uniform fixed _Is_BlendBaseColor;
uniform fixed _Is_BlendBaseColorWeight;
uniform float _Offset_Z;

uniform sampler2D _OutlineMap; uniform float4 _OutlineMap_ST;
uniform fixed _Is_OutlineMap;
//Baked Normal Texture for Outline
uniform sampler2D _BakedNormal; uniform float4 _BakedNormal_ST;
uniform fixed _Is_BakedNormal;

#ifdef _ALPHATEST_ON
uniform float _Clipping_Level;
uniform fixed _Inverse_Clipping;

#elif _ALPHAPREMULTIPLY_ON
uniform float _Tweak_transparency;
#endif

struct VertexInput {
    float4 vertex : POSITION;
    float3 normal : NORMAL;
    float4 tangent : TANGENT;
    float2 texcoord0 : TEXCOORD0;
};

struct VertexOutput {
    float4 pos : SV_POSITION;
    float2 uv0 : TEXCOORD0;
    float3 normalDir : TEXCOORD1;
    float3 tangentDir : TEXCOORD2;
    float3 bitangentDir : TEXCOORD3;
};

VertexOutput vert (VertexInput v) {
    VertexOutput o = (VertexOutput)0;
    o.uv0 = v.texcoord0;
    float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
    float2 Set_UV0 = o.uv0;
    float4 _CombinedMask_var = tex2Dlod(_CombinedMask, float4(TRANSFORM_TEX(Set_UV0, _CombinedMask),0.0,0));

    //baked Normal Texture for Outline
    o.normalDir = UnityObjectToWorldNormal(v.normal);
    o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
    o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
    float3x3 tangentTransform = float3x3( o.tangentDir, o.bitangentDir, o.normalDir);

    //UnpackNormal()が使えないので、以下で展開。使うテクスチャはBump指定をしないこと.
    float4 _BakedNormal_var = (tex2Dlod(_BakedNormal, float4(TRANSFORM_TEX(Set_UV0, _BakedNormal), 0.0,0)) * 2 - 1);
    float3 _BakedNormalDir = normalize(mul(_BakedNormal_var.rgb, tangentTransform));

    float Set_Outline_Width = _Outline_Width * 0.001
                                * smoothstep( _Farthest_Distance, _Nearest_Distance, distance(objPos.rgb,_WorldSpaceCameraPos) )
                                * _CombinedMask_var.g;

    float4 _ClipCameraPos = mul(UNITY_MATRIX_VP, float4(_WorldSpaceCameraPos.xyz, 1));

    #if defined(UNITY_REVERSED_Z)
        _Offset_Z = _Offset_Z * -0.01;
    #else
        _Offset_Z = _Offset_Z * 0.01;
    #endif

    // baked Normal Texture for Outline
    o.pos = UnityObjectToClipPos(lerp(float4(v.vertex.xyz + v.normal * Set_Outline_Width,1),
                                      float4(v.vertex.xyz + _BakedNormalDir * Set_Outline_Width, 1), _Is_BakedNormal));

    o.pos.z = o.pos.z + _Offset_Z * _ClipCameraPos.z;
    return o;
}

float4 frag(VertexOutput i) : SV_Target{

#ifdef _ALPHAPREMULTIPLY_ON
    clip(-1);
    return 1;
#endif

    float2 Set_UV0 = i.uv0.xy;

    // correct mipmapping
    float2 dx = ddx(Set_UV0);
    float2 dy = ddy(Set_UV0);

    float4 _MainTex_var = tex2Dgrad(_MainTex, Set_UV0, dx, dy);

#if defined(_ALPHATEST_ON)
    float baseMapAlpha = saturate((lerp( _MainTex_var.a, (1.0 -  _MainTex_var.a), _Inverse_Clipping )));
    clip(baseMapAlpha +_Clipping_Level - 0.5);
#endif

    _Color = _BaseColor;
    float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );

    half3 ambientSkyColor = unity_AmbientSky.rgb > 0.05
                            ? unity_AmbientSky.rgb * _Unlit_Intensity : half3(0.05,0.05,0.05) * _Unlit_Intensity;

    float3 lightColor = _LightColor0.rgb > 0.05 ? _LightColor0.rgb : ambientSkyColor.rgb;
    float lightColorIntensity = (0.299 * lightColor.r + 0.587 * lightColor.g + 0.114 * lightColor.b);

    lightColor = lightColorIntensity < 1 ? lightColor : lightColor / lightColorIntensity;
    lightColor = lerp(half3(1.0,1.0,1.0), lightColor, _Is_LightColor_Outline);

    float3 Set_BaseColor = _BaseColor.rgb * _MainTex_var.rgb;
    float3 _Is_BlendBaseColor_var = lerp( _Outline_Color.rgb * lightColor,
                                          _Outline_Color.rgb * Set_BaseColor * Set_BaseColor * lightColor, 
                                          _Is_BlendBaseColor * _Is_BlendBaseColorWeight);

    float3 _OutlineMap_var = tex2D(_OutlineMap,TRANSFORM_TEX(Set_UV0, _OutlineMap));

    float3 Set_Outline_Color = lerp(_Is_BlendBaseColor_var, _OutlineMap_var.rgb * _Outline_Color.rgb * lightColor, _Is_OutlineMap );
    return float4(Set_Outline_Color, 1);
}
