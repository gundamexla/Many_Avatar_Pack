//Unitychan Toon Shader ver.2.0
//UTS2GUI.cs for UTS2 v.2.0.7.5
//nobuyuki@unity3d.com
//https://github.com/unity3d-jp/UnityChanToonShaderVer2_Project
//(C)Unity Technologies Japan/UCL
using UnityEditor;
using UnityEngine;

namespace YoyogiMori {
    public class YMToon2GUI : ShaderGUI {
        private MaterialProperty[] m_props;
        private Material m_material;
        [HideInInspector] public bool isChanged = false;

        public void FindProp(ref MaterialProperty targetProp, string propName) {
            targetProp = FindProperty(propName, m_props, false);
        }

        public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props) {
            EditorGUIUtility.fieldWidth = 0;
            m_material = materialEditor.target as Material;
            m_props = props;

            EditorGUI.BeginChangeCheck();

            EditorGUILayout.Space();

            BasicShaderSettings.Draw(this, materialEditor);

            EditorGUILayout.Space();

            BaseColorSettings.Draw(this, materialEditor);

            EditorGUILayout.Space();

            NormalMapSettings.Draw(this, materialEditor);

            EditorGUILayout.Space();

            BasicLookdevsSettings.Draw(this, materialEditor);

            EditorGUILayout.Space();

            HighColorSettings.Draw(this, materialEditor);

            EditorGUILayout.Space();

            RimLightSettings.Draw(this, materialEditor);

            EditorGUILayout.Space();

            EmissiveSettings.Draw(this, materialEditor);

            EditorGUILayout.Space();

            FakeSubSurfaceScatteringSettings.Draw(this, materialEditor);

            EditorGUILayout.Space();

            StandardSettings.Draw(this, materialEditor);

            EditorGUILayout.Space();

            OutlineSettings.Draw(this, materialEditor);

            EditorGUILayout.Space();

            TessellationSettings.Draw(this, materialEditor);

            EditorGUILayout.Space();

            AdditionalLightingSettings.Draw(this, materialEditor);

            EditorGUILayout.Space();

            if (EditorGUI.EndChangeCheck()) {
                materialEditor.PropertiesChanged();

                materialEditor.RegisterPropertyChangeUndo("Mat Changed");
            }

            if (isChanged) {
                Undo.RecordObject(m_material, "Mat param Changed");
                Debug.Log("Mat param Changed");
                isChanged = false;
            }
        }
    }
}