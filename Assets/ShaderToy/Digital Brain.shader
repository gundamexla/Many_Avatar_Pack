//Converted from Shadertoy by Doppelgänger#8376
//Original shader is https://www.shadertoy.com/view/4sl3Dr
Shader "Custom/Digital Brain Parallax"{
	Properties
	{
	[Header(Main Texture)]
	[Space]
	_MainTex("Main Texture", 2D) = "black" {}
	[HDR]_Colormt("Main Texture tint", Color) = (1,1,1,1)
	[Header(Digital Brain)]
	[Space]
	_Noise("Noise (RGB)", 2D) = "white" {}
	_PSpeed("Noise Panner Speed", float) = 0.01
	[HDR]_Color("Noise Map Color", Color) = (1,1,1,1)
	[HDR]_Colorm("Digital Brain Color", Color) = (1,1,1,1)
	_finalcol("Final Color", float) = 1
	_steps("Detail", range(2,5)) = 4
	_depth("Depth", float) = 0.5
	[Space]
	_Zoom("Zoom", float) = 1
	_uvx("Resize x", range(0,10)) = 0
	_uvy("Resize y", range(0,10)) = 0
	_uvox("Offset x", float) = 0
	_uvoy("Offset y", float) = 0
	}
	SubShader 
	{
		Tags {"Queue" = "Geometry" "IgnoreProjector" = "True" }
		LOD 100
		Pass 
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _Noise;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform float4 _Noise_ST;
			uniform float4 _Color;
			uniform float4 _Colorm;
			uniform float4 _Colormt;
			uniform int _steps;
			uniform float _uvx;
			uniform float _uvy;
			uniform float _uvoy;
			uniform float _uvox;
			uniform float _Zoom;
			uniform float _finalcol;
			uniform float _PSpeed;
			uniform float _Alpha;
			uniform float _depth;

			struct appdata
			{
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 normalDir : TEXCOORD1;
                float3 tangentDir : TEXCOORD2;
                float3 bitangentDir : TEXCOORD3;
                float4 posWorld : TEXCOORD4;

			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize(mul(unity_ObjectToWorld, float4(v.tangent.xyz,0.0)).xyz);
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
				o.uv = v.texcoord;
				return o;
			}

			float2 rotate(float2 p, float a)
			{
				return float2(p.x * cos(a) - p.y * sin(a), p.x * sin(a) + p.y * cos(a));
			}


			float rand(float n)
			{
    			return frac(sin(n) * 43758.5453123);
			}


			float2 rand2(in float2 p)
			{
				return frac(float2(sin(p.x * 591.32 + p.y * 154.077), cos(p.x * 391.32 + p.y * 49.077)));
			}

			float noise1(float p)
			{
				float fl = floor(p);
				float fc = frac(p);
				return lerp(rand(fl), rand(fl + 1.0), fc);
			}

			float voronoi(in float2 x)
			{
				float2 p = floor(x);
				float2 f = frac(x);
				float2 res = float2(8.0,8.0);
				for(int j = -1; j <= 1; j ++)
				{
					for(int i = -1; i <= 1; i ++)
					{
						float2 b = float2(i, j);
						float2 r = float2(b) - f + rand2(p + b);
						float d = max(abs(r.x), abs(r.y));
			
						if(d < res.x)
						{
							res.y = res.x;
							res.x = d;
						}
						else if(d < res.y)
						{
							res.y = d;
						}
					}
				}
				return (res.y - res.x);
			}

			float4 frag(v2f i) : SV_Target 
			{
				float3x3 m = float3x3(i.tangentDir, i.bitangentDir, normalize(i.normalDir));
    			float3 vdir = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);

    			float2 uv = (i.uv)*_Zoom-0.5*_Zoom;
    			float2 mtuv = i.uv * _MainTex_ST.xy + _MainTex_ST.zw;

				uv.x *= 1 + _uvx;
				uv.y *= 1 + _uvy;
				uv.x += _uvox;
    			uv.y += _uvoy;

    			float flicker = noise1(_Time.y*0.5 * 2.0) * 0.8 + 0.4;

				float v = 0.1;
				float a = 0.6; 
    			float f = 1.0;
				float s = 0;

				for(int i = 0; i < _steps; i ++)
				{	
					float v1 = voronoi((((s*(-0.5)*mul(m, vdir).xy + uv).xy - 1)) * f + 5.0);
					float v2 = 0.0;
					if(i > 0)
					{
						v2 = voronoi((((s*(-0.5)*mul(m, vdir).xy + uv).xy - 1)) * f * 0.5 + 50.0 + _Time.y*0.5);
						float va = 0.0, vb = 0.0;
						va = 1.0 - smoothstep(0.0, 0.1, v1);
						vb = 1.0 - smoothstep(0.0, 0.08, v2);
						v += a * pow(va * (0.5 + vb), 2.0);
					}
					v1 = 1.0 - smoothstep(0.0, 0.3, v1);
					v2 = a * (noise1(v1 * 5.5 + 0.1));
					if(i == 0)
						v += v2 * flicker;
					else
						v += v2;
					f *= 3.0;
					a *= 0.7;
					s += _depth/_steps;
				}

				float3 cexp = (tex2D(_Noise, uv * 0.001 * _Noise_ST.xy + _Noise_ST.zw + _Time.y*0.5*_PSpeed).xyz * 3.0 + tex2D(_Noise, uv * 0.01 + _Time.y*0.5*_PSpeed).xyz)*_Color.xyz;

				float3 col = float3(pow(v, cexp.x), pow(v, cexp.y), pow(v, cexp.z))*_Colorm.xyz;
				col += tex2D(_MainTex, mtuv).rgb*_Colormt.rgb;
	
				return saturate(float4(col*_finalcol, 1));
			}
			ENDCG
		}
	}
}