// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

#ifndef UNITY_STANDARD_CORE_INCLUDED
#define UNITY_STANDARD_CORE_INCLUDED

#include "UnityCG.cginc"
#include "UnityStandardInput_Lite.cginc"

#include "AutoLight.cginc"

//-------------------------------------------------------------------------------------
UnityLight MainLight ()
{
		UnityLight l;

		l.color = _LightColor0.rgb;
		l.dir = _WorldSpaceLightPos0.xyz;
		return l;
}

UnityLight AdditiveLight (half3 lightDir, half atten)
{
		UnityLight l;

		l.color = _LightColor0.rgb;
		l.dir = lightDir;
		#ifndef USING_DIRECTIONAL_LIGHT
				l.dir = normalize(l.dir);
		#endif

		// shadow the light
		l.color *= atten;
		return l;
}

UnityIndirect ZeroIndirect ()
{
		UnityIndirect ind;
		ind.diffuse = 0;
		ind.specular = 0;
		return ind;
}

//-------------------------------------------------------------------------------------

struct FragmentCommonData
{
		half3 diffColor, specColor;
		// Note: smoothness & oneMinusReflectivity for optimization purposes, mostly for DX9 SM2.0 level.
		// Most of the math is being done on these (1-x) values, and that saves a few precious ALU slots.
		half oneMinusReflectivity, smoothness;
		float3 normalWorld;
		float3 eyeVec;
		half alpha;
		float3 posWorld;
};

struct VertexOutputForwardBase
{
		UNITY_POSITION(pos);
		float4 tex                            : TEXCOORD0;
		float3 eyeVec                         : TEXCOORD1;
		float4 tangentToWorldAndPackedData[3] : TEXCOORD2;    // [3x3:tangentToWorld | 1x3:viewDirForParallax or worldPos]
		half4 ambientOrLightmapUV             : TEXCOORD5;    // SH or Lightmap UV
		UNITY_SHADOW_COORDS(6)
		float3 posWorld                 			: TEXCOORD8;

		UNITY_VERTEX_INPUT_INSTANCE_ID
		UNITY_VERTEX_OUTPUT_STEREO
};

//-------------------------------------------------------------------------------------
// Common fragment setup

inline float3 PerPixelWorldNormal(float4 i_tex, float4 tangentToWorld[3])
{
#ifdef _NORMALMAP
		half3 tangent = tangentToWorld[0].xyz;
		half3 binormal = tangentToWorld[1].xyz;
		half3 normal = tangentToWorld[2].xyz;
		half3 normalTangent = NormalInTangentSpace(i_tex);
		float3 normalWorld = normalize(tangent * normalTangent.x + binormal * normalTangent.y + normal * normalTangent.z); // @TODO: see if we can squeeze this normalize on SM2.0 as well
#else
		float3 normalWorld = normalize(tangentToWorld[2].xyz);
#endif
		return normalWorld;
}

#define IN_LIGHTDIR_FWDADD(i) half3(i.tangentToWorldAndLightDir[0].w, i.tangentToWorldAndLightDir[1].w, i.tangentToWorldAndLightDir[2].w)

#ifndef UNITY_SETUP_BRDF_INPUT
		#define UNITY_SETUP_BRDF_INPUT SpecularSetup
#endif

inline FragmentCommonData SpecularSetup (float4 i_tex, half3 albedo)
{
		half4 specGloss = SpecularGloss(i_tex.xy);
		half3 specColor = specGloss.rgb;
		half smoothness = specGloss.a;

		half oneMinusReflectivity;
		half3 diffColor = EnergyConservationBetweenDiffuseAndSpecular (albedo, specColor, /*out*/ oneMinusReflectivity);

		FragmentCommonData o = (FragmentCommonData)0;
		o.diffColor = diffColor;
		o.specColor = specColor;
		o.oneMinusReflectivity = oneMinusReflectivity;
		o.smoothness = smoothness;
		return o;
}

