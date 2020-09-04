using UnityEditor;
using UnityEngine;
using static YoyogiMori.YMT_GUILayout;
using static YoyogiMori.YMT_SetParamUtils;

namespace YoyogiMori {

    public class OutlineSettings : YMT_FeatureBase {
        private static bool _Outline_Foldout = true;
        private static bool _AdvancedOutline_Foldout = true;

        private static MaterialProperty _Outline_Width = null;
        private static MaterialProperty _Outline_Color = null;
        private static MaterialProperty _Is_BlendBaseColorWeight = null;
        private static MaterialProperty _Offset_Z = null;
        private static MaterialProperty _Farthest_Distance = null;
        private static MaterialProperty _Nearest_Distance = null;
        private static MaterialProperty _OutlineMap = null;
        private static MaterialProperty _BakedNormal = null;

        new protected static void FindProps(YMToon2GUI ymtoon) {
            ymtoon.FindProp(ref _Outline_Width, "_Outline_Width");
            ymtoon.FindProp(ref _Outline_Color, "_Outline_Color");
            ymtoon.FindProp(ref _Is_BlendBaseColorWeight, "_Is_BlendBaseColorWeight");
            ymtoon.FindProp(ref _Offset_Z, "_Offset_Z");
            ymtoon.FindProp(ref _Farthest_Distance, "_Farthest_Distance");
            ymtoon.FindProp(ref _Nearest_Distance, "_Nearest_Distance");
            ymtoon.FindProp(ref _OutlineMap, "_OutlineMap");
            ymtoon.FindProp(ref _BakedNormal, "_BakedNormal");
        }

        new public static void Draw(YMToon2GUI ymtoon, MaterialEditor materialEditor) {
            FindProps(ymtoon);
            m_MaterialEditor = materialEditor;
            var material = m_MaterialEditor.target as Material;

            DrawFoldOutMenu(ref _Outline_Foldout, "【Outline Settings】",
                () => {
                    EditorGUILayout.Space();
                    GUI_Outline(material);
                    DebugDraw(material);
                }
            );

        }

        private static void GUI_Outline(Material material) {
            GUILayout.Label("Outline Mask : Combined Mask.g", EditorStyles.boldLabel);

            m_MaterialEditor.FloatProperty(_Outline_Width, "Outline Width");
            m_MaterialEditor.ColorProperty(_Outline_Color, "Outline Color");

            var isBlendBaseColor = DrawToggleButton(material, "Blend BaseColor to Outline", "_Is_BlendBaseColor");

            if (isBlendBaseColor) {
                DrawContentWithIndent(() => {
                    m_MaterialEditor.RangeProperty(_Is_BlendBaseColorWeight, "BlendBaseColorWeight");
                });
            }

            m_MaterialEditor.FloatProperty(_Offset_Z, "Offset Outline with Camera Z-axis");

            _AdvancedOutline_Foldout = FoldoutSubMenu(_AdvancedOutline_Foldout, "● Advanced Outline Settings");
            if (_AdvancedOutline_Foldout) {

                DrawContentWithIndent(() => {
                    GUILayout.Label("    Camera Distance for Outline Width");
                    m_MaterialEditor.FloatProperty(_Farthest_Distance, "● Farthest Distance to vanish");
                    m_MaterialEditor.FloatProperty(_Nearest_Distance, "● Nearest Distance to draw with Outline Width");
                });

                var useOutlineTexture = DrawToggleButton(material, "Use Outline Texture", "_Is_OutlineMap");

                if (useOutlineTexture) {
                    m_MaterialEditor.TexturePropertySingleLine(Styles.outlineTexText, _OutlineMap);
                }

                var useBakedNormal = DrawToggleButton(material, "Use Baked Normal for Outline", "_Is_BakedNormal");

                if (useBakedNormal) {
                    m_MaterialEditor.TexturePropertySingleLine(Styles.bakedNormalOutlineText, _BakedNormal);

                }
            }
        }

        new protected static void DebugDraw(Material material) {

        }

        new public static void DisableAllDebugDraw(Material material) {

        }
    }

}