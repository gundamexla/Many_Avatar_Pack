using UnityEditor;
using UnityEngine;
using static YoyogiMori.YMT_GUILayout;
using static YoyogiMori.YMT_SetParamUtils;

namespace YoyogiMori {

    public class StandardSettings : YMT_FeatureBase {

        public enum SmoothnessTextureChannel {
            SpecularMetallicAlpha,
            AlbedoAlpha,
        }

        private static bool _Standard_Foldout = true;
        private static string _DEBUG_STANDARD => "_DEBUG_STANDARD";
        private static MaterialProperty _StandardBlendWeight = null;
        private static MaterialProperty _SmoothnessTextureChannel = null;
        private static MaterialProperty _Metallic = null;
        private static MaterialProperty _MetallicGlossMap = null;
        private static MaterialProperty _Glossiness = null;
        private static MaterialProperty _GlossMapScale = null;
        private static MaterialProperty _SpecularHighlights = null;
        private static MaterialProperty _GlossyReflections = null;
        private static MaterialProperty _IBLWeight = null;

        new protected static void FindProps(YMToon2GUI ymtoon) {
            ymtoon.FindProp(ref _StandardBlendWeight, "_StandardBlendWeight");

            ymtoon.FindProp(ref _SmoothnessTextureChannel, "_SmoothnessTextureChannel");

            ymtoon.FindProp(ref _Metallic, "_Metallic");
            ymtoon.FindProp(ref _MetallicGlossMap, "_MetallicGlossMap");
            ymtoon.FindProp(ref _Glossiness, "_Glossiness");
            ymtoon.FindProp(ref _GlossMapScale, "_GlossMapScale");

            ymtoon.FindProp(ref _SpecularHighlights, "_SpecularHighlights");
            ymtoon.FindProp(ref _GlossyReflections, "_GlossyReflections");
            ymtoon.FindProp(ref _IBLWeight, "_IBLWeight");

        }

        new public static void Draw(YMToon2GUI ymtoon, MaterialEditor materialEditor) {
            FindProps(ymtoon);
            m_MaterialEditor = materialEditor;
            var material = m_MaterialEditor.target as Material;

            DrawFoldOutMenu(ref _Standard_Foldout, "【Standard Settings】",
                () => {
                    EditorGUILayout.Space();
                    GUI_StandardSettings(material);
                    DebugDraw(material);
                }
            );

        }

        private static void GUI_StandardSettings(Material material) {
            GUILayout.Label("Metalic Mask : Combined Mask.a", EditorStyles.boldLabel);
            m_MaterialEditor.RangeProperty(_IBLWeight, "IBL Blend Weight");

            EditorGUILayout.Space();

            m_MaterialEditor.RangeProperty(_StandardBlendWeight, "Standard Blend Weight");

            DoSpecularMetallicArea(material);

            m_MaterialEditor.ShaderProperty(_SpecularHighlights, Styles.highlightsText);
            m_MaterialEditor.ShaderProperty(_GlossyReflections, Styles.reflectionsText);

            m_MaterialEditor.EnableInstancingField();
        }

        private static SmoothnessTextureChannel GetSmoothnessMapChannel(Material material) {
            int ch = (int) material.GetFloat("_SmoothnessTextureChannel");
            if (ch == (int) SmoothnessTextureChannel.AlbedoAlpha)
                return SmoothnessTextureChannel.AlbedoAlpha;
            else
                return SmoothnessTextureChannel.SpecularMetallicAlpha;
        }

        private static void DoSpecularMetallicArea(Material material) {
            SetKeyword(material, "_METALLICGLOSSMAP", material.GetTexture("_MetallicGlossMap"));

            if (material.HasProperty("_SmoothnessTextureChannel")) {
                SetKeyword(material, "_SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A", GetSmoothnessMapChannel(material) == SmoothnessTextureChannel.AlbedoAlpha);
            }

            bool hasGlossMap = false;
            if (_MetallicGlossMap != null) {
                hasGlossMap = _MetallicGlossMap.textureValue != null;
                m_MaterialEditor.TexturePropertySingleLine(Styles.metallicGlossMapText, _MetallicGlossMap, hasGlossMap ? null : _Metallic);
            }

            bool showSmoothnessScale = hasGlossMap;
            if (_SmoothnessTextureChannel != null) {
                int smoothnessChannel = (int) _SmoothnessTextureChannel.floatValue;
                if (smoothnessChannel == (int) SmoothnessTextureChannel.AlbedoAlpha)
                    showSmoothnessScale = true;
            }
            if (_GlossMapScale != null && _Glossiness != null) {
                int indentation = 2;
                m_MaterialEditor.ShaderProperty(showSmoothnessScale ? _GlossMapScale : _Glossiness, showSmoothnessScale ? Styles.glossMapScaleText : Styles.glossinessText, indentation);
                ++indentation;
                if (_SmoothnessTextureChannel != null) {
                    m_MaterialEditor.ShaderProperty(_SmoothnessTextureChannel, Styles.smoothnessTextureChannelText, indentation);
                }
            }
        }

        new protected static void DebugDraw(Material material) {
            GUILayout.Label("Debug", EditorStyles.boldLabel);

            DrawContentWithIndent(() => {
                DrawKeywordToggle(material, "Debug Standard", _DEBUG_STANDARD);
            });
        }

        new public static void DisableAllDebugDraw(Material material) {
            SetKeyword(material, _DEBUG_STANDARD, false);
        }
    }

}