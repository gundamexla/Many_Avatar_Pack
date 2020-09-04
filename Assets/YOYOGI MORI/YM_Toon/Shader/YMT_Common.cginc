//UCTS_DoubleShadeWithFeather.cginc
//Unitychan Toon Shader ver.2.0
//v.2.0.7.5
//nobuyuki@unity3d.com
//https://github.com/unity3d-jp/UnityChanToonShaderVer2_Project
//(C)Unity Technologies Japan/UCL

#ifndef YMTOON_CORE
#define YMTOON_CORE

#include "UnityStandardCore_Lite.cginc"
#define _TANGENT_TO_WORLD

uniform float4 _BaseColor;

uniform fixed _Use_BaseAs1st;
uniform sampler2D _1st_ShadeMap; uniform float4 _1st_ShadeMap_ST;
uniform float4 _1st_ShadeColor;
uniform float _Use_1stShadeMapAlpha_As_ShadowMask;
uniform float _1stShadeMapMask_Inverse;
uniform float _Tweak_1stShadingGradeMapLevel;

uniform fixed _Use_1stAs2nd;
uniform sampler2D _2nd_ShadeMap; uniform float4 _2nd_ShadeMap_ST;
uniform float4 _2nd_ShadeColor;
uniform fixed _Is_LightColor_2nd_Shade;
uniform float _Use_2ndShadeMapAlpha_As_ShadowMask;
uniform float _2ndShadeMapMask_Inverse;
uniform float _Tweak_2ndShadingGradeMapLevel;

uniform float4 _BumpMap_ST;
uniform fixed _Is_NormalMapToBase;
uniform fixed _Set_SystemShadowsToBase;
uniform float _Tweak_SystemShadowsLevel;
uniform float _BaseColor_Step;
uniform float _BaseShade_Feather;

uniform float _ShadeColor_Step;
uniform float _1st2nd_Shades_Feather;

uniform float4 _HighColor;
uniform sampler2D _HighColorMap; uniform float4 _HighColorMap_ST;
uniform float _Use_2ndUV_As_HighColorMapMask;

uniform fixed _Is_LightColor_HighColor;
uniform fixed _Is_NormalMapToHighColor;
uniform float _HighColor_Power;
uniform fixed _Is_SpecularToHighColor;
uniform fixed _Is_BlendAddToHiColor;
uniform fixed _Is_UseTweakHighColorOnShadow;
uniform float _TweakHighColorOnShadow;

uniform float _HighColorMapMaskScaler;
uniform float _HighColorMapMaskOffset;

uniform sampler2D _CombinedMask; uniform float4 _CombinedMask_ST;

uniform float _Tweak_HighColorMaskLevel;
uniform fixed _RimLight;
uniform float4 _RimLightColor;
uniform fixed _Is_LightColor_RimLight;
uniform fixed _Is_NormalMapToRimLight;
uniform float _RimLight_Power;
uniform float _RimLight_InsideMask;
uniform fixed _RimLight_FeatherOff;
uniform fixed _LightDirection_MaskOn;
uniform float _Tweak_LightDirection_MaskLevel;
uniform fixed _Add_Antipodean_RimLight;
uniform float4 _Ap_RimLightColor;
uniform fixed _Is_LightColor_Ap_RimLight;
uniform float _Ap_RimLight_Power;
uniform fixed _Ap_RimLight_FeatherOff;

uniform float _Tweak_RimLightMaskLevel;

//Emissive
uniform float4 _EmissionMap_ST;
uniform float4 _Emissive_Color;

uniform fixed _Is_ViewCoord_Scroll;
uniform float _Rotate_EmissiveUV;
uniform float _Base_Speed;
uniform float _Scroll_EmissiveU;
uniform float _Scroll_EmissiveV;
uniform fixed _Is_PingPong_Base;
uniform float4 _ColorShift;
uniform float4 _ViewShift;
uniform float _ColorShift_Speed;
uniform fixed _Is_ColorShift;
uniform fixed _Is_ViewShift;
uniform float3 emissive;

uniform float _Unlit_Intensity;
uniform fixed _Is_Filter_HiCutPointLightColor;
uniform fixed _Is_Filter_LightColor;

#ifdef _ALPHATEST_ON
uniform float _Clipping_Level;
uniform fixed _Inverse_Clipping;

#elif _ALPHAPREMULTIPLY_ON
uniform float _Tweak_transparency;
#endif

uniform float _SSSAlphaInverse;
uniform float _Is_Skin;
uniform float4 _SkinSSSMulColor;
uniform float4 _HSVOffset;
uniform sampler2D _GrabPassTexture;
uniform half _FakeTransparentWeight;

