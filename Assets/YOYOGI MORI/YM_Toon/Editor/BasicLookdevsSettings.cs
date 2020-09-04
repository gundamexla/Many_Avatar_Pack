using UnityEditor;
using UnityEngine;
using static YoyogiMori.YMT_GUILayout;
using static YoyogiMori.YMT_SetParamUtils;

namespace YoyogiMori {

    public class BasicLookdevsSettings : YMT_FeatureBase {

        private static bool _StepAndFeather_Foldout = true;

        private static MaterialProperty _BaseColor_Step = null;
        private static MaterialProperty _BaseShade_Feather = null;
        private static MaterialProperty _ShadeColor_Step = null;
        private static MaterialProperty _1st2nd_Shades_Feather = null;
        private static MaterialProperty _Tweak_SystemShadowsLevel = null;

        new protected static void FindProps(YMToon2GUI ymtoon) {
            ymtoon.FindProp(ref _BaseColor_Step, "_BaseColor_Step");
            ymtoon.FindProp(ref _BaseShade_Feather, "_BaseShade_Feather");

            ymtoon.FindProp(ref _ShadeColor_Step, "_ShadeColor_Step");
            ymtoon.FindProp(ref _1st2nd_Shades_Feather, "_1st2nd_Shades_Feather");

            ymtoon.FindProp(ref _Tweak_SystemShadowsLevel, "_Tweak_SystemShadowsLevel");

        }

        new public static void Draw(YMToon2GUI ymtoon, MaterialEditor materialEditor) {
            FindProps(ymtoon);
            m_MaterialEditor = materialEditor;
            var material = m_MaterialEditor.target as Material;

            DrawFoldOutMenu(ref _StepAndFeather_Foldout, "【Basic Lookdevs : Shading Step and Feather Settings】",
                () => {
                    GUI_BasicLookdevs(material);
                    GUI_SystemShadows(material);
                    DebugDraw(material);
                }
            );
            EditorGUILayout.Space();

        }

        private static void GUI_BasicLookdevs(Material material) {
            m_MaterialEditor.RangeProperty(_BaseColor_Step, "BaseColor Step");
            m_MaterialEditor.RangeProperty(_BaseShade_Feather, "Base/Shade Feather");
            m_MaterialEditor.RangeProperty(_ShadeColor_Step, "ShadeColor Step");
            m_MaterialEditor.RangeProperty(_1st2nd_Shades_Feather, "1st/2nd_Shades Feather");

            EditorGUILayout.Space();
        }

        private static void GUI_SystemShadows(Material material) {
            GUILayout.Label("System Shadows : Self Shadows Receiving", EditorStyles.boldLabel);
            var useSystemShadow = DrawToggleButton(material, "Receive System Shadows", "_Set_SystemShadowsToBase");

            if (useSystemShadow) {
                DrawContentWithIndent(() => m_MaterialEditor.RangeProperty(_Tweak_SystemShadowsLevel, "System Shadows Level"));
                EditorGUILayout.Space();
            }
            EditorGUILayout.Space();
        }
        new protected static void DebugDraw(Material material) {

        }

        new public static void DisableAllDebugDraw(Material material) {

        }
    }

}