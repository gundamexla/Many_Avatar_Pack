using UnityEditor;
using UnityEngine;
using static YoyogiMori.YMT_GUILayout;
using static YoyogiMori.YMT_SetParamUtils;

namespace YoyogiMori {

    public class VRChatSettings : YMT_FeatureBase {

        //メッセージ表示用.
        private static bool _Use_VrcRecommend = false;

        new protected static void FindProps(YMToon2GUI ymtoon) { }

        new public static void Draw(YMToon2GUI ymtoon, MaterialEditor materialEditor) {
            FindProps(ymtoon);
            m_MaterialEditor = materialEditor;
            var material = m_MaterialEditor.target as Material;

            DrawExecuteButton("VRChat Recommendation", () => {
                Set_Vrchat_Recommendation(material);
                _Use_VrcRecommend = true;
            });

            EditorGUILayout.Space();

        }

        private static void Set_Vrchat_Recommendation(Material material) {
            SetFloat(material, "_Is_LightColor_Base", 1);
            SetFloat(material, "_Is_LightColor_1st_Shade", 1);
            SetFloat(material, "_Is_LightColor_2nd_Shade", 1);
            SetFloat(material, "_Is_LightColor_HighColor", 1);
            SetFloat(material, "_Is_LightColor_RimLight", 1);
            SetFloat(material, "_Is_LightColor_Ap_RimLight", 1);
            SetFloat(material, "_Is_LightColor_MatCap", 1);
            if (material.HasProperty("_AngelRing")) { //AngelRingがある場合.
                SetFloat(material, "_Is_LightColor_AR", 1);
            }
            if (material.HasProperty("_OUTLINE")) //OUTLINEがある場合.
            {
                SetFloat(material, "_Is_LightColor_Outline", 1);
            }
            SetFloat(material, "_Set_SystemShadowsToBase", 1);
            SetFloat(material, "_Is_Filter_HiCutPointLightColor", 1);
            SetFloat(material, "_CameraRolling_Stabilizer", 1);
            SetFloat(material, "_Is_Ortho", 0);
            SetFloat(material, "_GI_Intensity", 0);
            SetFloat(material, "_Unlit_Intensity", 1);
            SetFloat(material, "_Is_Filter_LightColor", 1);
        }

        new protected static void DebugDraw(Material material) {

        }

        new public static void DisableAllDebugDraw(Material material) {

        }
    }

}