uniform float _Use_OwnDirLight;
uniform float4 _OwnDirectionalLightDir;
uniform float4 _OwnDirectionalLightColor;

uniform float _AnisotropicHighLightPowerLow;
uniform float _AnisotropicHighLightStrengthLow;
uniform float _AnisotropicHighLightPowerHigh;
uniform float _AnisotropicHighLightStrengthHigh;
uniform float _ShiftTangent;
uniform float _Use_Aniso_HighLight;

uniform float _IBLWeight;
uniform float _StandardBlendWeight;

// UV回転をする関数：RotateUV()
//float2 rotatedUV = RotateUV(i.uv0, (_angular_Verocity*3.141592654), float2(0.5, 0.5), _Time.g);
inline float2 RotateUV(float2 _uv, float _radian, float2 _piv, float _time)
{
    float RotateUV_ang = _radian;
    float RotateUV_cos = cos(_time*RotateUV_ang);
    float RotateUV_sin = sin(_time*RotateUV_ang);
    return (mul(_uv - _piv, float2x2( RotateUV_cos, -RotateUV_sin, RotateUV_sin, RotateUV_cos)) + _piv);
}

inline float GetLightIntensity(float3 lightColor){
    return 0.299 * lightColor.r + 0.587 * lightColor.g + 0.114 * lightColor.b;
}


inline fixed3 DecodeLightProbe( fixed3 N ){
return ShadeSH9(float4(N,1));
}

inline float easeInExpo(float t) {
    return (t == 0.0) ? 0.0 : pow(2.0, 10.0 * (t - 1.0));
}

float3 rgb2hsv(float3 rgb)
{
    float3 hsv;

    float maxValue = max(rgb.r, max(rgb.g, rgb.b));
    float minValue = min(rgb.r, min(rgb.g, rgb.b));
    float delta = maxValue - minValue;

    hsv.z = maxValue;

    if (maxValue != 0.0){
        hsv.y = delta / maxValue;
    }
    else {
        hsv.y = 0.0;
    }

    if (hsv.y > 0.0){
        if (rgb.r == maxValue) {
            hsv.x = (rgb.g - rgb.b) / delta;
        } else if (rgb.g == maxValue) {
            hsv.x = 2 + (rgb.b - rgb.r) / delta;
        } else {
            hsv.x = 4 + (rgb.r - rgb.g) / delta;
        }
        hsv.x /= 6.0;
        if (hsv.x < 0)
        {
            hsv.x += 1.0;
        }
    }

    return hsv;
}

float3 hsv2rgb(float3 hsv)
{
    float3 rgb;

    if (hsv.y == 0){
        rgb.r = rgb.g = rgb.b = hsv.z;
    }

    else {
        hsv.x *= 6.0;
        float i = floor (hsv.x);
        float f = hsv.x - i;
        float aa = hsv.z * (1 - hsv.y);
        float bb = hsv.z * (1 - (hsv.y * f));
        float cc = hsv.z * (1 - (hsv.y * (1 - f)));
        if( i < 1 ) {
            rgb.r = hsv.z;
            rgb.g = cc;
            rgb.b = aa;
        } else if( i < 2 ) {
            rgb.r = bb;
            rgb.g = hsv.z;
            rgb.b = aa;
        } else if( i < 3 ) {
            rgb.r = aa;
            rgb.g = hsv.z;
            rgb.b = cc;
        } else if( i < 4 ) {
            rgb.r = aa;
            rgb.g = bb;
            rgb.b = hsv.z;
        } else if( i < 5 ) {
            rgb.r = cc;
            rgb.g = aa;
            rgb.b = hsv.z;
        } else {
            rgb.r = hsv.z;
            rgb.g = aa;
            rgb.b = bb;
        }
    }
    return rgb;
}

float3 shiftColor(float3 rgb, half3 shift, half weight)
{
    float3 hsv = rgb2hsv(rgb);

    hsv.x += shift.x;
    if (1.0 <= hsv.x){hsv.x -= 1.0;}

    hsv.x = lerp(hsv.x, 0.0, weight);
    hsv.y *= shift.y;
    hsv.z *= shift.z;

    return hsv2rgb(hsv);
}


float3 ShiftTangent(float3 T, float3 N, float shift)
{
    float3 shiftedT = T + shift * N;
    return normalize(shiftedT);
}

float StrandSpecular(float3 T, float3 V, float3 L, float exponent, float strength)
{
    float3 H = normalize(L + V);
    float dotTH = dot(T, H);
    float sinTH = sqrt ( 1.0 - dotTH * dotTH);
    float dirAtten = smoothstep(-1.0, 0.0, dotTH);
    return dirAtten * pow(sinTH, exponent ) * strength;
}

