//Unitychan Toon Shader ver.2.0
//v.2.0.7.5
//nobuyuki@unity3d.com
//https://github.com/unity3d-jp/UnityChanToonShaderVer2_Project
//(C)Unity Technologies Japan/UCL

//_ALPHAPREMULTIPLY_ON : Transparent
//_ALPHATEST_ON : Cutout
Shader "Hidden/YMToon/Base/Front" {
    Properties {
        [Enum(OFF,0,FRONT,1,BACK,2)] _CullMode("Cull Mode", int) = 2  //OFF/FRONT/BACK

        [Toggle(_)] _Inverse_Clipping ("Inverse_Clipping", Float ) = 0
        _Clipping_Level ("Clipping_Level", Range(0, 1)) = 0
        _Tweak_transparency ("Tweak_transparency", Range(-1, 1)) = 0

        _MainTex ("BaseMap", 2D) = "white" {}
        _BaseColor ("BaseColor", Color) = (1,1,1,1)

        [Toggle(_)] _Is_LightColor_Base ("Is_LightColor_Base", Float ) = 1
        _1st_ShadeMap ("1st_ShadeMap", 2D) = "white" {}
        [Toggle(_)] _Use_BaseAs1st ("Use BaseMap as 1st_ShadeMap", Float ) = 0
        _1st_ShadeColor ("1st_ShadeColor", Color) = (1,1,1,1)
        [Toggle(_)]_Use_1stShadeMapAlpha_As_ShadowMask("Use 1stShadeMapAlpha As ShadowMask", Float ) = 0
        [Toggle(_)]_1stShadeMapMask_Inverse("_1stShadeMapMask_Inverse", Float ) = 0
        _Tweak_1stShadingGradeMapLevel("_Tweak_1stShadingGradeMapLevel", Range(-0.5, 0.5) ) = 0

        _2nd_ShadeMap ("2nd_ShadeMap", 2D) = "white" {}
        [Toggle(_)] _Use_1stAs2nd ("Use 1st_ShadeMap as 2nd_ShadeMap", Float ) = 0
        _2nd_ShadeColor ("2nd_ShadeColor", Color) = (1,1,1,1)
        [Toggle(_)]_Use_2ndShadeMapAlpha_As_ShadowMask("Use 2ndShadeMapAlpha As ShadowMask", Float ) = 0
        [Toggle(_)]_2ndShadeMapMask_Inverse("_2ndShadeMapMask_Inverse", Float ) = 0
        _Tweak_2ndShadingGradeMapLevel("_Tweak_2ndShadingGradeMapLevel", Range(-0.5, 0.5) ) = 0

        _CombinedMask ("Combined Mask", 2D) = "white" {}

        [Normal] _BumpMap("Normal Map", 2D) = "bump" {}
        _BumpScale ("Normal Scale", Range(0, 1)) = 1

        [Toggle(_)] _Is_NormalMapToBase ("Is_NormalMapToBase", Float ) = 0
        [Toggle(_)] _Set_SystemShadowsToBase ("Set_SystemShadowsToBase", Float ) = 1

        _Tweak_SystemShadowsLevel ("Tweak_SystemShadowsLevel", Range(-0.5, 0.5)) = 0

        _BaseColor_Step ("BaseColor_Step", Range(0.01, 1)) = 0.5
        _BaseShade_Feather ("Base/Shade_Feather", Range(0.0001, 1)) = 0.0001
        _ShadeColor_Step ("ShadeColor_Step", Range(0.01, 1)) = 0
        _1st2nd_Shades_Feather ("1st/2nd_Shades_Feather", Range(0.0001, 1)) = 0.0001

        [Toggle(_)] _Is_Filter_HiCutPointLightColor ("PointLights HiCut_Filter (ForwardAdd Only)", Float ) = 1

//v.2.0.4 HighColorMap
        _HighColor ("HighColor", Color) = (0,0,0,1)
        _HighColorMap ("HighColor Map", 2D) = "white" {}
        [Toggle(_)] _Use_2ndUV_As_HighColorMapMask("Use 2nd UV As HighColorMap Mask", Float) = 1

        [Toggle(_)] _Is_LightColor_HighColor ("Is_LightColor_HighColor", Float ) = 1
        [Toggle(_)] _Is_NormalMapToHighColor ("Is_NormalMapToHighColor", Float ) = 0
        _HighColor_Power ("HighColor_Power", Range(-2, 2)) = -1
        [Toggle(_)] _Is_SpecularToHighColor ("Is_SpecularToHighColor", Float ) = 0
        [Toggle(_)] _Is_BlendAddToHiColor ("Is_BlendAddToHiColor", Float ) = 0
        [Toggle(_)] _Is_UseTweakHighColorOnShadow ("Is_UseTweakHighColorOnShadow", Float ) = 0
        _TweakHighColorOnShadow ("TweakHighColorOnShadow", Range(0, 1)) = 0
        _Tweak_HighColorMaskLevel ("Tweak_HighColorMaskLevel", Range(-1, 1)) = 0

        _HighColorMapMaskScaler ("HighColorMapMask Scaler", Range(-0.5, 0.5)) = 0
        _HighColorMapMaskOffset ("HighColorMapMask Offset", Range(-0.5, 0.5)) = 0

//Rim Light
        [Toggle(_)] _RimLight ("RimLight", Float ) = 0
        _RimLightColor ("RimLightColor", Color) = (1,1,1,1)
        [Toggle(_)] _Is_LightColor_RimLight ("Is_LightColor_RimLight", Float ) = 1
        [Toggle(_)] _Is_NormalMapToRimLight ("Is_NormalMapToRimLight", Float ) = 0
        _RimLight_Power ("RimLight_Power", Range(0, 1)) = 0.1
        _RimLight_InsideMask ("RimLight_InsideMask", Range(0.0001, 1)) = 0.0001
        [Toggle(_)] _RimLight_FeatherOff ("RimLight_FeatherOff", Float ) = 0
        [Toggle(_)] _LightDirection_MaskOn ("LightDirection_MaskOn", Float ) = 0
        _Tweak_LightDirection_MaskLevel ("Tweak_LightDirection_MaskLevel", Range(0, 0.5)) = 0
        [Toggle(_)] _Add_Antipodean_RimLight ("Add_Antipodean_RimLight", Float ) = 0
        _Ap_RimLightColor ("Ap_RimLightColor", Color) = (1,1,1,1)
        [Toggle(_)] _Is_LightColor_Ap_RimLight ("Is_LightColor_Ap_RimLight", Float ) = 1
        _Ap_RimLight_Power ("Ap_RimLight_Power", Range(0, 1)) = 0.1
        [Toggle(_)] _Ap_RimLight_FeatherOff ("Ap_RimLight_FeatherOff", Float ) = 0
        _Tweak_RimLightMaskLevel ("Tweak_RimLightMaskLevel", Range(-1, 1)) = 0

//Emissive
        [KeywordEnum(SIMPLE,ANIMATION)] _EMISSIVE("EMISSIVE MODE", Float) = 0
        _EmissionMap("Emission Map", 2D) = "white" {}
        [HDR]_Emissive_Color("Emissive Color", Color) = (0,0,0,1)

        _Base_Speed ("Base_Speed", Float ) = 0
        _Scroll_EmissiveU ("Scroll_EmissiveU", Range(-1, 1)) = 0
        _Scroll_EmissiveV ("Scroll_EmissiveV", Range(-1, 1)) = 0
        _Rotate_EmissiveUV ("Rotate_EmissiveUV", Float ) = 0
        [Toggle(_)] _Is_PingPong_Base ("Is_PingPong_Base", Float ) = 0
        [Toggle(_)] _Is_ColorShift ("Activate ColorShift", Float ) = 0
        [HDR]_ColorShift ("ColorSift", Color) = (0,0,0,1)
        _ColorShift_Speed ("ColorShift_Speed", Float ) = 0
        [Toggle(_)] _Is_ViewShift ("Activate ViewShift", Float ) = 0
        [HDR]_ViewShift ("ViewSift", Color) = (0,0,0,1)
        [Toggle(_)] _Is_ViewCoord_Scroll ("Is_ViewCoord_Scroll", Float ) = 0

//Outline
        [KeywordEnum(NML,POS)] _OUTLINE("OUTLINE MODE", Float) = 0
        _Outline_Width ("Outline_Width", Float ) = 0
        _Farthest_Distance ("Farthest_Distance", Float ) = 100
        _Nearest_Distance ("Nearest_Distance", Float ) = 0.5
        _Outline_Color ("Outline_Color", Color) = (0.5,0.5,0.5,1)
        [Toggle(_)] _Is_BlendBaseColor ("Is_BlendBaseColor", Float ) = 0
        _Is_BlendBaseColorWeight ("Is_BlendBaseColorWeight", Range(0,1)) = 1
        [Toggle(_)] _Is_LightColor_Outline ("Is_LightColor_Outline", Float ) = 1
        [Toggle(_)] _Is_OutlineMap ("_Is_OutlineMap", Float ) = 0
        _OutlineMap ("Outline Map", 2D) = "white" {}
        //Offset parameter
        _Offset_Z ("Offset_Camera_Z", Float) = 0
        //v.2.0.4.3 Baked Nrmal Texture for Outline
        [Toggle(_)] _Is_BakedNormal ("Is_BakedNormal", Float ) = 0
        _BakedNormal ("Baked Normal for Outline", 2D) = "white" {}
        //GI Intensity
        _GI_Intensity ("GI_Intensity", Range(0, 1)) = 0
        //For VR Chat under No effective light objects
        _Unlit_Intensity ("Unlit_Intensity", Range(0.001, 4)) = 1
        [Toggle(_)] _Is_Filter_LightColor ("VRChat : SceneLights HiCut_Filter", Float ) = 0

//other
        _Glossiness("Smoothness", Range(0.0, 1.0)) = 0.5
        _GlossMapScale("Smoothness Scale", Range(0.0, 1.0)) = 1.0
        [Enum(Metallic Alpha,0,Albedo Alpha,1)] _SmoothnessTextureChannel ("Smoothness texture channel", Float) = 0

        [Gamma] _Metallic("Metallic", Range(0.0, 1.0)) = 0.0
        _MetallicGlossMap("Metallic Map", 2D) = "white" {}

        [ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
        [ToggleOff] _GlossyReflections("Glossy Reflections", Float) = 1.0

        [Toggle(_)] _SSSAlphaInverse("_SSSAlphaInverse", float) = 0
        _HSVOffset ("HSV Offset", Vector) = (0,1,1,0)
        [Toggle(_)] _Is_Skin("Is Skin", float) = 0
        _SkinSSSMulColor ("Skin SSS MulColor", Color) = (0.7,0,0,1)
        _FakeTransparentWeight("FakeTransparent Weight", Range(0, 1)) = 0.5

        _IBLWeight("IBL BlendWeight", Range(0,1)) = 0
        _StandardBlendWeight("Standard BlendWeight", Range(0,1)) = 0

        [Toggle(_)] _Use_OwnDirLight("Is OwnDirLight", float) = 0
        _OwnDirectionalLightDir ("Own Directional Light Dir", Vector) = (0,0,0,0)
        _OwnDirectionalLightColor ("Own Directional Light Color", Color) = (1,1,1,1)

        // Blending state
        [HideInInspector] _Mode ("_Mode", Float) = 0.0
        [HideInInspector] _SrcBlend ("_SrcBlend", Float) = 1.0
        [HideInInspector] _DstBlend ("_DstBlend", Float) = 0.0
        [HideInInspector] _PreZWrite ("_PreZWrite", Float) = 0.0
        [HideInInspector] _ZWrite ("_ZWrite", Float) = 1.0

        [Toggle(_)] _Use_Aniso_HighLight("Use Aniso HighLight", float) = 0
        _AnisotropicHighLightPowerLow("spec power low", float) = 1
        _AnisotropicHighLightStrengthLow("Spec strength low", float) = 0
        _AnisotropicHighLightPowerHigh("spec power high", float) = 1
        _AnisotropicHighLightStrengthHigh("Spec strength high", float) = 0
        _ShiftTangent("Shift Tangent", float) = 0

        [HideInInspector] _EulerAnglesCache ("_EulerAnglesCache", Vector) = (150,30,0,0)
        [HideInInspector] _LightIntensityCache ("_LightIntensityCache", Float) = 1.0
        [HideInInspector] _LightColorChache ("_LightColorChache", Color) = (1,1,1,1)

    }

    CGINCLUDE
        #define UNITY_SETUP_BRDF_INPUT MetallicSetup
    ENDCG

    SubShader {
        Tags {
            "RenderType"="Opaque"
        }

        UsePass "YMToon/Base/Outline"
        UsePass "YMToon/Base/ForTransparentZWrite"

        Pass {
            Name "FORWARD_FRONT"
            Tags {
                "LightMode" = "Always"
            }

            Cull Front
            Blend [_SrcBlend] [_DstBlend]
            ZWrite [_ZWrite]

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"

            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_instancing

            #pragma target 3.0

            #pragma multi_compile _IS_PASS_FWDBASE
            #pragma shader_feature _EMISSIVE_ANIMATION
            #pragma shader_feature _METALLICGLOSSMAP
            #pragma shader_feature _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            #pragma shader_feature _ _ALPHAPREMULTIPLY_ON _ALPHATEST_ON
            #pragma shader_feature _SPECULARHIGHLIGHTS_OFF
            #pragma shader_feature _GLOSSYREFLECTIONS_OFF

            #pragma shader_feature _DEBUG_BASE_COLOR_ONLY
            #pragma shader_feature _DEBUG_BASE_MAP_ALPHA
            #pragma shader_feature _DEBUG_1ST_SHADEMASK
            #pragma shader_feature _DEBUG_2ND_SHADEMASK
            #pragma shader_feature _DEBUG_ORIGINAL_NORMAL
            #pragma shader_feature _DEBUG_MAPPED_NORMAL
            #pragma shader_feature _DEBUG_1ST_SHADING_GRADEMASK
            #pragma shader_feature _DEBUG_2ND_SHADING_GRADEMASK
            #pragma shader_feature _DEBUG_HIGHCOLOR_UVSET
            #pragma shader_feature _DEBUG_HIGH_COLOR_MASK
            #pragma shader_feature _DEBUG_RIM_LIGHT
            #pragma shader_feature _DEBUG_EMISSIVE
            #pragma shader_feature _DEBUG_SSS_SHIFTED
            #pragma shader_feature _DEBUG_SSS_SHIFTED_W_MASK
            #pragma shader_feature _DEBUG_STANDARD

            #include "YMT_ForwardFrontBase.cginc"

            ENDCG
        }

        UsePass "YMToon/Base/FORWARD_DELTA"
        UsePass "YMToon/Base/ShadowCaster"
        //UsePass "YMToon/Base/META"

//ToonCoreEnd
    }
    CustomEditor "YoyogiMori.YMToon2GUI"
}
