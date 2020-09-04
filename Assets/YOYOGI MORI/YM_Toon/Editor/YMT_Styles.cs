using UnityEngine;

namespace YoyogiMori {
    public static class Styles {
        public static GUIContent baseColorText = new GUIContent ("BaseMap", "Base Color : Texture(sRGB) × Color(RGB) Default:White");
        public static GUIContent firstShadeColorText = new GUIContent ("1st ShadeMap", "1st ShadeColor : Texture(sRGB) × Color(RGB) Default:White");
        public static GUIContent secondShadeColorText = new GUIContent ("2nd ShadeMap", "2nd ShadeColor : Texture(sRGB) × Color(RGB) Default:White");
        public static GUIContent normalMapText = new GUIContent ("NormalMap", "NormalMap : Texture(bump)");
        public static GUIContent highColorText = new GUIContent ("HighColor", "High Color : Texture(sRGB) × Color(RGB) Default:Black");
        public static GUIContent emissiveTexText = new GUIContent ("Emissive", "Emissive : Texture(sRGB)× EmissiveMask(alpha) × Color(HDR) Default:Black");
        public static GUIContent outlineTexText = new GUIContent ("Outline Map", "Outline Tex : Texture(sRGB) Default:White");
        public static GUIContent bakedNormalOutlineText = new GUIContent ("Baked NormalMap for Outline", "Unpacked Normal Map : Texture(linear) ※通常のノーマルマップではないので注意");

        public static GUIContent metallicGlossMapText = new GUIContent ("MetallicGlossMap", "MetallicGlossMap : Texture");
        public static GUIContent emissionMapText = new GUIContent ("EmissionMap", "EmissionMap : Texture");
        public static GUIContent highlightsText = new GUIContent ("Specular Highlights", "Specular Highlights");
        public static GUIContent reflectionsText = new GUIContent ("Reflections", "Glossy Reflections");

        public static GUIContent metallicMapText = new GUIContent ("Metallic", "Metallic (R) and Smoothness (A)");
        public static GUIContent glossinessText = new GUIContent ("Smoothness", "Smoothness value");
        public static GUIContent glossMapScaleText = new GUIContent ("Smoothness", "Smoothness scale factor");
        public static GUIContent smoothnessTextureChannelText = new GUIContent ("Source", "Smoothness texture and channel");
        public static GUIContent combinedMaskText = new GUIContent ("Combined Masks", "R: RimLightMask, G: Outline Sampler , B: SSS Mask, A: Metalic Mask");

    }
}