uniform float _GI_Intensity;

struct YMT_VertexInput {
    float4 vertex : POSITION;
    float3 normal : NORMAL;
    float4 tangent : TANGENT;
    float2 texcoord0 : TEXCOORD0;
    float2 texcoord1 : TEXCOORD1;
    float isCullBack : TEXCOORD2;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct YMT_VertexOutput {
    float4 pos : SV_POSITION;
    float4 uv0 : TEXCOORD0; //xy uv0 , zw uv1
    float4 posWorld : TEXCOORD2;  //xyz:posworld // w: isBackFace
    float4 tangentToWorldAndPackedData[3] : TEXCOORD3;
    float4 ambientOrLightmapUV         : TEXCOORD6;
    UNITY_SHADOW_COORDS(7)
    UNITY_VERTEX_INPUT_INSTANCE_ID
    // float4 grabPos  : TEXCOORD7;
};

YMT_VertexOutput vertForward (YMT_VertexInput v) {
    YMT_VertexOutput o = (YMT_VertexOutput)0;

    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_TRANSFER_INSTANCE_ID(v, o);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

    o.uv0.xy = v.texcoord0;
    o.uv0.zw = v.texcoord1;
    o.posWorld.xyz = mul(unity_ObjectToWorld, v.vertex).xyz;
    o.posWorld.w = v.isCullBack;
    o.pos = UnityObjectToClipPos( v.vertex );

    UNITY_TRANSFER_SHADOW(o, v.texcoord0);

    float3 normalWorld = UnityObjectToWorldNormal(v.normal);

    //UTSではここを通る
    #ifdef _TANGENT_TO_WORLD
        float4 tangentWorld = float4(normalize(mul((float3x3)unity_ObjectToWorld, v.tangent.xyz)), v.tangent.w);

        float3x3 tangentToWorld = CreateTangentToWorldPerVertex(normalWorld, tangentWorld.xyz, tangentWorld.w);
        //tangent
        o.tangentToWorldAndPackedData[0].xyz = tangentToWorld[0];
        //binormal
        o.tangentToWorldAndPackedData[1].xyz = tangentToWorld[1];
        //normal
        o.tangentToWorldAndPackedData[2].xyz = tangentToWorld[2];
    #else
        o.tangentToWorldAndPackedData[0].xyz = 0;
        o.tangentToWorldAndPackedData[1].xyz = 0;
        o.tangentToWorldAndPackedData[2].xyz = normalWorld;
    #endif

    #if defined(DYNAMICLIGHTMAP_ON) || defined(UNITY_PASS_META)
        o.ambientOrLightmapUV = VertexGIForward(v.texcoord0, v.texcoord1, o.posWorld.xyz, normalWorld);
    #else
        o.ambientOrLightmapUV = VertexGIForward(v.texcoord0, v.texcoord0, o.posWorld.xyz, normalWorld);
    #endif

    // o.grabPos = ComputeGrabScreenPos(o.pos);

    return o;
}

float4 fragForward(YMT_VertexOutput i) {
    UNITY_SETUP_INSTANCE_ID(i);
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);

    float3 normalDir = normalize(i.tangentToWorldAndPackedData[2].xyz);
    float3x3 tangentTransform = float3x3( i.tangentToWorldAndPackedData[0].xyz, i.tangentToWorldAndPackedData[1].xyz, normalDir);
    float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
    float2 Set_UV0 = i.uv0.xy;
    float2 Set_UV1 = i.uv0.zw;

    float3 _BumpMap_var = UnpackScaleNormal(tex2D(_BumpMap,TRANSFORM_TEX(Set_UV0, _BumpMap)), _BumpScale);
    float3 normalDirection = normalize(mul( _BumpMap_var.rgb, tangentTransform )); // Perturbed normals

    // correct mipmapping
    float2 dx = ddx(Set_UV0);
    float2 dy = ddy(Set_UV0);

    float4 _MainTex_var = tex2Dgrad(_MainTex, Set_UV0, dx, dy);

// _ALPHAPREMULTIPLY_ON && _ALPHATEST_ON == Trans_Clip のときは上を通るようにする
#if defined(_ALPHATEST_ON) || (defined (_ALPHATEST_ON) && defined (_ALPHAPREMULTIPLY_ON))
    float baseMapAlpha = saturate((lerp( _MainTex_var.a, (1.0 -  _MainTex_var.a), _Inverse_Clipping )));
    clip(baseMapAlpha +_Clipping_Level - 0.5);

#elif _ALPHAPREMULTIPLY_ON
    float baseMapAlpha = _MainTex_var.a;
#endif

