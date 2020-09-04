using UnityEditor;
using UnityEngine;
using static YoyogiMori.YMT_GUILayout;
using static YoyogiMori.YMT_SetParamUtils;

namespace YoyogiMori {
    public class FakeSubSurfaceScatteringSettings : YMT_FeatureBase {
        private static bool _SSS_Foldout = true;
        private static MaterialProperty _SSSAlphaInverse = null;
        private static MaterialProperty _HSVOffset = null;
        private static MaterialProperty _SkinSSSMulColor = null;
        private static MaterialProperty _FakeTransparentWeight = null;

        private static string _DEBUG_SSS_SHIFTED => "_DEBUG_SSS_SHIFTED";
        private static string _DEBUG_SSS_SHIFTED_W_MASK => "_DEBUG_SSS_SHIFTED_W_MASK";

        new protected static void FindProps(YMToon2GUI ymtoon) {

            ymtoon.FindProp(ref _SSSAlphaInverse, "_SSSAlphaInverse");
            ymtoon.FindProp(ref _SkinSSSMulColor, "_SkinSSSMulColor");
            ymtoon.FindProp(ref _HSVOffset, "_HSVOffset");
            ymtoon.FindProp(ref _FakeTransparentWeight, "_FakeTransparentWeight");
        }

        new public static void Draw(YMToon2GUI ymtoon, MaterialEditor materialEditor) {
            FindProps(ymtoon);
            m_MaterialEditor = materialEditor;
            var material = m_MaterialEditor.target as Material;

            DrawFoldOutMenu(ref _SSS_Foldout, "【SSS Settings】",
                () => {
                    EditorGUILayout.Space();
                    GUI_SSSSettings(material);
                    DebugDraw(material);
                }
            );
        }
        private static void GUI_SSSSettings(Material material) {
            GUILayout.Label("SSS Mask : Combined Mask.b", EditorStyles.boldLabel);
            DrawToggleButton(material, "SSS Alpha Inverse", "_SSSAlphaInverse");

            var isSkin = DrawToggleButton(material, "Is Skin ?", "_Is_Skin");
            if (isSkin) {
                m_MaterialEditor.ColorProperty(_SkinSSSMulColor, "SSS Mul Color");
            }

            GUILayout.Label("HSV Shift", EditorStyles.boldLabel);

            DrawContentWithIndent(() => {
                var hue = EditorGUILayout.Slider("Hue", _HSVOffset.vectorValue.x, 0, 360);
                var saturation = EditorGUILayout.Slider("Saturate", _HSVOffset.vectorValue.y, 0, 2);
                var value = EditorGUILayout.Slider("Value", _HSVOffset.vectorValue.z, 0, 200);

                SetVector(material, "_HSVOffset", new Vector4(hue, saturation, value, 1));
            });
        }

        new protected static void DebugDraw(Material material) {
            GUILayout.Label("Debug", EditorStyles.boldLabel);
            DrawContentWithIndent(() => {
                DrawKeywordToggle(material, "Debug SSS Shifted Color", _DEBUG_SSS_SHIFTED);
                DrawKeywordToggle(material, "Debug SSS Shifted Color With Mask", _DEBUG_SSS_SHIFTED_W_MASK);
            });
        }

        new public static void DisableAllDebugDraw(Material material) {
            SetKeyword(material, _DEBUG_SSS_SHIFTED, false);
            SetKeyword(material, _DEBUG_SSS_SHIFTED_W_MASK, false);
        }
    }

}