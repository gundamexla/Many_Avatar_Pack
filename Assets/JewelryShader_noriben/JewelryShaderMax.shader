// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:3,bdst:7,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:False,igpj:True,qofs:500,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:3138,x:33585,y:33152,varname:node_3138,prsc:2|normal-173-OUT,emission-3884-OUT,custl-922-OUT,alpha-906-OUT,clip-2226-OUT,refract-7096-OUT,voffset-6034-OUT;n:type:ShaderForge.SFN_Color,id:2210,x:32703,y:33154,ptovrint:False,ptlb:BaseColor,ptin:_BaseColor,varname:node_7241,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.1629001,c2:0.1650012,c3:0.1691176,c4:1;n:type:ShaderForge.SFN_Color,id:3042,x:32703,y:33322,ptovrint:False,ptlb:AroundColor,ptin:_AroundColor,varname:_Color_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0,c2:0,c3:0,c4:1;n:type:ShaderForge.SFN_Lerp,id:608,x:33003,y:33223,varname:node_608,prsc:2|A-2210-RGB,B-3042-RGB,T-4802-OUT;n:type:ShaderForge.SFN_Fresnel,id:4802,x:32655,y:33478,varname:node_4802,prsc:2|EXP-8939-OUT;n:type:ShaderForge.SFN_Slider,id:8939,x:32316,y:33499,ptovrint:False,ptlb:Fresnel,ptin:_Fresnel,varname:node_8649,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:2.270563,max:3;n:type:ShaderForge.SFN_Slider,id:7507,x:32316,y:33633,ptovrint:False,ptlb:Refraction,ptin:_Refraction,varname:_node_8649_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:3,max:3;n:type:ShaderForge.SFN_Multiply,id:9059,x:32903,y:33682,varname:node_9059,prsc:2|A-4802-OUT,B-7507-OUT;n:type:ShaderForge.SFN_TexCoord,id:1492,x:32903,y:33534,varname:node_1492,prsc:2,uv:0,uaff:True;n:type:ShaderForge.SFN_Multiply,id:7096,x:33160,y:33553,varname:node_7096,prsc:2|A-1492-V,B-9059-OUT;n:type:ShaderForge.SFN_NormalVector,id:8823,x:31060,y:35006,prsc:2,pt:False;n:type:ShaderForge.SFN_Negate,id:1834,x:31222,y:35006,varname:node_1834,prsc:2|IN-8823-OUT;n:type:ShaderForge.SFN_SceneColor,id:3336,x:32709,y:34349,varname:node_3336,prsc:2|UVIN-522-OUT;n:type:ShaderForge.SFN_Transform,id:8445,x:31403,y:35006,varname:node_8445,prsc:2,tffrom:1,tfto:3|IN-1834-OUT;n:type:ShaderForge.SFN_ComponentMask,id:9454,x:31773,y:34748,varname:node_9454,prsc:2,cc1:0,cc2:-1,cc3:-1,cc4:-1|IN-4641-OUT;n:type:ShaderForge.SFN_Multiply,id:3603,x:32328,y:34349,varname:node_3603,prsc:2|A-9454-OUT,B-3316-OUT;n:type:ShaderForge.SFN_Fresnel,id:3316,x:32015,y:34371,varname:node_3316,prsc:2|EXP-5477-OUT;n:type:ShaderForge.SFN_Slider,id:5477,x:31667,y:34392,ptovrint:False,ptlb:Distortion_Blue,ptin:_Distortion_Blue,varname:node_3410,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:8,max:20;n:type:ShaderForge.SFN_Tex2d,id:6598,x:32736,y:32415,ptovrint:False,ptlb:Normal_Tex,ptin:_Normal_Tex,varname:_WaveNormal_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:cf97177fd8690c14c93f403f0ceae8ac,ntxv:3,isnm:True|UVIN-639-OUT;n:type:ShaderForge.SFN_Time,id:6217,x:32151,y:32454,varname:node_6217,prsc:2;n:type:ShaderForge.SFN_TexCoord,id:575,x:32151,y:32315,varname:node_575,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Panner,id:8158,x:32326,y:32355,varname:node_8158,prsc:2,spu:0,spv:0.1|UVIN-575-UVOUT,DIST-6217-T;n:type:ShaderForge.SFN_Slider,id:1819,x:32171,y:34012,ptovrint:False,ptlb:Aberration_Red,ptin:_Aberration_Red,varname:node_2275,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:-1,cur:0.024,max:1;n:type:ShaderForge.SFN_Slider,id:8746,x:32171,y:34517,ptovrint:False,ptlb:Aberration_Blue,ptin:_Aberration_Blue,varname:_FrenelRed_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:-1,cur:0.02,max:1;n:type:ShaderForge.SFN_Slider,id:8550,x:32171,y:34266,ptovrint:False,ptlb:Aberration_Green,ptin:_Aberration_Green,varname:_FrenelRed_copy_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:-1,cur:0.02,max:1;n:type:ShaderForge.SFN_SceneColor,id:9686,x:32709,y:34102,varname:node_9686,prsc:2|UVIN-9950-OUT;n:type:ShaderForge.SFN_Multiply,id:9735,x:32328,y:34102,varname:node_9735,prsc:2|A-9454-OUT,B-696-OUT;n:type:ShaderForge.SFN_Fresnel,id:696,x:32015,y:34129,varname:node_696,prsc:2|EXP-6722-OUT;n:type:ShaderForge.SFN_Slider,id:6722,x:31667,y:34150,ptovrint:False,ptlb:Distortion_Green,ptin:_Distortion_Green,varname:_Distortion_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:8,max:20;n:type:ShaderForge.SFN_SceneColor,id:8400,x:32709,y:33854,varname:node_8400,prsc:2|UVIN-9733-OUT;n:type:ShaderForge.SFN_Multiply,id:963,x:32328,y:33854,varname:node_963,prsc:2|A-9454-OUT,B-8240-OUT;n:type:ShaderForge.SFN_Fresnel,id:8240,x:32015,y:33878,varname:node_8240,prsc:2|EXP-8850-OUT;n:type:ShaderForge.SFN_Slider,id:8850,x:31667,y:33899,ptovrint:False,ptlb:Distortion_Red,ptin:_Distortion_Red,varname:_Distortion_copy_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:8,max:20;n:type:ShaderForge.SFN_Add,id:9733,x:32524,y:33854,varname:node_9733,prsc:2|A-963-OUT,B-7642-UVOUT,C-1819-OUT;n:type:ShaderForge.SFN_ScreenPos,id:7642,x:32011,y:34748,varname:node_7642,prsc:2,sctp:2;n:type:ShaderForge.SFN_Append,id:9070,x:32912,y:34124,varname:node_9070,prsc:2|A-8400-R,B-9686-G,C-3336-B;n:type:ShaderForge.SFN_Add,id:9950,x:32524,y:34102,varname:node_9950,prsc:2|A-9735-OUT,B-7642-UVOUT,C-8550-OUT;n:type:ShaderForge.SFN_Add,id:522,x:32524,y:34349,varname:node_522,prsc:2|A-3603-OUT,B-7642-UVOUT,C-8746-OUT;n:type:ShaderForge.SFN_Slider,id:906,x:33003,y:33438,ptovrint:False,ptlb:Opacity,ptin:_Opacity,varname:node_2095,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:1;n:type:ShaderForge.SFN_NormalVector,id:7058,x:31481,y:33078,prsc:2,pt:False;n:type:ShaderForge.SFN_Slider,id:8699,x:31892,y:33028,ptovrint:False,ptlb:MatcapSize,ptin:_MatcapSize,varname:node_2013,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.5,max:1;n:type:ShaderForge.SFN_Multiply,id:2014,x:32272,y:32827,varname:node_2014,prsc:2|A-3239-OUT,B-8699-OUT;n:type:ShaderForge.SFN_Add,id:2482,x:32623,y:32823,varname:node_2482,prsc:2|A-2014-OUT,B-8699-OUT;n:type:ShaderForge.SFN_Tex2d,id:2723,x:32797,y:32823,ptovrint:False,ptlb:Matcap_Tex,ptin:_Matcap_Tex,varname:node_2568,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:46cb24d8ed130f545b29ae037bc2cfc0,ntxv:0,isnm:False|UVIN-2482-OUT;n:type:ShaderForge.SFN_Add,id:3884,x:33190,y:33203,varname:node_3884,prsc:2|A-8334-OUT,B-608-OUT;n:type:ShaderForge.SFN_Slider,id:3379,x:32640,y:33011,ptovrint:False,ptlb:MatcapPower,ptin:_MatcapPower,varname:_MatcapSize_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.0612652,max:1;n:type:ShaderForge.SFN_Multiply,id:8334,x:32988,y:32992,varname:node_8334,prsc:2|A-2723-RGB,B-3379-OUT;n:type:ShaderForge.SFN_Lerp,id:173,x:33065,y:32419,varname:node_173,prsc:2|A-9004-OUT,B-6598-RGB,T-6437-OUT;n:type:ShaderForge.SFN_Slider,id:6437,x:32579,y:32603,ptovrint:False,ptlb:NormalPower,ptin:_NormalPower,varname:node_6437,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:1;n:type:ShaderForge.SFN_Vector3,id:9004,x:32736,y:32314,varname:node_9004,prsc:2,v1:0,v2:0,v3:1;n:type:ShaderForge.SFN_Lerp,id:639,x:32504,y:32314,varname:node_639,prsc:2|A-575-UVOUT,B-8158-UVOUT,T-4179-OUT;n:type:ShaderForge.SFN_Slider,id:4179,x:32151,y:32606,ptovrint:False,ptlb:NormalMoveSpeed,ptin:_NormalMoveSpeed,varname:node_4179,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:2;n:type:ShaderForge.SFN_ViewVector,id:5371,x:31060,y:34748,varname:node_5371,prsc:2;n:type:ShaderForge.SFN_Vector3,id:6481,x:31220,y:34914,varname:node_6481,prsc:2,v1:-1,v2:-1,v3:1;n:type:ShaderForge.SFN_Transform,id:3442,x:31220,y:34748,varname:node_3442,prsc:2,tffrom:0,tfto:3|IN-5371-OUT;n:type:ShaderForge.SFN_Multiply,id:4660,x:31404,y:34748,varname:node_4660,prsc:2|A-3442-XYZ,B-6481-OUT;n:type:ShaderForge.SFN_NormalBlend,id:4641,x:31591,y:34748,varname:node_4641,prsc:2|BSE-4660-OUT,DTL-8445-XYZ;n:type:ShaderForge.SFN_Transform,id:5022,x:31668,y:33078,varname:node_5022,prsc:2,tffrom:0,tfto:3|IN-7058-OUT;n:type:ShaderForge.SFN_ViewVector,id:9498,x:31292,y:32827,varname:node_9498,prsc:2;n:type:ShaderForge.SFN_Vector3,id:7971,x:31481,y:32993,varname:node_7971,prsc:2,v1:-1,v2:-1,v3:1;n:type:ShaderForge.SFN_Transform,id:8328,x:31481,y:32827,varname:node_8328,prsc:2,tffrom:0,tfto:3|IN-9498-OUT;n:type:ShaderForge.SFN_Multiply,id:8558,x:31665,y:32827,varname:node_8558,prsc:2|A-8328-XYZ,B-7971-OUT;n:type:ShaderForge.SFN_NormalBlend,id:7730,x:31871,y:32827,varname:node_7730,prsc:2|BSE-8558-OUT,DTL-5022-XYZ;n:type:ShaderForge.SFN_ComponentMask,id:3239,x:32050,y:32827,varname:node_3239,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-7730-OUT;n:type:ShaderForge.SFN_Slider,id:7725,x:32370,y:35152,ptovrint:False,ptlb:Transition,ptin:_Transition,varname:node_7194,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:1;n:type:ShaderForge.SFN_RemapRange,id:1643,x:32704,y:35127,varname:node_1643,prsc:2,frmn:0,frmx:1,tomn:-1,tomx:1|IN-7725-OUT;n:type:ShaderForge.SFN_Tex2d,id:7576,x:32704,y:34955,ptovrint:False,ptlb:Dissolve_Tex,ptin:_Dissolve_Tex,varname:node_646,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:ea9ac0d504a5d7445b416323350257a2,ntxv:0,isnm:False|UVIN-2927-OUT;n:type:ShaderForge.SFN_Add,id:1126,x:32881,y:34955,varname:node_1126,prsc:2|A-7576-G,B-1643-OUT;n:type:ShaderForge.SFN_Clamp01,id:2226,x:33046,y:34955,varname:node_2226,prsc:2|IN-1126-OUT;n:type:ShaderForge.SFN_Time,id:6073,x:32017,y:35091,varname:node_6073,prsc:2;n:type:ShaderForge.SFN_TexCoord,id:1901,x:32017,y:34952,varname:node_1901,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Panner,id:5568,x:32192,y:34992,varname:node_5568,prsc:2,spu:0,spv:0.1|UVIN-1901-UVOUT,DIST-6073-T;n:type:ShaderForge.SFN_Lerp,id:2927,x:32370,y:34951,varname:node_2927,prsc:2|A-1901-UVOUT,B-5568-UVOUT,T-8458-OUT;n:type:ShaderForge.SFN_Slider,id:8458,x:32017,y:35243,ptovrint:False,ptlb:DissolveMoveSpeed,ptin:_DissolveMoveSpeed,varname:_NormalMoveSpeed_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:2;n:type:ShaderForge.SFN_Time,id:8646,x:31881,y:35513,varname:node_8646,prsc:2;n:type:ShaderForge.SFN_Slider,id:7823,x:31724,y:35671,ptovrint:False,ptlb:OffsetSpeed,ptin:_OffsetSpeed,varname:node_7823,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.4240524,max:1;n:type:ShaderForge.SFN_TexCoord,id:871,x:32076,y:35426,varname:node_871,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Multiply,id:1705,x:32076,y:35571,varname:node_1705,prsc:2|A-8646-T,B-7823-OUT;n:type:ShaderForge.SFN_Panner,id:7195,x:32255,y:35438,varname:node_7195,prsc:2,spu:1,spv:1|UVIN-871-UVOUT,DIST-1705-OUT;n:type:ShaderForge.SFN_Panner,id:6388,x:32255,y:35593,varname:node_6388,prsc:2,spu:-0.9,spv:0.8|UVIN-871-UVOUT,DIST-1705-OUT;n:type:ShaderForge.SFN_Tex2dAsset,id:6601,x:32255,y:35781,ptovrint:False,ptlb:Offset_Tex,ptin:_Offset_Tex,varname:node_6601,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:28c7aad1372ff114b90d330f8a2dd938,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:8352,x:32451,y:35448,varname:node_8352,prsc:2,tex:28c7aad1372ff114b90d330f8a2dd938,ntxv:0,isnm:False|UVIN-7195-UVOUT,TEX-6601-TEX;n:type:ShaderForge.SFN_Multiply,id:6034,x:33102,y:35428,varname:node_6034,prsc:2|A-364-OUT,B-4775-OUT;n:type:ShaderForge.SFN_NormalVector,id:3942,x:32697,y:35550,prsc:2,pt:False;n:type:ShaderForge.SFN_Tex2d,id:7298,x:32451,y:35610,varname:node_7298,prsc:2,tex:28c7aad1372ff114b90d330f8a2dd938,ntxv:0,isnm:False|UVIN-6388-UVOUT,TEX-6601-TEX;n:type:ShaderForge.SFN_Multiply,id:8348,x:32697,y:35411,varname:node_8348,prsc:2|A-8352-RGB,B-7298-RGB;n:type:ShaderForge.SFN_Multiply,id:364,x:32918,y:35428,varname:node_364,prsc:2|A-8348-OUT,B-3942-OUT;n:type:ShaderForge.SFN_Slider,id:4775,x:32829,y:35754,ptovrint:False,ptlb:OffsetPower,ptin:_OffsetPower,varname:node_4775,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Color,id:6557,x:32912,y:33976,ptovrint:False,ptlb:DarkenColor,ptin:_DarkenColor,varname:node_6557,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:922,x:33085,y:33976,varname:node_922,prsc:2|A-6557-RGB,B-9070-OUT;proporder:2210-3042-6557-8939-7507-906-8850-6722-5477-1819-8550-8746-6598-4179-6437-2723-8699-3379-7576-7725-8458-6601-7823-4775;pass:END;sub:END;*/