    UNITY_LIGHT_ATTENUATION(attenuation, i, i.posWorld.xyz);

#ifdef _IS_PASS_FWDBASE

    float4 worldSpaceLightPos0 = _Use_OwnDirLight ? float4(_OwnDirectionalLightDir.xyz, 1) : _WorldSpaceLightPos0;
    float4 lightColor0 = _Use_OwnDirLight ? float4(_OwnDirectionalLightColor.xyz, 1) : _LightColor0;

    float3 defaultLightDirection = normalize(UNITY_MATRIX_V[2].xyz + UNITY_MATRIX_V[1].xyz);
    float3 defaultLightColor = saturate(max(half3(0.05,0.05,0.05) *_Unlit_Intensity,
                                        max(ShadeSH9(half4(0.0, 0.0, 0.0, 1.0)), ShadeSH9(half4(0.0, -1.0, 0.0, 1.0)).rgb) *_Unlit_Intensity)
                                        );

    float3 lightDirection = normalize(lerp(defaultLightDirection, worldSpaceLightPos0.xyz, saturate(_Use_OwnDirLight + any(_WorldSpaceLightPos0.xyz))));

    float3 lightColor = lerp(max(defaultLightColor, lightColor0.rgb),
                             max(defaultLightColor, saturate(lightColor0.rgb)),
                             _Is_Filter_LightColor);

#elif _IS_PASS_FWDDELTA

    //_WorldSpaceLightPos0.w == 1 == PointLight
    float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz,
                                           _WorldSpaceLightPos0.xyz - i.posWorld.xyz,
                                           _WorldSpaceLightPos0.w));

    float3 addPassLightColor = (0.5 * dot(lerp( normalDir, normalDirection, _Is_NormalMapToBase ), lightDirection) + 0.5)
                                *_LightColor0.rgb * attenuation;

    //ref: Grayscale
    float pureIntencity = max(0.001, GetLightIntensity(_LightColor0));
    float3 lightColor = max(0,
                            lerp(addPassLightColor,
                                 lerp(0,
                                      min(addPassLightColor,addPassLightColor/pureIntencity),
                                      _WorldSpaceLightPos0.w),
                                _Is_Filter_LightColor)
                            );

#endif

////// Lighting:
    float3 halfDirection = normalize(viewDirection + lightDirection);
    float _HalfLambert_var = 0.5 * dot(lerp( normalDir, normalDirection, _Is_NormalMapToBase ), lightDirection) + 0.5;

    float4 _CombinedMask_var = tex2D(_CombinedMask, TRANSFORM_TEX(Set_UV0, _CombinedMask));
    float viewDot = ( dot(viewDirection, normalDirection) + 1.0 ) * 0.5;

    float _BaseColorStep_Feather_Sub = _BaseColor_Step - _BaseShade_Feather;
    float _1stShadeColorStep_Feather_Sub = _ShadeColor_Step - _1st2nd_Shades_Feather;

#ifdef _IS_PASS_FWDBASE
    float3 Set_LightColor = lightColor.rgb;
    float3 Set_BaseColor = (_BaseColor.rgb * _MainTex_var.rgb) * Set_LightColor;

#ifdef _DEBUG_BASE_COLOR_ONLY
    return float4(Set_BaseColor, 1);
#endif

#ifdef _DEBUG_BASE_MAP_ALPHA
    return float4(_MainTex_var.a, _MainTex_var.a, _MainTex_var.a, 1);
#endif

    float4 _1st_ShadeMap_var = lerp(tex2D(_1st_ShadeMap,TRANSFORM_TEX(Set_UV0, _1st_ShadeMap)), _MainTex_var, _Use_BaseAs1st);
    float3 Set_1st_ShadeColor = (_1st_ShadeColor.rgb*_1st_ShadeMap_var.rgb)  *Set_LightColor;
    float _1stShadingGradeMap_var = _Use_1stShadeMapAlpha_As_ShadowMask ?
                                        (_1stShadeMapMask_Inverse ? (1.0 - _1st_ShadeMap_var.a) : _1st_ShadeMap_var.a)
                                        : 1;

#ifdef _DEBUG_1ST_SHADING_GRADEMASK
        return float4(_1stShadingGradeMap_var, _1stShadingGradeMap_var, _1stShadingGradeMap_var, 1);
