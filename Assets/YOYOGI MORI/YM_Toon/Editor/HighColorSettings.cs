using UnityEditor;
using UnityEngine;
using static YoyogiMori.YMT_GUILayout;
using static YoyogiMori.YMT_SetParamUtils;

namespace YoyogiMori {

    public class HighColorSettings : YMT_FeatureBase {

        private static bool _HighColor_Foldout = true;
        private static string _DEBUG_HIGH_COLOR_MASK => "_DEBUG_HIGH_COLOR_MASK";
        private static string _DEBUG_HIGHCOLOR_UVSET => "_DEBUG_HIGHCOLOR_UVSET";

        private static MaterialProperty _HighColorMap = null;
        private static MaterialProperty _Use_2ndUV_As_HighColorMapMask = null;

        private static MaterialProperty _HighColor = null;
        private static MaterialProperty _HighColor_Power = null;
        private static MaterialProperty _Tweak_HighColorMaskLevel = null;

        private static MaterialProperty _HighColorMapMaskScaler = null;

        private static MaterialProperty _HighColorMapMaskOffset = null;

        private static MaterialProperty _AnisotropicHighLightPowerLow = null;
        private static MaterialProperty _AnisotropicHighLightStrengthLow = null;
        private static MaterialProperty _AnisotropicHighLightPowerHigh = null;
        private static MaterialProperty _AnisotropicHighLightStrengthHigh = null;
        private static MaterialProperty _ShiftTangent = null;

        new protected static void FindProps(YMToon2GUI ymtoon) {
            ymtoon.FindProp(ref _HighColorMap, "_HighColorMap");
            ymtoon.FindProp(ref _ShiftTangent, "_ShiftTangent");
            ymtoon.FindProp(ref _HighColor, "_HighColor");
            ymtoon.FindProp(ref _HighColor_Power, "_HighColor_Power");
            ymtoon.FindProp(ref _Tweak_HighColorMaskLevel, "_Tweak_HighColorMaskLevel");

            ymtoon.FindProp(ref _HighColorMapMaskScaler, "_HighColorMapMaskScaler");
            ymtoon.FindProp(ref _HighColorMapMaskOffset, "_HighColorMapMaskOffset");

            ymtoon.FindProp(ref _AnisotropicHighLightPowerLow, "_AnisotropicHighLightPowerLow");
            ymtoon.FindProp(ref _AnisotropicHighLightStrengthLow, "_AnisotropicHighLightStrengthLow");
            ymtoon.FindProp(ref _AnisotropicHighLightPowerHigh, "_AnisotropicHighLightPowerHigh");
            ymtoon.FindProp(ref _AnisotropicHighLightStrengthHigh, "_AnisotropicHighLightStrengthHigh");
            ymtoon.FindProp(ref _Use_2ndUV_As_HighColorMapMask, "_Use_2ndUV_As_HighColorMapMask");
        }

        new public static void Draw(YMToon2GUI ymtoon, MaterialEditor materialEditor) {
            FindProps(ymtoon);
            m_MaterialEditor = materialEditor;
            var material = m_MaterialEditor.target as Material;

            DrawFoldOutMenu(ref _HighColor_Foldout, "【HighColor Settings】",
                () => {
                    EditorGUILayout.Space();
                    GUI_HighColor(material);
                    DebugDraw(material);
                }
            );
            EditorGUILayout.Space();

        }

        private static void GUI_HighColor(Material material) {
            m_MaterialEditor.TexturePropertySingleLine(Styles.highColorText, _HighColorMap, _HighColor);
            m_MaterialEditor.TextureScaleOffsetProperty(_HighColorMap);

            EditorGUILayout.Space();

            DrawToggleButton(material, "Use 2ndUV As HighColorMask", "_Use_2ndUV_As_HighColorMapMask");

            EditorGUILayout.Space();

            var useAnisoHighLight = DrawToggleButton(material, "Use Aniso HighLight", "_Use_Aniso_HighLight");

            EditorGUILayout.Space();

            if (useAnisoHighLight) {
                DrawContentWithIndent(() => {
                    m_MaterialEditor.ShaderProperty(_AnisotropicHighLightPowerLow, "_AnisotropicHighLightPowerLow");
                    m_MaterialEditor.ShaderProperty(_AnisotropicHighLightStrengthLow, "_AnisotropicHighLightStrengthLow");
                    m_MaterialEditor.ShaderProperty(_AnisotropicHighLightPowerHigh, "_AnisotropicHighLightPowerHigh");
                    m_MaterialEditor.ShaderProperty(_AnisotropicHighLightStrengthHigh, "_AnisotropicHighLightStrengthHigh");
                    m_MaterialEditor.ShaderProperty(_ShiftTangent, "_ShiftTangent");
                });
            } else {

                m_MaterialEditor.RangeProperty(_HighColor_Power, "HighColor Power");

                EditorGUILayout.Space();

                m_MaterialEditor.RangeProperty(_HighColorMapMaskScaler, "HighColorMapMask Scaler");
                m_MaterialEditor.RangeProperty(_HighColorMapMaskOffset, "HighColorMapMask Offset");

                EditorGUILayout.Space();

                DrawToggleButton(material, "Specular Mode", "_Is_SpecularToHighColor");
                DrawToggleButton(material, "Color Blend Mode", "_Is_BlendAddToHiColor");
            }

            EditorGUILayout.Space();

            var useTweakHighColorShadow = DrawToggleButton(material, "ShadowMask on HighColor", "_Is_UseTweakHighColorOnShadow");
            if (useTweakHighColorShadow) {
                DrawContentWithIndent(() => m_MaterialEditor.RangeProperty(_Tweak_HighColorMaskLevel, "HighColor Power on Shadow"));
            }

            DrawToggleButton(material, "Mul LightColor To HighColor", "_Is_LightColor_HighColor");

        }

        new protected static void DebugDraw(Material material) {
            GUILayout.Label("Debug", EditorStyles.boldLabel);

            DrawContentWithIndent(() => {
                DrawKeywordToggle(material, "Debug High Color UVSet", _DEBUG_HIGHCOLOR_UVSET);
                DrawKeywordToggle(material, "Debug High Color Mask", _DEBUG_HIGH_COLOR_MASK);
            });
        }

        new public static void DisableAllDebugDraw(Material material) {
            SetKeyword(material, _DEBUG_HIGHCOLOR_UVSET, false);
            SetKeyword(material, _DEBUG_HIGH_COLOR_MASK, false);

        }
    }

}