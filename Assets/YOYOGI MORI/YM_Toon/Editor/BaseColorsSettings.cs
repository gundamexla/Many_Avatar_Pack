using UnityEditor;
using UnityEngine;
using static YoyogiMori.YMT_GUILayout;
using static YoyogiMori.YMT_SetParamUtils;

namespace YoyogiMori
{

    public class BaseColorSettings : YMT_FeatureBase
    {

        private static bool _BasicThreeColors_Foldout = true;
        private static bool _NormalMap_Foldout = true;

        private static MaterialProperty _MainTex = null;
        private static MaterialProperty _BaseColor = null;
        private static MaterialProperty _1st_ShadeMap = null;
        private static MaterialProperty _1st_ShadeColor = null;
        private static MaterialProperty _2nd_ShadeMap = null;
        private static MaterialProperty _2nd_ShadeColor = null;
        private static MaterialProperty _CombinedMask = null;

        private static MaterialProperty _Use_1stShadeMapAlpha_As_ShadowMask = null;
        private static MaterialProperty _1stShadeMapMask_Inverse = null;
        private static MaterialProperty _Tweak_1stShadingGradeMapLevel = null;

        private static MaterialProperty _Use_2ndShadeMapAlpha_As_ShadowMask = null;
        private static MaterialProperty _2ndShadeMapMask_Inverse = null;
        private static MaterialProperty _Tweak_2ndShadingGradeMapLevel = null;

        private static string _DEBUG_1ST_SHADEMASK => "_DEBUG_1ST_SHADEMASK";
        private static string _DEBUG_2ND_SHADEMASK => "_DEBUG_2ND_SHADEMASK";
        private static string _DEBUG_1ST_SHADING_GRADEMASK => "_DEBUG_1ST_SHADING_GRADEMASK";
        private static string _DEBUG_2ND_SHADING_GRADEMASK => "_DEBUG_2ND_SHADING_GRADEMASK";
        private static string _DEBUG_BASE_COLOR_ONLY => "_DEBUG_BASE_COLOR_ONLY";
        private static string _DEBUG_BASE_MAP_ALPHA => "_DEBUG_BASE_MAP_ALPHA";

        new protected static void FindProps(YMToon2GUI ymtoon)
        {
            ymtoon.FindProp(ref _MainTex, "_MainTex");
            ymtoon.FindProp(ref _BaseColor, "_BaseColor");

            ymtoon.FindProp(ref _1st_ShadeMap, "_1st_ShadeMap");
            ymtoon.FindProp(ref _1st_ShadeColor, "_1st_ShadeColor");
            ymtoon.FindProp(ref _2nd_ShadeMap, "_2nd_ShadeMap");
            ymtoon.FindProp(ref _2nd_ShadeColor, "_2nd_ShadeColor");

            ymtoon.FindProp(ref _CombinedMask, "_CombinedMask");

            ymtoon.FindProp(ref _Use_1stShadeMapAlpha_As_ShadowMask, "_Use_1stShadeMapAlpha_As_ShadowMask");
            ymtoon.FindProp(ref _1stShadeMapMask_Inverse, "_1stShadeMapMask_Inverse");
            ymtoon.FindProp(ref _Tweak_1stShadingGradeMapLevel, "_Tweak_1stShadingGradeMapLevel");

            ymtoon.FindProp(ref _Use_2ndShadeMapAlpha_As_ShadowMask, "_Use_2ndShadeMapAlpha_As_ShadowMask");
            ymtoon.FindProp(ref _2ndShadeMapMask_Inverse, "_2ndShadeMapMask_Inverse");
            ymtoon.FindProp(ref _Tweak_2ndShadingGradeMapLevel, "_Tweak_2ndShadingGradeMapLevel");
        }

        new public static void Draw(YMToon2GUI ymtoon, MaterialEditor materialEditor)
        {
            FindProps(ymtoon);
            m_MaterialEditor = materialEditor;
            var material = m_MaterialEditor.target as Material;

            DrawFoldOutMenu(ref _BasicThreeColors_Foldout, "【Basic Three Colors and Control Maps Setups】",
                () =>
                {
                    GUI_BasicThreeColors(material);
                    DebugDraw(material);
                }
            );

            EditorGUILayout.Space();
        }

