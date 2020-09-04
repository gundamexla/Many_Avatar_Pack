using System;
using UnityEditor;
using UnityEngine;
using static YoyogiMori.YMT_SetParamUtils;

namespace YoyogiMori {
    public static class YMT_GUILayout {

        public static GUILayoutOption[] shortButtonStyle => new GUILayoutOption[] { GUILayout.Width(130) };
        public static GUILayoutOption[] middleButtonStyle => new GUILayoutOption[] { GUILayout.Width(130) };

        /// <summary>
        /// タイトルとToggleボタンを作る　
        /// </summary>
        /// <param name="material"></param>
        /// <param name="label"></param>
        /// <param name="prefixLabel"></param>
        /// <param name="shaderParamName"></param>
        /// <returns>shaderParamがEnableかどうか</returns>
        [SerializeField]
        public static bool DrawToggleButton(Material material, string prefixLabel, string shaderParamName, string disableLabel = "Off", string enableLabel = "Active") {

            EditorGUILayout.BeginHorizontal();

            EditorGUILayout.PrefixLabel(prefixLabel);
            if (material.GetFloat(shaderParamName) == 0) {
                if (GUILayout.Button(disableLabel, shortButtonStyle)) {
                    SetFloat(material, shaderParamName, 1);
                }
            } else {
                if (GUILayout.Button(enableLabel, shortButtonStyle)) {
                    SetFloat(material, shaderParamName, 0);
                }
            }
            EditorGUILayout.EndHorizontal();

            return material.GetFloat(shaderParamName) == 1;
        }

        /// <summary>
        /// なにかの処理を実行する用のボタン
        /// </summary>
        /// <param name="prefixLabel"></param>
        /// <param name="OnExecuted"></param>
        public static void DrawExecuteButton(string prefixLabel, Action OnExecuted = null, string executeLabel = "Execute") {
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.PrefixLabel(prefixLabel);
            if (GUILayout.Button(executeLabel, middleButtonStyle)) {
                OnExecuted?.Invoke();
            }
            EditorGUILayout.EndHorizontal();
        }

        /// <summary>
        /// OnIndentedの中身をindentした状態で書く
        /// </summary>
        /// <param name="OnIndented"></param>
        /// <param name="indentLevel"></param>
        public static void DrawContentWithIndent(Action OnIndented = null, int indentLevel = 1) {
            EditorGUI.indentLevel += indentLevel;
            OnIndented?.Invoke();
            EditorGUI.indentLevel -= indentLevel;
        }

        /// <summary>
        /// Shader Keyword の toggle を書く
        /// </summary>
        /// <param name="material"></param>
        /// <param name="label"></param>
        /// <param name="shaderKeyWord"></param>
        public static void DrawKeywordToggle(Material material, string label, string shaderKeyWord) {
            bool keywordEnable = material.IsKeywordEnabled(shaderKeyWord);
            keywordEnable = EditorGUILayout.Toggle(label, keywordEnable);
            SetKeyword(material, shaderKeyWord, keywordEnable);
        }

        public static void DrawFoldOutMenu(ref bool foldState, string label, Action OnGuiFunc = null) {
            foldState = Foldout(foldState, label);
            if (foldState) {
                DrawContentWithIndent(() => {
                    OnGuiFunc?.Invoke();
                });
            }
        }

        public static bool Foldout(bool display, string title) {
            var style = new GUIStyle("ShurikenModuleTitle");
            style.font = new GUIStyle(EditorStyles.boldLabel).font;
            style.border = new RectOffset(15, 7, 4, 4);
            style.fixedHeight = 22;
            style.contentOffset = new Vector2(20f, -2f);

            var rect = GUILayoutUtility.GetRect(16f, 22f, style);
            GUI.Box(rect, title, style);

            var e = Event.current;

            var toggleRect = new Rect(rect.x + 4f, rect.y + 2f, 13f, 13f);
            if (e.type == EventType.Repaint) {
                EditorStyles.foldout.Draw(toggleRect, false, false, display, false);
            }

            if (e.type == EventType.MouseDown && rect.Contains(e.mousePosition)) {
                display = !display;
                e.Use();
            }

            return display;
        }

        public static void DrawFoldOutSubMenu(ref bool foldState, string label, Action OnGuiFunc = null) {
            foldState = FoldoutSubMenu(foldState, label);
            if (foldState) {
                DrawContentWithIndent(() => {
                    OnGuiFunc?.Invoke();
                });
            }
        }

        public static bool FoldoutSubMenu(bool display, string title) {
            var style = new GUIStyle("ShurikenModuleTitle");
            style.font = new GUIStyle(EditorStyles.boldLabel).font;
            style.border = new RectOffset(15, 7, 4, 4);
            style.padding = new RectOffset(5, 7, 4, 4);
            style.fixedHeight = 22;
            style.contentOffset = new Vector2(32f, -2f);

            var rect = GUILayoutUtility.GetRect(16f, 22f, style);
            GUI.Box(rect, title, style);

            var e = Event.current;

            var toggleRect = new Rect(rect.x + 16f, rect.y + 2f, 13f, 13f);
            if (e.type == EventType.Repaint) {
                EditorStyles.foldout.Draw(toggleRect, false, false, display, false);
            }

            if (e.type == EventType.MouseDown && rect.Contains(e.mousePosition)) {
                display = !display;
                e.Use();
            }

            return display;
        }
    }

}