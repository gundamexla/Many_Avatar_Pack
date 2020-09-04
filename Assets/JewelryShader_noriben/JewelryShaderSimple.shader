// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:False,igpj:True,qofs:500,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:3138,x:33816,y:33153,varname:node_3138,prsc:2|emission-3830-OUT,custl-922-OUT,alpha-8918-OUT,refract-7096-OUT;n:type:ShaderForge.SFN_Color,id:2210,x:32703,y:33154,ptovrint:False,ptlb:BaseColor,ptin:_BaseColor,varname:_BaseColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.1629001,c2:0.1650012,c3:0.1691176,c4:1;n:type:ShaderForge.SFN_Color,id:3042,x:32703,y:33322,ptovrint:False,ptlb:AroundColor,ptin:_AroundColor,varname:_AroundColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0,c2:0,c3:0,c4:1;n:type:ShaderForge.SFN_Lerp,id:608,x:33003,y:33223,varname:node_608,prsc:2|A-2210-RGB,B-3042-RGB,T-4802-OUT;n:type:ShaderForge.SFN_Fresnel,id:4802,x:32655,y:33478,varname:node_4802,prsc:2|EXP-5354-OUT;n:type:ShaderForge.SFN_Multiply,id:9059,x:32903,y:33682,varname:node_9059,prsc:2|A-4802-OUT,B-5354-OUT;n:type:ShaderForge.SFN_TexCoord,id:1492,x:32903,y:33534,varname:node_1492,prsc:2,uv:0,uaff:True;n:type:ShaderForge.SFN_Multiply,id:7096,x:33160,y:33553,varname:node_7096,prsc:2|A-1492-V,B-9059-OUT;n:type:ShaderForge.SFN_NormalVector,id:8823,x:31060,y:35006,prsc:2,pt:False;n:type:ShaderForge.SFN_Negate,id:1834,x:31222,y:35006,varname:node_1834,prsc:2|IN-8823-OUT;n:type:ShaderForge.SFN_SceneColor,id:3336,x:32709,y:34349,varname:node_3336,prsc:2|UVIN-522-OUT;n:type:ShaderForge.SFN_Transform,id:8445,x:31403,y:35006,varname:node_8445,prsc:2,tffrom:1,tfto:3|IN-1834-OUT;n:type:ShaderForge.SFN_ComponentMask,id:9454,x:31773,y:34748,varname:node_9454,prsc:2,cc1:0,cc2:-1,cc3:-1,cc4:-1|IN-4641-OUT;n:type:ShaderForge.SFN_Multiply,id:3603,x:32328,y:34349,varname:node_3603,prsc:2|A-9454-OUT,B-3316-OUT;n:type:ShaderForge.SFN_Fresnel,id:3316,x:32015,y:34371,varname:node_3316,prsc:2|EXP-6293-OUT;n:type:ShaderForge.SFN_Slider,id:1819,x:31156,y:34025,ptovrint:False,ptlb:Aberration,ptin:_Aberration,varname:_Aberration,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.0105,max:1;n:type:ShaderForge.SFN_SceneColor,id:9686,x:32709,y:34102,varname:node_9686,prsc:2|UVIN-9950-OUT;n:type:ShaderForge.SFN_Multiply,id:9735,x:32328,y:34102,varname:node_9735,prsc:2|A-9454-OUT,B-696-OUT;n:type:ShaderForge.SFN_Fresnel,id:696,x:32015,y:34129,varname:node_696,prsc:2|EXP-6293-OUT;n:type:ShaderForge.SFN_SceneColor,id:8400,x:32709,y:33854,varname:node_8400,prsc:2|UVIN-9733-OUT;n:type:ShaderForge.SFN_Multiply,id:963,x:32328,y:33854,varname:node_963,prsc:2|A-9454-OUT,B-8240-OUT;n:type:ShaderForge.SFN_Fresnel,id:8240,x:32015,y:33878,varname:node_8240,prsc:2|EXP-6293-OUT;n:type:ShaderForge.SFN_Add,id:9733,x:32524,y:33854,varname:node_9733,prsc:2|A-963-OUT,B-7642-UVOUT,C-5430-OUT;n:type:ShaderForge.SFN_ScreenPos,id:7642,x:32011,y:34748,varname:node_7642,prsc:2,sctp:2;n:type:ShaderForge.SFN_Append,id:9070,x:32912,y:34124,varname:node_9070,prsc:2|A-8400-R,B-9686-G,C-3336-B;n:type:ShaderForge.SFN_Add,id:9950,x:32524,y:34102,varname:node_9950,prsc:2|A-9735-OUT,B-7642-UVOUT,C-8574-OUT;n:type:ShaderForge.SFN_Add,id:522,x:32524,y:34349,varname:node_522,prsc:2|A-3603-OUT,B-7642-UVOUT,C-8574-OUT;n:type:ShaderForge.SFN_NormalVector,id:7058,x:30940,y:33070,prsc:2,pt:False;n:type:ShaderForge.SFN_Tex2d,id:2723,x:32447,y:32817,ptovrint:False,ptlb:Matcap_Tex,ptin:_Matcap_Tex,varname:_Matcap_Tex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-9528-OUT;n:type:ShaderForge.SFN_Add,id:3884,x:33190,y:33203,varname:node_3884,prsc:2|A-1110-OUT,B-608-OUT;n:type:ShaderForge.SFN_Slider,id:3379,x:32369,y:33007,ptovrint:False,ptlb:MatcapPower,ptin:_MatcapPower,varname:_MatcapPower,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.0612652,max:2;n:type:ShaderForge.SFN_Multiply,id:8334,x:32708,y:32817,varname:node_8334,prsc:2|A-2723-RGB,B-3379-OUT;n:type:ShaderForge.SFN_ViewVector,id:5371,x:31060,y:34748,varname:node_5371,prsc:2;n:type:ShaderForge.SFN_Vector3,id:6481,x:31220,y:34914,varname:node_6481,prsc:2,v1:-1,v2:-1,v3:1;n:type:ShaderForge.SFN_Transform,id:3442,x:31220,y:34748,varname:node_3442,prsc:2,tffrom:0,tfto:3|IN-5371-OUT;n:type:ShaderForge.SFN_Multiply,id:4660,x:31404,y:34748,varname:node_4660,prsc:2|A-3442-XYZ,B-6481-OUT;n:type:ShaderForge.SFN_NormalBlend,id:4641,x:31591,y:34748,varname:node_4641,prsc:2|BSE-4660-OUT,DTL-8445-XYZ;n:type:ShaderForge.SFN_Transform,id:5022,x:31127,y:33070,varname:node_5022,prsc:2,tffrom:0,tfto:3|IN-7058-OUT;n:type:ShaderForge.SFN_ViewVector,id:9498,x:30751,y:32819,varname:node_9498,prsc:2;n:type:ShaderForge.SFN_Vector3,id:7971,x:30940,y:32985,varname:node_7971,prsc:2,v1:-1,v2:-1,v3:1;n:type:ShaderForge.SFN_Transform,id:8328,x:30940,y:32819,varname:node_8328,prsc:2,tffrom:0,tfto:3|IN-9498-OUT;n:type:ShaderForge.SFN_Multiply,id:8558,x:31124,y:32819,varname:node_8558,prsc:2|A-8328-XYZ,B-7971-OUT;n:type:ShaderForge.SFN_NormalBlend,id:7730,x:31330,y:32819,varname:node_7730,prsc:2|BSE-8558-OUT,DTL-5022-XYZ;n:type:ShaderForge.SFN_ComponentMask,id:3239,x:31509,y:32819,varname:node_3239,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-7730-OUT;n:type:ShaderForge.SFN_Color,id:6557,x:32912,y:33976,ptovrint:False,ptlb:DarkenColor,ptin:_DarkenColor,varname:_DarkenColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:922,x:33085,y:33976,varname:node_922,prsc:2|A-6557-RGB,B-9070-OUT;n:type:ShaderForge.SFN_Vector1,id:6293,x:31687,y:34156,varname:node_6293,prsc:2,v1:2;n:type:ShaderForge.SFN_Vector1,id:8574,x:31301,y:34286,varname:node_8574,prsc:2,v1:0.2;n:type:ShaderForge.SFN_Vector1,id:5354,x:32114,y:33491,varname:node_5354,prsc:2,v1:3;n:type:ShaderForge.SFN_Vector1,id:8918,x:33246,y:33353,varname:node_8918,prsc:2,v1:1;n:type:ShaderForge.SFN_Add,id:5430,x:31711,y:33926,varname:node_5430,prsc:2|A-1819-OUT,B-8574-OUT;n:type:ShaderForge.SFN_Multiply,id:2897,x:31767,y:32816,varname:node_2897,prsc:2|A-3239-OUT,B-3308-OUT;n:type:ShaderForge.SFN_Add,id:9528,x:32035,y:32815,varname:node_9528,prsc:2|A-2897-OUT,B-3308-OUT;n:type:ShaderForge.SFN_Vector1,id:3308,x:31584,y:33050,varname:node_3308,prsc:2,v1:0.5;n:type:ShaderForge.SFN_LightColor,id:8744,x:33190,y:32992,varname:node_8744,prsc:2;n:type:ShaderForge.SFN_Multiply,id:3830,x:33574,y:33202,varname:node_3830,prsc:2|A-3538-OUT,B-3884-OUT;n:type:ShaderForge.SFN_Lerp,id:3538,x:33377,y:33064,varname:node_3538,prsc:2|A-8744-RGB,B-6338-OUT,T-6338-OUT;n:type:ShaderForge.SFN_Vector1,id:6338,x:33190,y:33125,varname:node_6338,prsc:2,v1:0.5;n:type:ShaderForge.SFN_Tex2d,id:3311,x:32447,y:32516,ptovrint:False,ptlb:Matcap_Tex2,ptin:_Matcap_Tex2,varname:_Matcap_Tex2,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-9528-OUT;n:type:ShaderForge.SFN_Multiply,id:3378,x:32712,y:32516,varname:node_3378,prsc:2|A-3311-RGB,B-2384-OUT;n:type:ShaderForge.SFN_Slider,id:2384,x:32369,y:32700,ptovrint:False,ptlb:MatcapPower2,ptin:_MatcapPower2,varname:_MatcapPower2,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.2033138,max:2;n:type:ShaderForge.SFN_Add,id:1110,x:32907,y:32702,varname:node_1110,prsc:2|A-3378-OUT,B-8334-OUT;proporder:2210-3042-6557-1819-2723-3379-3311-2384;pass:END;sub:END;*/

