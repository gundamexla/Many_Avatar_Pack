using UnityEditor;
using UnityEngine;
using static YoyogiMori.YMT_GUILayout;
using static YoyogiMori.YMT_SetParamUtils;

namespace YoyogiMori {

    public class AdditionalLightingSettings : YMT_FeatureBase {

        private static bool _AdditionalLightingSettings_Foldout = true;

        private static MaterialProperty _GI_Intensity = null;
        private static MaterialProperty _Unlit_Intensity = null;
        private static MaterialProperty _EulerAnglesCache = null;
        private static MaterialProperty _LightIntensityCache = null;
        private static MaterialProperty _LightColorChache = null;

        new protected static void FindProps(YMToon2GUI ymtoon) {
            ymtoon.FindProp(ref _GI_Intensity, "_GI_Intensity");
            ymtoon.FindProp(ref _Unlit_Intensity, "_Unlit_Intensity");
            ymtoon.FindProp(ref _EulerAnglesCache, "_EulerAnglesCache");
            ymtoon.FindProp(ref _LightIntensityCache, "_LightIntensityCache");
            ymtoon.FindProp(ref _LightColorChache, "_LightColorChache");
        }

        new public static void Draw(YMToon2GUI ymtoon, MaterialEditor materialEditor) {
            FindProps(ymtoon);
            m_MaterialEditor = materialEditor;
            var material = m_MaterialEditor.target as Material;

            DrawFoldOutMenu(ref _AdditionalLightingSettings_Foldout, "【Environmental Lighting Contributions Setups】",
                () => {
                    EditorGUILayout.Space();

                    GUI_AdditionalLightingSettings(material);
                    DebugDraw(material);
                }
            );
            EditorGUILayout.Space();

        }

        private static Vector3 eulerAnglesCache = new Vector3(150, 30, 0);
        private static float lightIntensityCache = 1.0f;
        private static Color lightColorChache = Color.white;

        private static void GUI_AdditionalLightingSettings(Material material) {

            var useOwnDirLight = DrawToggleButton(material, "Use Own Directional Light", "_Use_OwnDirLight");
            if (useOwnDirLight) {

                DrawContentWithIndent(() => {
                    eulerAnglesCache = material.GetVector("_EulerAnglesCache");
                    eulerAnglesCache = EditorGUILayout.Vector3Field("Directional Light Rotation", eulerAnglesCache);
                    SetVector(material, "_EulerAnglesCache", eulerAnglesCache);

                    var eulerAngles = Quaternion.Euler(eulerAnglesCache).eulerAngles;
                    var ownLightDir = Quaternion.Euler(eulerAnglesCache) * (-Vector3.forward);

                    SetVector(material, "_OwnDirectionalLightDir", new Vector4(ownLightDir.x, ownLightDir.y, ownLightDir.z, 1));

                    lightIntensityCache = material.GetFloat("_LightIntensityCache");
                    lightIntensityCache = EditorGUILayout.FloatField("Directional Light Intensity", lightIntensityCache);
                    SetFloat(material, "_LightIntensityCache", lightIntensityCache);

                    lightColorChache = material.GetColor("_LightColorChache");
                    lightColorChache = EditorGUILayout.ColorField("Directional Light Color", lightColorChache);
                    SetColor(material, "_LightColorChache", lightColorChache);

                    SetColor(material, "_OwnDirectionalLightColor", lightColorChache * lightIntensityCache);
                });

                EditorGUILayout.Space();
            }

            m_MaterialEditor.RangeProperty(_GI_Intensity, "GI Intensity");
            m_MaterialEditor.RangeProperty(_Unlit_Intensity, "Unlit Intensity");

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.PrefixLabel("SceneLights Hi-Cut Filter");

            if (material.GetFloat("_Is_Filter_LightColor") == 0) {
                if (GUILayout.Button("Off", shortButtonStyle)) {
                    SetFloat(material, "_Is_Filter_LightColor", 1);
                    SetFloat(material, "_Is_LightColor_Base", 1);
                    SetFloat(material, "_Is_LightColor_Outline", 1);
                }
            } else {
                if (GUILayout.Button("Active", shortButtonStyle)) {
                    SetFloat(material, "_Is_Filter_LightColor", 0);
                }
            }
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.Space();
        }

        new protected static void DebugDraw(Material material) {

        }

        new public static void DisableAllDebugDraw(Material material) {

        }
    }

}