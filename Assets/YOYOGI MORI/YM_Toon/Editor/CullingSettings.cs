using UnityEditor;
using UnityEngine;
using static YoyogiMori.YMT_SetParamUtils;

namespace YoyogiMori {

    public class CullingSettings : YMT_FeatureBase {

        public enum _CullingMode {
            CullingOff,
            FrontCulling,
            BackCulling
        }

        public static _CullingMode cullingMode = _CullingMode.BackCulling;
        private static string CULL_MODE => "_CullMode";

        new protected static void FindProps(YMToon2GUI ymtoon) {

        }

        new public static void Draw(YMToon2GUI ymtoon, MaterialEditor materialEditor) {
            FindProps(ymtoon);
            m_MaterialEditor = materialEditor;
            var material = m_MaterialEditor.target as Material;

            GUI_SetCullingMode(material);
            DebugDraw(material);
            EditorGUILayout.Space();

        }

        private static void GUI_SetCullingMode(Material material) {
            cullingMode = (_CullingMode) material.GetInt(CULL_MODE);
            var preCullingMode = cullingMode;

            ShaderValidateCheck(material);

            cullingMode = (_CullingMode) EditorGUILayout.EnumPopup("Culling Mode", cullingMode);
            SetFloat(material, CULL_MODE, (int) cullingMode);

            if (cullingMode == preCullingMode) { return; }

            switch (cullingMode) {
                case _CullingMode.BackCulling:
                    {
                        SetShader(material, "YMToon/Base");
                        break;
                    }
                case _CullingMode.FrontCulling:
                    {
                        SetShader(material, "Hidden/YMToon/Base/Front");
                        break;
                    }
                case _CullingMode.CullingOff:
                    {
                        SetShader(material, "Hidden/YMToon/Base/Off");
                        break;
                    }
                default:
                    {
                        break;
                    }
            }
        }

        private static void ShaderValidateCheck(Material material) {
            //これだけは発生するはず
            if (material.shader == Shader.Find("YMToon/Base") && cullingMode != _CullingMode.BackCulling) {
                cullingMode = _CullingMode.BackCulling;
            }

            //ねんのため
            if (material.shader == Shader.Find("Hidden/YMToon/Base/Front") && cullingMode != _CullingMode.FrontCulling) {
                cullingMode = _CullingMode.FrontCulling;
            }

            if (material.shader == Shader.Find("Hidden/YMToon/Base/Off") && cullingMode != _CullingMode.CullingOff) {
                cullingMode = _CullingMode.CullingOff;
            }

            //TODO: 後方互換のため　そのうち消す
            if (material.shader == Shader.Find("YMToon/Base") && cullingMode == _CullingMode.FrontCulling) {
                SetShader(material, "Hidden/YMToon/Base/Front");
            }

            if (material.shader == Shader.Find("YMToon/Base") && cullingMode == _CullingMode.CullingOff) {
                SetShader(material, "Hidden/YMToon/Base/Off");
            }

        }

        new protected static void DebugDraw(Material material) {

        }

        new public static void DisableAllDebugDraw(Material material) {

        }
    }

}