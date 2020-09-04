using UnityEditor;
using UnityEngine;
using static YoyogiMori.YMT_GUILayout;
using static YoyogiMori.YMT_SetParamUtils;

namespace YoyogiMori {

    public class NormalMapSettings : YMT_FeatureBase {

        private static bool _NormalMap_Foldout = true;
        private static MaterialProperty _BumpMap = null;
        private static MaterialProperty _BumpScale = null;

        private static string _DEBUG_ORIGINAL_NORMAL => "_DEBUG_ORIGINAL_NORMAL";
        private static string _DEBUG_MAPPED_NORMAL => "_DEBUG_MAPPED_NORMAL";

        new protected static void FindProps(YMToon2GUI ymtoon) {
            ymtoon.FindProp(ref _BumpMap, "_BumpMap");
            ymtoon.FindProp(ref _BumpScale, "_BumpScale");
        }

        new public static void Draw(YMToon2GUI ymtoon, MaterialEditor materialEditor) {
            FindProps(ymtoon);
            m_MaterialEditor = materialEditor;
            var material = m_MaterialEditor.target as Material;

            DrawFoldOutMenu(ref _NormalMap_Foldout, "● NormalMap Settings", () => {
                GUI_NormalMap(material);
                DebugDraw(material);
            });

            EditorGUILayout.Space();
        }

        private static void GUI_NormalMap(Material material) {

            m_MaterialEditor.TexturePropertySingleLine(Styles.normalMapText, _BumpMap, _BumpScale);
            m_MaterialEditor.TextureScaleOffsetProperty(_BumpMap);

            GUILayout.Label("NormalMap Effectiveness", EditorStyles.boldLabel);

            DrawToggleButton(material, "3 Basic Colors", "_Is_NormalMapToBase");
            DrawToggleButton(material, "HighColor", "_Is_NormalMapToHighColor");
            DrawToggleButton(material, "RimLight", "_Is_NormalMapToRimLight");

            EditorGUILayout.Space();
        }

        new protected static void DebugDraw(Material material) {
            GUILayout.Label("Debug", EditorStyles.boldLabel);
            DrawContentWithIndent(() => {
                DrawKeywordToggle(material, "Debug Original Normal", _DEBUG_ORIGINAL_NORMAL);
                DrawKeywordToggle(material, "Debug Normal Map", _DEBUG_MAPPED_NORMAL);
            });
        }

        new public static void DisableAllDebugDraw(Material material) {
            SetKeyword(material, _DEBUG_ORIGINAL_NORMAL, false);
            SetKeyword(material, _DEBUG_MAPPED_NORMAL, false);
        }
    }

}