Shader "Noriben/JewelryShaderSimple" {
    Properties {
        _BaseColor ("BaseColor", Color) = (0.1629001,0.1650012,0.1691176,1)
        _AroundColor ("AroundColor", Color) = (0,0,0,1)
        _DarkenColor ("DarkenColor", Color) = (1,1,1,1)
        _Aberration ("Aberration", Range(0, 1)) = 0.0105
        _Matcap_Tex ("Matcap_Tex", 2D) = "white" {}
        _MatcapPower ("MatcapPower", Range(0, 2)) = 0.0612652
        _Matcap_Tex2 ("Matcap_Tex2", 2D) = "white" {}
        _MatcapPower2 ("MatcapPower2", Range(0, 2)) = 0.2033138
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent+500"
            "RenderType"="Transparent"
        }
        GrabPass{ }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform sampler2D _GrabTexture;
            uniform float4 _BaseColor;
            uniform float4 _AroundColor;
            uniform float _Aberration;
            uniform sampler2D _Matcap_Tex; uniform float4 _Matcap_Tex_ST;
            uniform float _MatcapPower;
            uniform float4 _DarkenColor;
            uniform sampler2D _Matcap_Tex2; uniform float4 _Matcap_Tex2_ST;
            uniform float _MatcapPower2;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float4 projPos : TEXCOORD3;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float node_5354 = 3.0;
                float node_4802 = pow(1.0-max(0,dot(normalDirection, viewDirection)),node_5354);
                float node_7096 = (i.uv0.g*(node_4802*node_5354));
                float2 sceneUVs = (i.projPos.xy / i.projPos.w) + float2(node_7096,node_7096);
                float4 sceneColor = tex2D(_GrabTexture, sceneUVs);
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
////// Emissive:
                float node_6338 = 0.5;
                float3 node_7730_nrm_base = (mul( UNITY_MATRIX_V, float4(viewDirection,0) ).xyz.rgb*float3(-1,-1,1)) + float3(0,0,1);
                float3 node_7730_nrm_detail = mul( UNITY_MATRIX_V, float4(i.normalDir,0) ).xyz.rgb * float3(-1,-1,1);
                float3 node_7730_nrm_combined = node_7730_nrm_base*dot(node_7730_nrm_base, node_7730_nrm_detail)/node_7730_nrm_base.z - node_7730_nrm_detail;
                float3 node_7730 = node_7730_nrm_combined;
                float node_3308 = 0.5;
                float2 node_9528 = ((node_7730.rg*node_3308)+node_3308);
                float4 _Matcap_Tex2_var = tex2D(_Matcap_Tex2,TRANSFORM_TEX(node_9528, _Matcap_Tex2));
                float4 _Matcap_Tex_var = tex2D(_Matcap_Tex,TRANSFORM_TEX(node_9528, _Matcap_Tex));
                float3 emissive = (lerp(_LightColor0.rgb,float3(node_6338,node_6338,node_6338),node_6338)*(((_Matcap_Tex2_var.rgb*_MatcapPower2)+(_Matcap_Tex_var.rgb*_MatcapPower))+lerp(_BaseColor.rgb,_AroundColor.rgb,node_4802)));
                float3 node_4641_nrm_base = (mul( UNITY_MATRIX_V, float4(viewDirection,0) ).xyz.rgb*float3(-1,-1,1)) + float3(0,0,1);
                float3 node_4641_nrm_detail = UnityObjectToViewPos( float4((-1*i.normalDir),0) ).xyz.rgb * float3(-1,-1,1);
                float3 node_4641_nrm_combined = node_4641_nrm_base*dot(node_4641_nrm_base, node_4641_nrm_detail)/node_4641_nrm_base.z - node_4641_nrm_detail;
                float3 node_4641 = node_4641_nrm_combined;
                float node_9454 = node_4641.r;
                float node_6293 = 2.0;
                float node_8574 = 0.2;
                float3 finalColor = emissive + (_DarkenColor.rgb*float3(tex2D( _GrabTexture, ((node_9454*pow(1.0-max(0,dot(normalDirection, viewDirection)),node_6293))+sceneUVs.rg+(_Aberration+node_8574))).r,tex2D( _GrabTexture, ((node_9454*pow(1.0-max(0,dot(normalDirection, viewDirection)),node_6293))+sceneUVs.rg+node_8574)).g,tex2D( _GrabTexture, ((node_9454*pow(1.0-max(0,dot(normalDirection, viewDirection)),node_6293))+sceneUVs.rg+node_8574)).b));
                return fixed4(lerp(sceneColor.rgb, finalColor,1.0),1);
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform sampler2D _GrabTexture;
            uniform float4 _BaseColor;
            uniform float4 _AroundColor;
            uniform float _Aberration;
            uniform sampler2D _Matcap_Tex; uniform float4 _Matcap_Tex_ST;
            uniform float _MatcapPower;
            uniform float4 _DarkenColor;
            uniform sampler2D _Matcap_Tex2; uniform float4 _Matcap_Tex2_ST;
            uniform float _MatcapPower2;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float4 projPos : TEXCOORD3;
                LIGHTING_COORDS(4,5)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float node_5354 = 3.0;
                float node_4802 = pow(1.0-max(0,dot(normalDirection, viewDirection)),node_5354);
                float node_7096 = (i.uv0.g*(node_4802*node_5354));
                float2 sceneUVs = (i.projPos.xy / i.projPos.w) + float2(node_7096,node_7096);
                float4 sceneColor = tex2D(_GrabTexture, sceneUVs);
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float3 node_4641_nrm_base = (mul( UNITY_MATRIX_V, float4(viewDirection,0) ).xyz.rgb*float3(-1,-1,1)) + float3(0,0,1);
                float3 node_4641_nrm_detail = UnityObjectToViewPos( float4((-1*i.normalDir),0) ).xyz.rgb * float3(-1,-1,1);
                float3 node_4641_nrm_combined = node_4641_nrm_base*dot(node_4641_nrm_base, node_4641_nrm_detail)/node_4641_nrm_base.z - node_4641_nrm_detail;
                float3 node_4641 = node_4641_nrm_combined;
                float node_9454 = node_4641.r;
                float node_6293 = 2.0;
                float node_8574 = 0.2;
                float3 finalColor = (_DarkenColor.rgb*float3(tex2D( _GrabTexture, ((node_9454*pow(1.0-max(0,dot(normalDirection, viewDirection)),node_6293))+sceneUVs.rg+(_Aberration+node_8574))).r,tex2D( _GrabTexture, ((node_9454*pow(1.0-max(0,dot(normalDirection, viewDirection)),node_6293))+sceneUVs.rg+node_8574)).g,tex2D( _GrabTexture, ((node_9454*pow(1.0-max(0,dot(normalDirection, viewDirection)),node_6293))+sceneUVs.rg+node_8574)).b));
                return fixed4(finalColor * 1.0,0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
