using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace YoyogiMori {

    /// <summary>
    /// UndoをするためのWrapper
    /// </summary>
    public static class YMT_SetParamUtils {

        public static void SetColor(Material material, string paramName, Color value) {
            if (value == material.GetColor(paramName)) { return; }
            Undo.RecordObject(material, material.name + " " + paramName + " Changed");
            material.SetColor(paramName, value);
        }

        public static void SetColorArray(Material material, string paramName, Color[] value) {
            if (value == material.GetColorArray(paramName)) { return; }
            Undo.RecordObject(material, material.name + " " + paramName + " Changed");
            material.SetColorArray(paramName, value);
        }
        public static void SetFloat(Material material, string paramName, float value) {
            if (value == material.GetFloat(paramName)) { return; }
            Undo.RecordObject(material, material.name + " " + paramName + " Changed");
            material.SetFloat(paramName, value);
        }
        public static void SetColorArray(Material material, string paramName, float[] value) {
            if (value == material.GetFloatArray(paramName)) { return; }
            Undo.RecordObject(material, material.name + " " + paramName + " Changed");
            material.SetFloatArray(paramName, value);
        }
        public static void SetInt(Material material, string paramName, int value) {
            if (value == material.GetInt(paramName)) { return; }
            Undo.RecordObject(material, material.name + " " + paramName + " Changed");
            material.SetInt(paramName, value);
        }

        public static void SetMatrix(Material material, string paramName, Matrix4x4 value) {
            if (value == material.GetMatrix(paramName)) { return; }
            Undo.RecordObject(material, material.name + " " + paramName + " Changed");
            material.SetMatrix(paramName, value);
        }
        public static void SetMatrixArray(Material material, string paramName, Matrix4x4[] value) {
            if (value == material.GetMatrixArray(paramName)) { return; }
            Undo.RecordObject(material, material.name + " " + paramName + " Changed");
            material.SetMatrixArray(paramName, value);
        }

        public static void SetTexture(Material material, string paramName, Texture value) {
            if (value == material.GetTexture(paramName)) { return; }
            Undo.RecordObject(material, material.name + " " + paramName + " Changed");
            material.SetTexture(paramName, value);
        }

        public static void SetTextureOffset(Material material, string paramName, Vector2 value) {
            if (value == material.GetTextureOffset(paramName)) { return; }
            Undo.RecordObject(material, material.name + " " + paramName + " Changed");
            material.SetTextureOffset(paramName, value);
        }

        public static void SetTextureScale(Material material, string paramName, Vector2 value) {
            if (value == material.GetTextureScale(paramName)) { return; }
            Undo.RecordObject(material, material.name + " " + paramName + " Changed");
            material.SetTextureScale(paramName, value);
        }

        public static void SetVector(Material material, string paramName, Vector3 value) {
            var tmpValue = new Vector4(value.x, value.y, value.z, 1);
            SetVector(material, paramName, tmpValue);
        }

        public static void SetVector(Material material, string paramName, Vector4 value) {
            if (value == material.GetVector(paramName)) { return; }
            Undo.RecordObject(material, material.name + " " + paramName + " Changed");
            material.SetVector(paramName, value);
        }

        public static void SetVectorArray(Material material, string paramName, Vector4[] value) {
            if (value == material.GetVectorArray(paramName)) { return; }
            Undo.RecordObject(material, material.name + " " + paramName + " Changed");
            material.SetVectorArray(paramName, value);
        }

        public static void SetKeyword(Material material, string keyword, bool state) {
            if (state) {
                Undo.RecordObject(material, material.name + " " + keyword + " Changed");
                material.EnableKeyword(keyword);

            } else {
                Undo.RecordObject(material, material.name + " " + keyword + " Changed");
                material.DisableKeyword(keyword);
            }
        }

        public static void SetOverrideTag(Material material, string paramName, string value) {
            Undo.RecordObject(material, material.name + " " + paramName + " Changed");
            material.SetOverrideTag(paramName, value);
        }

        public static void SetRenderQueue(Material material, int value) {
            if (value == material.renderQueue) { return; }
            Undo.RecordObject(material, material.name + " RenderQueue Changed");
            material.renderQueue = value;
        }

        public static void SetShaderPassEnabled(Material material, string paramName, bool value) {
            if (value == material.GetShaderPassEnabled(paramName)) { return; }
            Undo.RecordObject(material, material.name + " " + paramName + " Changed");
            material.SetShaderPassEnabled(paramName, value);
        }

        public static void SetShader(Material material, string shaderName) {
            if (material.shader == Shader.Find(shaderName)) { return; }
            Undo.RecordObject(material, material.name + " " + shaderName + " Changed");
            material.shader = Shader.Find(shaderName);
        }

    }

}