#endif

    float4 _2nd_ShadeMap_var = lerp(tex2D(_2nd_ShadeMap,TRANSFORM_TEX(Set_UV0, _2nd_ShadeMap)), _1st_ShadeMap_var, _Use_1stAs2nd);
    float3 Set_2nd_ShadeColor = (_2nd_ShadeColor.rgb * _2nd_ShadeMap_var.rgb) * Set_LightColor;
    float _2ndShadingGradeMap_var = _Use_2ndShadeMapAlpha_As_ShadowMask ?
                                        (_2ndShadeMapMask_Inverse ? (1.0 - _2nd_ShadeMap_var.a) : _2nd_ShadeMap_var.a)
                                        : 1;

#ifdef _DEBUG_2ND_SHADING_GRADEMASK
        return float4(_2ndShadingGradeMap_var, _2ndShadingGradeMap_var, _2ndShadingGradeMap_var, 1);
#endif

    float _1stShadingGradeMapLevel_var = _1stShadingGradeMap_var < 0.95 ? _1stShadingGradeMap_var + _Tweak_1stShadingGradeMapLevel : 1;
    float _2ndShadingGradeMapLevel_var = _2ndShadingGradeMap_var < 0.95 ? _2ndShadingGradeMap_var + _Tweak_2ndShadingGradeMapLevel : 1;

    //Minmimum value is same as the Minimum Feather's value with the Minimum Step's value as threshold.
    float _SystemShadowsLevel_var =   (attenuation * 0.5) + 0.5 + _Tweak_SystemShadowsLevel > 0.001 ?
                                        (attenuation * 0.5) + 0.5 + _Tweak_SystemShadowsLevel
                                        : 0.0001;

    float Set_FinalShadowMask = saturate((1.0 + ( saturate(_1stShadingGradeMapLevel_var)
                                                   * (lerp( _HalfLambert_var,
                                                            _HalfLambert_var * saturate(_SystemShadowsLevel_var),
                                                            _Set_SystemShadowsToBase
                                                            )
                                                     - (_BaseColorStep_Feather_Sub))
                                                   * ((1.0 - _2nd_ShadeMap_var.a) - 1.0)
                                                )
                                                / (_BaseColor_Step - (_BaseColorStep_Feather_Sub))));

    float Set_1st2ndShadowMask = saturate((1.0 + ( ( (saturate(_2ndShadingGradeMapLevel_var) * _HalfLambert_var)
                                                    - (_1stShadeColorStep_Feather_Sub) )
                                                    * ((1.0 - _1st_ShadeMap_var.a) - 1.0)
                                                  )
                                                / (_ShadeColor_Step - (_1stShadeColorStep_Feather_Sub))));


    #ifdef _DEBUG_1ST_SHADEMASK
        return half4(Set_FinalShadowMask, Set_FinalShadowMask, Set_FinalShadowMask, 1);
    #endif

    #ifdef _DEBUG_2ND_SHADEMASK
        return half4(Set_1st2ndShadowMask, Set_1st2ndShadowMask, Set_1st2ndShadowMask, 1);
    #endif

    #ifdef _DEBUG_ORIGINAL_NORMAL
        return half4(normalDir, 1);
    #endif

    #ifdef _DEBUG_MAPPED_NORMAL
        return half4(normalDirection, 1);
    #endif

    float3 Set_FinalBaseColor = lerp( Set_BaseColor,
                                      lerp( Set_1st_ShadeColor, Set_2nd_ShadeColor, Set_1st2ndShadowMask),
                                      Set_FinalShadowMask);

    //_HighColorMap_var.a : HighColor Mask
    float4 _HighColorMap_var = tex2D(_HighColorMap, TRANSFORM_TEX(Set_UV0, _HighColorMap));
    float4 _HighColorMap_2nd_var = tex2D(_HighColorMap, TRANSFORM_TEX(Set_UV1, _HighColorMap));
    float _HighColorMask = _Use_2ndUV_As_HighColorMapMask ? _HighColorMap_2nd_var.a : _HighColorMap_var.a;

#ifdef _DEBUG_HIGHCOLOR_UVSET
    return _Use_2ndUV_As_HighColorMapMask ? float4(Set_UV1.x, Set_UV1.y, 0, 1) : float4(Set_UV0.x, Set_UV0.y, 0, 1);