inline FragmentCommonData RoughnessSetup(float4 i_tex, half3 albedo)
{
		half2 metallicGloss = MetallicRough(i_tex.xy);
		half metallic = metallicGloss.x;
		half smoothness = metallicGloss.y; // this is 1 minus the square root of real roughness m.

		half oneMinusReflectivity;
		half3 specColor;
		half3 diffColor = DiffuseAndSpecularFromMetallic(albedo, metallic, /*out*/ specColor, /*out*/ oneMinusReflectivity);

		FragmentCommonData o = (FragmentCommonData)0;
		o.diffColor = diffColor;
		o.specColor = specColor;
		o.oneMinusReflectivity = oneMinusReflectivity;
		o.smoothness = smoothness;
		return o;
}

inline FragmentCommonData MetallicSetup (float4 i_tex, half3 albedo)
{
		half2 metallicGloss = MetallicGloss(i_tex.xy);
		half metallic = metallicGloss.x;
		half smoothness = metallicGloss.y; // this is 1 minus the square root of real roughness m.

		half oneMinusReflectivity;
		half3 specColor;
		half3 diffColor = DiffuseAndSpecularFromMetallic (albedo, metallic, /*out*/ specColor, /*out*/ oneMinusReflectivity);

		FragmentCommonData o = (FragmentCommonData)0;
		o.diffColor = diffColor;
		o.specColor = specColor;
		o.oneMinusReflectivity = oneMinusReflectivity;
		o.smoothness = smoothness;
		return o;
}

// parallax transformed texcoord is used to sample occlusion 
inline FragmentCommonData FragmentSetup (inout float4 i_tex, half3 albedo, float3 i_eyeVec, float4 tangentToWorld[3], float3 i_posWorld)
{
		half alpha = Alpha(i_tex.xy);
		#if defined(_ALPHATEST_ON)
				clip (alpha - _Cutoff);
		#endif

		FragmentCommonData o = UNITY_SETUP_BRDF_INPUT (i_tex, albedo);
		o.normalWorld = PerPixelWorldNormal(i_tex, tangentToWorld);
		o.eyeVec = normalize(i_eyeVec);
		o.posWorld = i_posWorld;

		// NOTE: shader relies on pre-multiply alpha-blend (_SrcBlend = One, _DstBlend = OneMinusSrcAlpha)
		o.diffColor = PreMultiplyAlpha (o.diffColor, alpha, o.oneMinusReflectivity, /*out*/ o.alpha);
		return o;
}

inline UnityGI FragmentGI (FragmentCommonData s, half occlusion, half4 i_ambientOrLightmapUV, half atten, UnityLight light)
{
		UnityGIInput d;
		d.light = light;
		d.worldPos = s.posWorld;
		d.worldViewDir = -s.eyeVec;
		d.atten = atten;
		#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
				d.ambient = 0;
				d.lightmapUV = i_ambientOrLightmapUV;
		#else
				d.ambient = i_ambientOrLightmapUV.rgb;
				d.lightmapUV = 0;
		#endif

		d.probeHDR[0] = unity_SpecCube0_HDR;
		d.probeHDR[1] = unity_SpecCube1_HDR;
		#if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
			d.boxMin[0] = unity_SpecCube0_BoxMin; // .w holds lerp value for blending
		#endif
		#ifdef UNITY_SPECCUBE_BOX_PROJECTION
			d.boxMax[0] = unity_SpecCube0_BoxMax;
			d.probePosition[0] = unity_SpecCube0_ProbePosition;
			d.boxMax[1] = unity_SpecCube1_BoxMax;
			d.boxMin[1] = unity_SpecCube1_BoxMin;
			d.probePosition[1] = unity_SpecCube1_ProbePosition;
		#endif

	 Unity_GlossyEnvironmentData g = UnityGlossyEnvironmentSetup(s.smoothness, -s.eyeVec, s.normalWorld, s.specColor);
	 return UnityGlobalIllumination (d, occlusion, s.normalWorld, g);
}