Shader "Noriben/JewelryShaderMax" {
    Properties {
        _BaseColor ("BaseColor", Color) = (0.1629001,0.1650012,0.1691176,1)
        _AroundColor ("AroundColor", Color) = (0,0,0,1)
        _DarkenColor ("DarkenColor", Color) = (1,1,1,1)
        _Fresnel ("Fresnel", Range(0, 3)) = 2.270563
        _Refraction ("Refraction", Range(0, 3)) = 3
        _Opacity ("Opacity", Range(0, 1)) = 1
        _Distortion_Red ("Distortion_Red", Range(0, 20)) = 8
        _Distortion_Green ("Distortion_Green", Range(0, 20)) = 8
        _Distortion_Blue ("Distortion_Blue", Range(0, 20)) = 8
        _Aberration_Red ("Aberration_Red", Range(-1, 1)) = 0.024
        _Aberration_Green ("Aberration_Green", Range(-1, 1)) = 0.02
        _Aberration_Blue ("Aberration_Blue", Range(-1, 1)) = 0.02
        _Normal_Tex ("Normal_Tex", 2D) = "bump" {}
        _NormalMoveSpeed ("NormalMoveSpeed", Range(0, 2)) = 0
        _NormalPower ("NormalPower", Range(0, 1)) = 1
        _Matcap_Tex ("Matcap_Tex", 2D) = "white" {}
        _MatcapSize ("MatcapSize", Range(0, 1)) = 0.5
        _MatcapPower ("MatcapPower", Range(0, 1)) = 0.0612652
        _Dissolve_Tex ("Dissolve_Tex", 2D) = "white" {}
        _Transition ("Transition", Range(0, 1)) = 1
        _DissolveMoveSpeed ("DissolveMoveSpeed", Range(0, 2)) = 0
        _Offset_Tex ("Offset_Tex", 2D) = "white" {}
        _OffsetSpeed ("OffsetSpeed", Range(0, 1)) = 0.4240524
        _OffsetPower ("OffsetPower", Range(0, 1)) = 0
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
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform sampler2D _GrabTexture;
            uniform float4 _BaseColor;
            uniform float4 _AroundColor;
            uniform float _Fresnel;
            uniform float _Refraction;
            uniform float _Distortion_Blue;
            uniform sampler2D _Normal_Tex; uniform float4 _Normal_Tex_ST;
            uniform float _Aberration_Red;
            uniform float _Aberration_Blue;
            uniform float _Aberration_Green;
            uniform float _Distortion_Green;
            uniform float _Distortion_Red;
            uniform float _Opacity;
            uniform float _MatcapSize;
            uniform sampler2D _Matcap_Tex; uniform float4 _Matcap_Tex_ST;
            uniform float _MatcapPower;
            uniform float _NormalPower;
            uniform float _NormalMoveSpeed;
            uniform float _Transition;
            uniform sampler2D _Dissolve_Tex; uniform float4 _Dissolve_Tex_ST;
            uniform float _DissolveMoveSpeed;
            uniform float _OffsetSpeed;
            uniform sampler2D _Offset_Tex; uniform float4 _Offset_Tex_ST;
            uniform float _OffsetPower;
            uniform float4 _DarkenColor;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float4 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                float4 projPos : TEXCOORD5;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                float4 node_8646 = _Time;
                float node_1705 = (node_8646.g*_OffsetSpeed);
                float2 node_7195 = (o.uv0+node_1705*float2(1,1));
                float4 node_8352 = tex2Dlod(_Offset_Tex,float4(TRANSFORM_TEX(node_7195, _Offset_Tex),0.0,0));
                float2 node_6388 = (o.uv0+node_1705*float2(-0.9,0.8));
                float4 node_7298 = tex2Dlod(_Offset_Tex,float4(TRANSFORM_TEX(node_6388, _Offset_Tex),0.0,0));
                v.vertex.xyz += (((node_8352.rgb*node_7298.rgb)*v.normal)*_OffsetPower);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float4 node_6217 = _Time;
                float2 node_639 = lerp(i.uv0,(i.uv0+node_6217.g*float2(0,0.1)),_NormalMoveSpeed);
                float3 _Normal_Tex_var = UnpackNormal(tex2D(_Normal_Tex,TRANSFORM_TEX(node_639, _Normal_Tex)));
                float3 normalLocal = lerp(float3(0,0,1),_Normal_Tex_var.rgb,_NormalPower);
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float node_4802 = pow(1.0-max(0,dot(normalDirection, viewDirection)),_Fresnel);
                float node_7096 = (i.uv0.g*(node_4802*_Refraction));
                float2 sceneUVs = (i.projPos.xy / i.projPos.w) + float2(node_7096,node_7096);
                float4 sceneColor = tex2D(_GrabTexture, sceneUVs);
                float4 node_6073 = _Time;
                float2 node_2927 = lerp(i.uv0,(i.uv0+node_6073.g*float2(0,0.1)),_DissolveMoveSpeed);
                float4 _Dissolve_Tex_var = tex2D(_Dissolve_Tex,TRANSFORM_TEX(node_2927, _Dissolve_Tex));
                clip(saturate((_Dissolve_Tex_var.g+(_Transition*2.0+-1.0))) - 0.5);
////// Lighting:
////// Emissive:
                float3 node_7730_nrm_base = (mul( UNITY_MATRIX_V, float4(viewDirection,0) ).xyz.rgb*float3(-1,-1,1)) + float3(0,0,1);
                float3 node_7730_nrm_detail = mul( UNITY_MATRIX_V, float4(i.normalDir,0) ).xyz.rgb * float3(-1,-1,1);
                float3 node_7730_nrm_combined = node_7730_nrm_base*dot(node_7730_nrm_base, node_7730_nrm_detail)/node_7730_nrm_base.z - node_7730_nrm_detail;
                float3 node_7730 = node_7730_nrm_combined;
                float2 node_2482 = ((node_7730.rg*_MatcapSize)+_MatcapSize);
                float4 _Matcap_Tex_var = tex2D(_Matcap_Tex,TRANSFORM_TEX(node_2482, _Matcap_Tex));
                float3 emissive = ((_Matcap_Tex_var.rgb*_MatcapPower)+lerp(_BaseColor.rgb,_AroundColor.rgb,node_4802));
                float3 node_4641_nrm_base = (mul( UNITY_MATRIX_V, float4(viewDirection,0) ).xyz.rgb*float3(-1,-1,1)) + float3(0,0,1);
                float3 node_4641_nrm_detail = UnityObjectToViewPos( float4((-1*i.normalDir),0) ).xyz.rgb * float3(-1,-1,1);
                float3 node_4641_nrm_combined = node_4641_nrm_base*dot(node_4641_nrm_base, node_4641_nrm_detail)/node_4641_nrm_base.z - node_4641_nrm_detail;
                float3 node_4641 = node_4641_nrm_combined;
                float node_9454 = node_4641.r;
                float3 finalColor = emissive + (_DarkenColor.rgb*float3(tex2D( _GrabTexture, ((node_9454*pow(1.0-max(0,dot(normalDirection, viewDirection)),_Distortion_Red))+sceneUVs.rg+_Aberration_Red)).r,tex2D( _GrabTexture, ((node_9454*pow(1.0-max(0,dot(normalDirection, viewDirection)),_Distortion_Green))+sceneUVs.rg+_Aberration_Green)).g,tex2D( _GrabTexture, ((node_9454*pow(1.0-max(0,dot(normalDirection, viewDirection)),_Distortion_Blue))+sceneUVs.rg+_Aberration_Blue)).b));
                return fixed4(lerp(sceneColor.rgb, finalColor,_Opacity),1);
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            Cull Back
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float _Transition;
            uniform sampler2D _Dissolve_Tex; uniform float4 _Dissolve_Tex_ST;
            uniform float _DissolveMoveSpeed;
            uniform float _OffsetSpeed;
            uniform sampler2D _Offset_Tex; uniform float4 _Offset_Tex_ST;
            uniform float _OffsetPower;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 node_8646 = _Time;
                float node_1705 = (node_8646.g*_OffsetSpeed);
                float2 node_7195 = (o.uv0+node_1705*float2(1,1));
                float4 node_8352 = tex2Dlod(_Offset_Tex,float4(TRANSFORM_TEX(node_7195, _Offset_Tex),0.0,0));
                float2 node_6388 = (o.uv0+node_1705*float2(-0.9,0.8));
                float4 node_7298 = tex2Dlod(_Offset_Tex,float4(TRANSFORM_TEX(node_6388, _Offset_Tex),0.0,0));
                v.vertex.xyz += (((node_8352.rgb*node_7298.rgb)*v.normal)*_OffsetPower);
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 normalDirection = i.normalDir;
                float4 node_6073 = _Time;
                float2 node_2927 = lerp(i.uv0,(i.uv0+node_6073.g*float2(0,0.1)),_DissolveMoveSpeed);
                float4 _Dissolve_Tex_var = tex2D(_Dissolve_Tex,TRANSFORM_TEX(node_2927, _Dissolve_Tex));
                clip(saturate((_Dissolve_Tex_var.g+(_Transition*2.0+-1.0))) - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