#endif

    float _Specular_var = 0.5 * dot(halfDirection, lerp( normalDir, normalDirection, _Is_NormalMapToHighColor )) + 0.5;
    _Specular_var = saturate( _Specular_var + (1 -_HighColorMask) * _HighColorMapMaskScaler - _HighColorMapMaskOffset);

    float _TweakHighColorMask_var = saturate(_HighColorMask + _Tweak_HighColorMaskLevel)
                                     * lerp( (1.0 - step(_Specular_var, (1.0 -  pow(_HighColor_Power + _HighColorMask, 5)))),
                                              pow(_Specular_var, exp2(lerp(11, 1, _HighColor_Power + _HighColorMask))),
                                             _Is_SpecularToHighColor);

    //TODO: add pass 対応
    float3 binormalObj = normalize(i.tangentToWorldAndPackedData[1].xyz);
    float anisoLow = StrandSpecular(binormalObj, viewDirection, lightDirection, _AnisotropicHighLightPowerLow, _AnisotropicHighLightStrengthLow);
    float3 shiftedT = ShiftTangent(binormalObj, lerp( normalDir, normalDirection, _Is_NormalMapToBase ), _HighColorMask + _ShiftTangent);
    float anisoHigh = StrandSpecular(shiftedT, viewDirection, lightDirection, _AnisotropicHighLightPowerHigh, _AnisotropicHighLightStrengthHigh);
    float anisoMask =  saturate(saturate(anisoLow) + saturate(anisoHigh));

    _TweakHighColorMask_var = _Use_Aniso_HighLight ? anisoMask : _TweakHighColorMask_var;

    #ifdef _DEBUG_HIGH_COLOR_MASK
        return half4(_TweakHighColorMask_var, _TweakHighColorMask_var, _TweakHighColorMask_var, 1);
    #endif

    float3 _HighColor_var = lerp( (_HighColorMap_var.rgb*_HighColor.rgb),
                                  (_HighColorMap_var.rgb*_HighColor.rgb) * Set_LightColor,
                                   _Is_LightColor_HighColor )
                                * _TweakHighColorMask_var;

    float3 Set_HighColor = lerp( saturate((Set_FinalBaseColor - _TweakHighColorMask_var)),
                                 Set_FinalBaseColor,
                                 lerp(_Is_BlendAddToHiColor, 1.0, _Is_SpecularToHighColor)
                               )
                          + lerp( _HighColor_var,
                                  _HighColor_var * ((1.0 - Set_FinalShadowMask) + (Set_FinalShadowMask * _TweakHighColorOnShadow)),
                                  _Is_UseTweakHighColorOnShadow );

    float3 _Is_LightColor_RimLight_var = lerp( _RimLightColor.rgb,
                                               _RimLightColor.rgb * Set_LightColor,
                                               _Is_LightColor_RimLight );

    float _RimArea_var = (1.0 - dot (lerp(normalDir, normalDirection, _Is_NormalMapToRimLight ), viewDirection));

    float _RimLightPower_var = pow(_RimArea_var, exp2( lerp(3, 0, _RimLight_Power)));

    float _Rimlight_InsideMask_var = saturate(lerp( (_RimLightPower_var - _RimLight_InsideMask) / (1.0 - _RimLight_InsideMask),
                                                    step(_RimLight_InsideMask, _RimLightPower_var),
                                                    _RimLight_FeatherOff
                                                   ));

    float _VertHalfLambert_var = 0.5 * dot(normalDir, lightDirection) + 0.5;

    float3 _LightDirection_MaskOn_var = lerp( _Is_LightColor_RimLight_var * _Rimlight_InsideMask_var,
                                             (_Is_LightColor_RimLight_var
                                                * saturate((_Rimlight_InsideMask_var
                                                                - ((1.0 - _VertHalfLambert_var) + _Tweak_LightDirection_MaskLevel))
                                                           )),
                                             _LightDirection_MaskOn);

    float _ApRimLightPower_var = pow(_RimArea_var,exp2(lerp(3,0,_Ap_RimLight_Power)));

    float3 Set_RimLight = saturate(_CombinedMask_var.r + _Tweak_RimLightMaskLevel)
                                  * lerp( _LightDirection_MaskOn_var,
                                         (_LightDirection_MaskOn_var + (lerp( _Ap_RimLightColor.rgb,
                                                                              _Ap_RimLightColor.rgb * Set_LightColor,
                                                                              _Is_LightColor_Ap_RimLight)
                                                                        * saturate((lerp( ( _ApRimLightPower_var - _RimLight_InsideMask ) / (1.0 - _RimLight_InsideMask),
                                                                                          step(_RimLight_InsideMask,_ApRimLightPower_var),
                                                                                          _Ap_RimLight_FeatherOff)
                                                                                    - (saturate(_VertHalfLambert_var) +_Tweak_LightDirection_MaskLevel))
                                                                                   )
                                    )),
                                     _Add_Antipodean_RimLight ) * i.posWorld.w;

#ifdef _DEBUG_RIM_LIGHT
    return float4(Set_RimLight, 1);