//-------------------------------------------------------------------------------------
half4 OutputForward (half4 output, half alphaFromSurface)
{
		#if defined(_ALPHABLEND_ON) || defined(_ALPHAPREMULTIPLY_ON)
				output.a = alphaFromSurface;
		#else
				UNITY_OPAQUE_ALPHA(output.a);
		#endif
		return output;
}

inline half4 VertexGIForward(float2 uv1, float2 uv2, float3 posWorld, half3 normalWorld)
{
		half4 ambientOrLightmapUV = 0;
		// Static lightmaps
		#ifdef LIGHTMAP_ON
				ambientOrLightmapUV.xy = uv1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				ambientOrLightmapUV.zw = 0;
		// Sample light probe for Dynamic objects only (no static or dynamic lightmaps)
		#elif UNITY_SHOULD_SAMPLE_SH
				#ifdef VERTEXLIGHT_ON
						// Approximated illumination from non-important point lights
						ambientOrLightmapUV.rgb = Shade4PointLights (
								unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
								unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
								unity_4LightAtten0, posWorld, normalWorld);
				#endif

				ambientOrLightmapUV.rgb = ShadeSHPerVertex (normalWorld, ambientOrLightmapUV.rgb);
		#endif

		#ifdef DYNAMICLIGHTMAP_ON
				ambientOrLightmapUV.zw = uv2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
		#endif

		return ambientOrLightmapUV;
}

// ------------------------------------------------------------------
//  Base forward pass (directional light, emission, lightmaps, ...)
inline VertexOutputForwardBase vertForwardBase (VertexInput v)
{
		UNITY_SETUP_INSTANCE_ID(v);
		VertexOutputForwardBase o;
		UNITY_INITIALIZE_OUTPUT(VertexOutputForwardBase, o);
		UNITY_TRANSFER_INSTANCE_ID(v, o);
		UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

		float4 posWorld = mul(unity_ObjectToWorld, v.vertex);
		o.posWorld = posWorld.xyz;
		o.pos = UnityObjectToClipPos(v.vertex);

		o.tex = TexCoords(v);
		o.eyeVec = normalize(posWorld.xyz - _WorldSpaceCameraPos);
		float3 normalWorld = UnityObjectToWorldNormal(v.normal);
		#ifdef _TANGENT_TO_WORLD
				float4 tangentWorld = float4(UnityObjectToWorldDir(v.tangent.xyz), v.tangent.w);

				float3x3 tangentToWorld = CreateTangentToWorldPerVertex(normalWorld, tangentWorld.xyz, tangentWorld.w);
				o.tangentToWorldAndPackedData[0].xyz = tangentToWorld[0];
				o.tangentToWorldAndPackedData[1].xyz = tangentToWorld[1];
				o.tangentToWorldAndPackedData[2].xyz = tangentToWorld[2];
		#else
				o.tangentToWorldAndPackedData[0].xyz = 0;
				o.tangentToWorldAndPackedData[1].xyz = 0;
				o.tangentToWorldAndPackedData[2].xyz = normalWorld;
		#endif

		//We need this for shadow receving
		UNITY_TRANSFER_SHADOW(o, v.uv1);

		#if defined(DYNAMICLIGHTMAP_ON) || defined(UNITY_PASS_META)
			o.ambientOrLightmapUV = VertexGIForward(v.uv1, v.uv2, posWorld, normalWorld);
		#else
			o.ambientOrLightmapUV = VertexGIForward(v.uv1, v.uv1, posWorld, normalWorld);
		#endif

		return o;
}

inline half4 fragForwardBaseInternal (VertexOutputForwardBase i)
{
		FragmentCommonData s = FragmentSetup(i.tex, Albedo(i.tex), i.eyeVec, i.tangentToWorldAndPackedData, i.posWorld);

		UNITY_SETUP_INSTANCE_ID(i);
		UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);

		UnityLight mainLight = MainLight ();
		UNITY_LIGHT_ATTENUATION(atten, i, s.posWorld);
		return half4(1,1,1,1);

		UnityGI gi = FragmentGI (s, 1, i.ambientOrLightmapUV, atten, mainLight);

		half4 c = UNITY_BRDF_PBS (s.diffColor, s.specColor, s.oneMinusReflectivity, s.smoothness, s.normalWorld, -s.eyeVec, gi.light, gi.indirect);

		return OutputForward (c, s.alpha);
}

