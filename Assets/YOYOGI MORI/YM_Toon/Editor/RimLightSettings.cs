using UnityEditor;
using UnityEngine;
using static YoyogiMori.YMT_GUILayout;
using static YoyogiMori.YMT_SetParamUtils;

namespace YoyogiMori {

    public class RimLightSettings : YMT_FeatureBase {

        private static bool _RimLight_Foldout = true;
        private static string _DEBUG_RIM_LIGHT => "_DEBUG_RIM_LIGHT";

        private static MaterialProperty _RimLightColor = null;
        private static MaterialProperty _RimLight_Power = null;
        private static MaterialProperty _RimLight_InsideMask = null;
        private static MaterialProperty _Tweak_LightDirection_MaskLevel = null;
        private static MaterialProperty _Ap_RimLightColor = null;
        private static MaterialProperty _Ap_RimLight_Power = null;
        private static MaterialProperty _Tweak_RimLightMaskLevel = null;

        new protected static void FindProps(YMToon2GUI ymtoon) {
            ymtoon.FindProp(ref _RimLightColor, "_RimLightColor");
            ymtoon.FindProp(ref _RimLight_Power, "_RimLight_Power");
            ymtoon.FindProp(ref _RimLight_InsideMask, "_RimLight_InsideMask");
            ymtoon.FindProp(ref _Tweak_LightDirection_MaskLevel, "_Tweak_LightDirection_MaskLevel");

            ymtoon.FindProp(ref _Ap_RimLightColor, "_Ap_RimLightColor");
            ymtoon.FindProp(ref _Ap_RimLight_Power, "_Ap_RimLight_Power");
            ymtoon.FindProp(ref _RimLight_InsideMask, "_RimLight_InsideMask");
            ymtoon.FindProp(ref _Tweak_RimLightMaskLevel, "_Tweak_RimLightMaskLevel");
        }

        new public static void Draw(YMToon2GUI ymtoon, MaterialEditor materialEditor) {
            FindProps(ymtoon);
            m_MaterialEditor = materialEditor;
            var material = m_MaterialEditor.target as Material;

            DrawFoldOutMenu(ref _RimLight_Foldout, "【RimLight Settings】",
                () => {
                    EditorGUILayout.Space();
                    GUI_RimLight(material);
                    DebugDraw(material);
                }
            );

            EditorGUILayout.Space();

        }

        private static void GUI_RimLight(Material material) {

            var useRimLight = DrawToggleButton(material, "RimLight", "_RimLight");

            if (useRimLight) {
                DrawContentWithIndent(() => {
                    GUILayout.Label("    RimLight Settings (RimLight Mask : Combined Mask.r)", EditorStyles.boldLabel);
                    m_MaterialEditor.ColorProperty(_RimLightColor, "RimLight Color");
                    m_MaterialEditor.RangeProperty(_RimLight_Power, "RimLight Power");

                    m_MaterialEditor.RangeProperty(_RimLight_InsideMask, "RimLight Inside Mask");

                    DrawToggleButton(material, "RimLight FeatherOff", "_RimLight_FeatherOff");
                    var useLightDirectionMask = DrawToggleButton(material, "LightDirection Mask", "_LightDirection_MaskOn");

                    if (useLightDirectionMask) {
                        DrawContentWithIndent(() => {
                            m_MaterialEditor.RangeProperty(_Tweak_LightDirection_MaskLevel, "LightDirection MaskLevel");

                            var addApRimLight = DrawToggleButton(material, "Antipodean(Ap)_RimLight", "_Add_Antipodean_RimLight");

                            if (addApRimLight) {
                                DrawContentWithIndent(() => {
                                    GUILayout.Label("    Ap_RimLight Settings", EditorStyles.boldLabel);
                                    m_MaterialEditor.ColorProperty(_Ap_RimLightColor, "Ap_RimLight Color");
                                    m_MaterialEditor.RangeProperty(_Ap_RimLight_Power, "Ap_RimLight Power");

                                    DrawToggleButton(material, "Ap_RimLight FeatherOff", "_Ap_RimLight_FeatherOff");
                                });
                            }
                        });
                    }
                });
            }
            EditorGUILayout.Space();
            m_MaterialEditor.RangeProperty(_Tweak_RimLightMaskLevel, "RimLight Mask Level");

            EditorGUILayout.Space();

        }

        new protected static void DebugDraw(Material material) {
            GUILayout.Label("Debug", EditorStyles.boldLabel);
            DrawContentWithIndent(() => {
                DrawKeywordToggle(material, "Debug RimLight", _DEBUG_RIM_LIGHT);
            });
        }

        new public static void DisableAllDebugDraw(Material material) {
            SetKeyword(material, _DEBUG_RIM_LIGHT, false);
        }
    }

}