#endif

    float3 finalColor = lerp( Set_HighColor, (Set_HighColor + Set_RimLight), _RimLight );

    float3 envLightColor = DecodeLightProbe(normalDirection) < float3(1,1,1)
                         ? DecodeLightProbe(normalDirection) : float3(1,1,1);

    float envLightIntensity =      0.299 * envLightColor.r + 0.587 * envLightColor.g + 0.114 * envLightColor.b  < 1
                                ? (0.299 * envLightColor.r + 0.587 * envLightColor.g + 0.114 * envLightColor.b) : 1;


    float4 _EmissionMap_var = tex2D(_EmissionMap, TRANSFORM_TEX(Set_UV0, _EmissionMap));
    emissive = _EmissionMap_var.rgb * _Emissive_Color.rgb * _EmissionMap_var.a;

#ifdef _DEBUG_EMISSIVE
    return float4(emissive, 1);
#endif

    //Final Composition
    finalColor =  saturate(finalColor)
                + (envLightColor * envLightIntensity * _GI_Intensity * smoothstep(1, 0, envLightIntensity / 2))
                + emissive;

#elif _IS_PASS_FWDDELTA

    float _LightIntensity = lerp(0, GetLightIntensity(_LightColor0) * attenuation, _WorldSpaceLightPos0.w);

    //Filtering the high intensity zone of PointLights
    float3 Set_LightColor = lerp(lightColor,
                                lerp(lightColor, min(lightColor, _LightColor0.rgb * attenuation * _BaseColor_Step),_WorldSpaceLightPos0.w),
                                _Is_Filter_HiCutPointLightColor);

    float3 Set_BaseColor = (_BaseColor.rgb * _MainTex_var.rgb) * Set_LightColor;

    float4 _1st_ShadeMap_var = lerp(tex2D(_1st_ShadeMap, TRANSFORM_TEX(Set_UV0, _1st_ShadeMap)), _MainTex_var, _Use_BaseAs1st);
    float3 Set_1st_ShadeColor = (_1st_ShadeColor.rgb * _1st_ShadeMap_var.rgb) * Set_LightColor;

    float4 _2nd_ShadeMap_var = lerp(tex2D(_2nd_ShadeMap,TRANSFORM_TEX(Set_UV0, _2nd_ShadeMap)),_1st_ShadeMap_var,_Use_1stAs2nd);
    float3 Set_2nd_ShadeColor = (_2nd_ShadeColor.rgb * _2nd_ShadeMap_var.rgb) * Set_LightColor;

    float Set_FinalShadowMask = saturate((1.0 + ( (lerp( _HalfLambert_var,
                                                        (_HalfLambert_var * saturate(1.0+_Tweak_SystemShadowsLevel)),
                                                        _Set_SystemShadowsToBase )
                                                   - (_BaseColorStep_Feather_Sub)) * ((1.0 - _1st_ShadeMap_var.a) - 1.0) )
                                                   / (_BaseColor_Step - (_BaseColorStep_Feather_Sub)))
                                        );

    float Set_1st2ndShadowMask = saturate((1.0 + ( (_HalfLambert_var - (_1stShadeColorStep_Feather_Sub))
                                                     * ((1.0 - _2nd_ShadeMap_var.a) - 1.0) )
                                                     / (_ShadeColor_Step - (_1stShadeColorStep_Feather_Sub))));

    //Composition: 3 Basic Colors as finalColor
    float3 finalColor = lerp(Set_BaseColor,
                             lerp(Set_1st_ShadeColor,
                                  Set_2nd_ShadeColor,
                                  Set_1st2ndShadowMask),
                             Set_FinalShadowMask);

    //Add HighColor if _Is_Filter_HiCutPointLightColor is False
    float4 _HighColorMap_var = tex2D(_HighColorMap, TRANSFORM_TEX(Set_UV0, _HighColorMap));
    float4 _HighColorMap_2nd_var = tex2D(_HighColorMap, TRANSFORM_TEX(Set_UV1, _HighColorMap));
    float _HighColorMask = _Use_2ndUV_As_HighColorMapMask ? _HighColorMap_2nd_var.a : _HighColorMap_var.a;

    float _Specular_var = 0.5 * dot(halfDirection, lerp( normalDir, normalDirection, _Is_NormalMapToHighColor )) + 0.5;

    //_HighColorMap_var.a : HighColor Mask
    float _TweakHighColorMask_var = saturate(_HighColorMask + _Tweak_HighColorMaskLevel)
                                              * lerp( (1.0 - step(_Specular_var, (1.0 - pow(_HighColor_Power + _HighColorMask, 5)))),
                                                      pow(_Specular_var, exp2(lerp(11, 1, _HighColor_Power + _HighColorMask))),
                                                      _Is_SpecularToHighColor );

    float3 _HighColor_var = (lerp( (_HighColorMap_var.rgb * _HighColor.rgb),
                                  ((_HighColorMap_var.rgb * _HighColor.rgb) * Set_LightColor), _Is_LightColor_HighColor )
                                  * _TweakHighColorMask_var);

    finalColor = finalColor + lerp(lerp( _HighColor_var,
                                        (_HighColor_var * ((1.0 - Set_FinalShadowMask)
                                         +(Set_FinalShadowMask * _TweakHighColorOnShadow))),
                                         _Is_UseTweakHighColorOnShadow ),
                                    float3(0,0,0),
                                    _Is_Filter_HiCutPointLightColor);

    finalColor = saturate(finalColor);