half4 fragForwardBase (VertexOutputForwardBase i) : SV_Target   // backward compatibility (this used to be the fragment entry function)
{
		return fragForwardBaseInternal(i);
}

// ------------------------------------------------------------------
//  Additive forward pass (one light per pass)

struct VertexOutputForwardAdd
{
		UNITY_POSITION(pos);
		float4 tex                          : TEXCOORD0;
		float3 eyeVec                       : TEXCOORD1;
		float4 tangentToWorldAndLightDir[3] : TEXCOORD2;    // [3x3:tangentToWorld | 1x3:lightDir]
		float3 posWorld                     : TEXCOORD5;
		UNITY_SHADOW_COORDS(6)

		UNITY_VERTEX_OUTPUT_STEREO
};

VertexOutputForwardAdd vertForwardAdd (VertexInput v)
{
		UNITY_SETUP_INSTANCE_ID(v);
		VertexOutputForwardAdd o;
		UNITY_INITIALIZE_OUTPUT(VertexOutputForwardAdd, o);
		UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

		float4 posWorld = mul(unity_ObjectToWorld, v.vertex);
		o.pos = UnityObjectToClipPos(v.vertex);

		o.tex = TexCoords(v);
		o.eyeVec = normalize(posWorld.xyz - _WorldSpaceCameraPos);
		o.posWorld = posWorld.xyz;
		float3 normalWorld = UnityObjectToWorldNormal(v.normal);
		#ifdef _TANGENT_TO_WORLD
				float4 tangentWorld = float4(UnityObjectToWorldDir(v.tangent.xyz), v.tangent.w);

				float3x3 tangentToWorld = CreateTangentToWorldPerVertex(normalWorld, tangentWorld.xyz, tangentWorld.w);
				o.tangentToWorldAndLightDir[0].xyz = tangentToWorld[0];
				o.tangentToWorldAndLightDir[1].xyz = tangentToWorld[1];
				o.tangentToWorldAndLightDir[2].xyz = tangentToWorld[2];
		#else
				o.tangentToWorldAndLightDir[0].xyz = 0;
				o.tangentToWorldAndLightDir[1].xyz = 0;
				o.tangentToWorldAndLightDir[2].xyz = normalWorld;
		#endif
		//We need this for shadow receiving
		UNITY_TRANSFER_SHADOW(o, v.uv1);

		float3 lightDir = _WorldSpaceLightPos0.xyz - posWorld.xyz * _WorldSpaceLightPos0.w;
		#ifndef USING_DIRECTIONAL_LIGHT
				lightDir = normalize(lightDir);
		#endif
		o.tangentToWorldAndLightDir[0].w = lightDir.x;
		o.tangentToWorldAndLightDir[1].w = lightDir.y;
		o.tangentToWorldAndLightDir[2].w = lightDir.z;
		return o;
}

half4 fragForwardAddInternal (VertexOutputForwardAdd i)
{
		UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);

		FragmentCommonData s = FragmentSetup(i.tex, Albedo(i.tex), i.eyeVec, i.tangentToWorldAndLightDir, i.posWorld);

		UNITY_LIGHT_ATTENUATION(atten, i, s.posWorld)

		UnityLight light = AdditiveLight (IN_LIGHTDIR_FWDADD(i), atten);
		UnityIndirect noIndirect = ZeroIndirect ();

		half4 c = UNITY_BRDF_PBS (s.diffColor, s.specColor, s.oneMinusReflectivity, s.smoothness, s.normalWorld, -s.eyeVec, light, noIndirect);

		return OutputForward (c, s.alpha);
}

half4 fragForwardAdd (VertexOutputForwardAdd i) : SV_Target     // backward compatibility (this used to be the fragment entry function)
{
		return fragForwardAddInternal(i);
}

#endif // UNITY_STANDARD_CORE_INCLUDED
