using UnityEditor;
using UnityEngine;
using static YoyogiMori.YMT_GUILayout;
using static YoyogiMori.YMT_SetParamUtils;

namespace YoyogiMori {

    public class BlendModeSettings : YMT_FeatureBase {

        public enum BlendMode {
            Opaque,
            Cutout,
            Transparent,
            Trans_Clipping // Physically plausible transparency mode, implemented as alpha pre-multiply
        }

        private static string[] _blendNames => System.Enum.GetNames(typeof(BlendMode));

        private static string _RENDER_TYPE => "RenderType";
        private static string _SRC_BLEND => "_SrcBlend";
        private static string _DST_BLEND => "_DstBlend";
        private static string _ZWRITE => "_ZWrite";

        private static MaterialProperty _Mode = null;
        public static BlendMode blendMode = BlendMode.Opaque;

        new protected static void FindProps(YMToon2GUI ymtoon) {
            ymtoon.FindProp(ref _Mode, "_Mode");
        }

        new public static void Draw(YMToon2GUI ymtoon, MaterialEditor materialEditor) {
            FindProps(ymtoon);
            m_MaterialEditor = materialEditor;

            var material = m_MaterialEditor.target as Material;
            blendMode = BlendModePopup(material);
            DebugDraw(material);
        }
        private static BlendMode BlendModePopup(Material material) {
            var mode = (BlendMode) _Mode.floatValue;
            var preMode = mode;

            mode = (BlendMode) EditorGUILayout.Popup("Rendering Mode", (int) mode, _blendNames);

            if (mode != preMode) {
                _Mode.floatValue = (float) mode;
                SetupMaterialWithBlendMode(material, mode);
            }
            m_MaterialEditor.RenderQueueField();
            return mode;
        }

        private static void SetupMaterialWithBlendMode(Material material, BlendMode blendMode) {
            switch (blendMode) {
                case BlendMode.Opaque:
                    SetOverrideTag(material, _RENDER_TYPE, "");
                    SetInt(material, _SRC_BLEND, (int) UnityEngine.Rendering.BlendMode.One);
                    SetInt(material, _DST_BLEND, (int) UnityEngine.Rendering.BlendMode.Zero);
                    SetInt(material, _ZWRITE, 1);
                    SetKeyword(material, "_ALPHAPREMULTIPLY_ON", false);
                    SetKeyword(material, "_ALPHATEST_ON", false);
                    SetRenderQueue(material, -1);
                    break;
                case BlendMode.Cutout:
                    SetOverrideTag(material, _RENDER_TYPE, "TransparentCutout");
                    SetInt(material, _SRC_BLEND, (int) UnityEngine.Rendering.BlendMode.One);
                    SetInt(material, _DST_BLEND, (int) UnityEngine.Rendering.BlendMode.Zero);
                    SetInt(material, _ZWRITE, 1);
                    SetKeyword(material, "_ALPHAPREMULTIPLY_ON", false);
                    SetKeyword(material, "_ALPHATEST_ON", true);
                    SetRenderQueue(material, (int) UnityEngine.Rendering.RenderQueue.AlphaTest);
                    break;

                case BlendMode.Transparent:
                    SetOverrideTag(material, _RENDER_TYPE, "Transparent");
                    SetInt(material, _SRC_BLEND, (int) UnityEngine.Rendering.BlendMode.SrcAlpha);
                    SetInt(material, _DST_BLEND, (int) UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
                    SetInt(material, _ZWRITE, 0);
                    SetKeyword(material, "_ALPHAPREMULTIPLY_ON", true);
                    SetKeyword(material, "_ALPHATEST_ON", false);
                    SetRenderQueue(material, (int) UnityEngine.Rendering.RenderQueue.Transparent);
                    break;

                case BlendMode.Trans_Clipping:
                    SetOverrideTag(material, _RENDER_TYPE, "Transparent");
                    SetInt(material, _SRC_BLEND, (int) UnityEngine.Rendering.BlendMode.SrcAlpha);
                    SetInt(material, _DST_BLEND, (int) UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
                    SetInt(material, _ZWRITE, 0);
                    SetKeyword(material, "_ALPHAPREMULTIPLY_ON", true);
                    SetKeyword(material, "_ALPHATEST_ON", false);
                    SetRenderQueue(material, (int) UnityEngine.Rendering.RenderQueue.Transparent);
                    break;
            }
        }

        new protected static void DebugDraw(Material material) {

        }

        new public static void DisableAllDebugDraw(Material material) {

        }
    }

}