#endif


#ifdef _IS_PASS_FWDBASE

    float viewLightHalfL = dot(-UNITY_MATRIX_V[2].xyz, _WorldSpaceLightPos0.xyz) * 0.5 + 0.5;
    float sssMask = _SSSAlphaInverse ? (1 - _CombinedMask_var.b) : _CombinedMask_var.b;
    float sssWeight = sssMask * easeInExpo(viewLightHalfL);
    _HSVOffset.x = _HSVOffset.x  * rcp(360);
    float3 shiftedColor = shiftColor( _Is_Skin ? (finalColor.rgb * _SkinSSSMulColor.rgb) : finalColor.rgb, _HSVOffset.xyz, sssWeight);

    #ifdef _DEBUG_SSS_SHIFTED_W_MASK
    float shadow = sssMask;
    sssMask = saturate( sssMask * shadow);
    return half4(shadow, shadow, shadow, 1);

    #elif _DEBUG_SSS_SHIFTED
        return half4(shiftedColor.xyz, 1);
    #endif

    // float2 grabUV = float2(i.grabPos.x / i.grabPos.w, i.grabPos.y / i.grabPos.w);
    // float4 grabMap = tex2D(_GrabPassTexture, grabUV);
    // finalColor = lerp(finalColor, shiftedColor * lerp(1, grabMap.rgb, _FakeTransparentWeight), sssWeight);
    finalColor = lerp(finalColor, shiftedColor, sssWeight);
#endif

#ifdef _ALPHAPREMULTIPLY_ON
    float Set_Opacity = saturate((baseMapAlpha + _Tweak_transparency));

    #ifdef _IS_PASS_FWDBASE
        fixed4 finalRGBA = fixed4(finalColor, Set_Opacity);
    #elif _IS_PASS_FWDDELTA
        fixed4 finalRGBA = fixed4(finalColor * Set_Opacity,0);
    #endif

#else
    #ifdef _IS_PASS_FWDBASE
        fixed4 finalRGBA = fixed4(finalColor,1);
    #elif _IS_PASS_FWDDELTA
        fixed4 finalRGBA = fixed4(finalColor,0);
    #endif

#endif


    half3 eyeVec = normalize(i.posWorld.xyz - _WorldSpaceCameraPos);
    FragmentCommonData s = FragmentSetup(i.uv0, finalColor, eyeVec, i.tangentToWorldAndPackedData, i.posWorld);

    fixed4 c = 0;
    #ifdef _IS_PASS_FWDBASE
        UnityLight mainLight = MainLight ();
        UnityGI gi = FragmentGI (s, 1, i.ambientOrLightmapUV, attenuation, mainLight);
        c = UNITY_BRDF_PBS (s.diffColor, s.specColor, s.oneMinusReflectivity, s.smoothness, s.normalWorld, -s.eyeVec, gi.light, gi.indirect);

        half grazingTerm = saturate(s.smoothness + (1 - s.oneMinusReflectivity));
        half nv = saturate(dot(normalDirection, viewDirection));
        half fresnelTerm = 1 - nv;
        half3 indirect = BRDF3_Indirect(s.diffColor, s.specColor, gi.indirect, grazingTerm, fresnelTerm);
        finalRGBA += _IBLWeight * half4(indirect, 1);
    #endif

    #ifdef _IS_PASS_FWDDELTA
        float3 lightDir = _WorldSpaceLightPos0.xyz - i.posWorld.xyz * _WorldSpaceLightPos0.w;
        UnityLight light = AdditiveLight (lightDir, attenuation);
        UnityIndirect noIndirect = ZeroIndirect ();
        c = UNITY_BRDF_PBS (s.diffColor, s.specColor, s.oneMinusReflectivity, s.smoothness, s.normalWorld, -s.eyeVec, light, noIndirect);
    #endif

    #ifdef _DEBUG_STANDARD
        return c;
    #endif

    return lerp(finalRGBA, OutputForward (c, finalRGBA.a), _StandardBlendWeight * _CombinedMask_var.a);
}

#endif