        private static void GUI_BasicThreeColors(Material material)
        {
            GUILayout.Label("3 Basic Colors Settings : Textures × Colors", EditorStyles.boldLabel);

            EditorGUILayout.BeginHorizontal();
            m_MaterialEditor.TexturePropertySingleLine(Styles.baseColorText, _MainTex, _BaseColor);

            DrawToggleButton(material, "", "_Use_BaseAs1st", "No Sharing", "With 1st ShadeMap");
            GUILayout.Space(60);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            m_MaterialEditor.TexturePropertySingleLine(Styles.firstShadeColorText, _1st_ShadeMap, _1st_ShadeColor);
            DrawToggleButton(material, "", "_Use_1stAs2nd", "No Sharing", "With 2nd ShadeMap");
            GUILayout.Space(60);
            EditorGUILayout.EndHorizontal();

            m_MaterialEditor.TexturePropertySingleLine(Styles.secondShadeColorText, _2nd_ShadeMap, _2nd_ShadeColor);
            m_MaterialEditor.TexturePropertySingleLine(Styles.combinedMaskText, _CombinedMask);

            GUILayout.Label("Shading Grade Map", EditorStyles.boldLabel);

            var use1stShadingMask = DrawToggleButton(material, "Use As 1stShadeMap.a", "_Use_1stShadeMapAlpha_As_ShadowMask");

            if (use1stShadingMask)
            {
                DrawContentWithIndent(() =>
                {

                    EditorGUILayout.Space();

                    DrawToggleButton(material, "1st ShadeMap Mask Inverse", "_1stShadeMapMask_Inverse");

                    m_MaterialEditor.ShaderProperty(_Tweak_1stShadingGradeMapLevel, "Tweak 1stShadingGradeMapLevel");

                    EditorGUILayout.Space();
                });
            }

            var use2ndShadingMask = DrawToggleButton(material, "Use As 2ndShadeMap.a", "_Use_2ndShadeMapAlpha_As_ShadowMask");

            if (use2ndShadingMask)
            {
                DrawContentWithIndent(() =>
                {
                    EditorGUILayout.Space();

                    DrawToggleButton(material, "2nd ShadeMap Mask Inverse", "_2ndShadeMapMask_Inverse");

                    m_MaterialEditor.ShaderProperty(_Tweak_2ndShadingGradeMapLevel, "Tweak 2ndShadingGradeMapLevel");

                    EditorGUILayout.Space();
                });
            }

            EditorGUILayout.Space();

        }

        new protected static void DebugDraw(Material material)
        {
            GUILayout.Label("Debug", EditorStyles.boldLabel);
            DrawContentWithIndent(() =>
            {
                DrawKeywordToggle(material, "Debug Base Color Only", _DEBUG_BASE_COLOR_ONLY);
                DrawKeywordToggle(material, "Debug Base Map Alpha", _DEBUG_BASE_MAP_ALPHA);

                DrawKeywordToggle(material, "Debug 1st Shading GradeMask", _DEBUG_1ST_SHADING_GRADEMASK);
                DrawKeywordToggle(material, "Debug 1st Shade Mask", _DEBUG_1ST_SHADEMASK);

                DrawKeywordToggle(material, "Debug 2nd Shading GradeMask", _DEBUG_2ND_SHADING_GRADEMASK);
                DrawKeywordToggle(material, "Debug 2nd Shade Mask", _DEBUG_2ND_SHADEMASK);

            });
        }

        new public static void DisableAllDebugDraw(Material material)
        {
            SetKeyword(material, _DEBUG_BASE_COLOR_ONLY, false);
            SetKeyword(material, _DEBUG_BASE_MAP_ALPHA, false);
            SetKeyword(material, _DEBUG_1ST_SHADEMASK, false);
            SetKeyword(material, _DEBUG_2ND_SHADEMASK, false);
            SetKeyword(material, _DEBUG_1ST_SHADING_GRADEMASK, false);
            SetKeyword(material, _DEBUG_2ND_SHADING_GRADEMASK, false);
        }
    }

}