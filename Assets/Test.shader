// Shader created with Shader Forge Beta 0.34 
// Shader Forge (c) Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:0.34;sub:START;pass:START;ps:flbk:,lico:1,lgpr:1,nrmq:1,limd:1,uamb:True,mssp:True,lmpd:False,lprd:False,enco:False,frtr:True,vitr:True,dbil:False,rmgx:True,rpth:0,hqsc:True,hqlp:False,blpr:0,bsrc:0,bdst:0,culm:2,dpts:2,wrdp:True,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,ofsf:0,ofsu:0,f2p0:False;n:type:ShaderForge.SFN_Final,id:1,x:32512,y:32895|diff-179-OUT,spec-120-OUT,gloss-44-OUT;n:type:ShaderForge.SFN_Tex2d,id:24,x:33571,y:33015,ptlb:node_24,ptin:_node_24,tex:e958c6041cfe445e987c73751e8d4082,ntxv:2,isnm:False;n:type:ShaderForge.SFN_Color,id:26,x:33556,y:32848,ptlb:node_26,ptin:_node_26,glob:False,c1:0.1838235,c2:0.1486808,c3:0.1486808,c4:1;n:type:ShaderForge.SFN_Multiply,id:33,x:33188,y:32826|A-41-OUT,B-26-RGB,C-24-RGB;n:type:ShaderForge.SFN_Slider,id:41,x:33452,y:32744,ptlb:DiffuseNoise,ptin:_DiffuseNoise,min:0,cur:0.5,max:1;n:type:ShaderForge.SFN_Slider,id:44,x:32803,y:32745,ptlb:Gloss,ptin:_Gloss,min:0,cur:0.1,max:1;n:type:ShaderForge.SFN_TexCoord,id:86,x:33691,y:33667,uv:0;n:type:ShaderForge.SFN_Step,id:113,x:33269,y:33182|A-24-RGB,B-114-OUT;n:type:ShaderForge.SFN_Slider,id:114,x:33486,y:33402,ptlb:noise,ptin:_noise,min:0,cur:0.4699248,max:1;n:type:ShaderForge.SFN_Multiply,id:120,x:32935,y:33212|A-113-OUT,B-121-OUT;n:type:ShaderForge.SFN_Slider,id:121,x:33486,y:33516,ptlb:specFactor,ptin:_specFactor,min:0,cur:0.124812,max:1;n:type:ShaderForge.SFN_Lerp,id:179,x:32857,y:32920|A-33-OUT,B-120-OUT,T-180-OUT;n:type:ShaderForge.SFN_Slider,id:180,x:33109,y:33040,ptlb:DiffuseLerp,ptin:_DiffuseLerp,min:0,cur:0.1729323,max:1;proporder:24-26-41-44-114-121-180;pass:END;sub:END;*/

Shader "Shader Forge/Test" {
    Properties {
        _node_24 ("node_24", 2D) = "black" {}
        _node_26 ("node_26", Color) = (0.1838235,0.1486808,0.1486808,1)
        _DiffuseNoise ("DiffuseNoise", Range(0, 1)) = 0.5
        _Gloss ("Gloss", Range(0, 1)) = 0.1
        _noise ("noise", Range(0, 1)) = 0.4699248
        _specFactor ("specFactor", Range(0, 1)) = 0.124812
        _DiffuseLerp ("DiffuseLerp", Range(0, 1)) = 0.1729323
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            Cull Off
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform sampler2D _node_24; uniform float4 _node_24_ST;
            uniform float4 _node_26;
            uniform float _DiffuseNoise;
            uniform float _Gloss;
            uniform float _noise;
            uniform float _specFactor;
            uniform float _DiffuseLerp;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                LIGHTING_COORDS(3,4)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.texcoord0;
                o.normalDir = mul(float4(v.normal,0), _World2Object).xyz;
                o.posWorld = mul(_Object2World, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
/////// Normals:
                float3 normalDirection =  i.normalDir;
                
                float nSign = sign( dot( viewDirection, i.normalDir ) ); // Reverse normal if this is a backface
                i.normalDir *= nSign;
                normalDirection *= nSign;
                
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = dot( normalDirection, lightDirection );
                float3 diffuse = max( 0.0, NdotL) * attenColor + UNITY_LIGHTMODEL_AMBIENT.rgb;
///////// Gloss:
                float gloss = _Gloss;
                float specPow = exp2( gloss * 10.0+1.0);
////// Specular:
                NdotL = max(0.0, NdotL);
                float2 node_190 = i.uv0;
                float4 node_24 = tex2D(_node_24,TRANSFORM_TEX(node_190.rg, _node_24));
                float3 node_120 = (step(node_24.rgb,_noise)*_specFactor);
                float3 specularColor = node_120;
                float3 specular = (floor(attenuation) * _LightColor0.xyz) * pow(max(0,dot(halfDirection,normalDirection)),specPow) * specularColor;
                float3 finalColor = 0;
                float3 diffuseLight = diffuse;
                finalColor += diffuseLight * lerp((_DiffuseNoise*_node_26.rgb*node_24.rgb),node_120,_DiffuseLerp);
                finalColor += specular;
/// Final Color:
                return fixed4(finalColor,1);
            }
            ENDCG
        }
        Pass {
            Name "ForwardAdd"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            Cull Off
            
            
            Fog { Color (0,0,0,0) }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform sampler2D _node_24; uniform float4 _node_24_ST;
            uniform float4 _node_26;
            uniform float _DiffuseNoise;
            uniform float _Gloss;
            uniform float _noise;
            uniform float _specFactor;
            uniform float _DiffuseLerp;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                LIGHTING_COORDS(3,4)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.texcoord0;
                o.normalDir = mul(float4(v.normal,0), _World2Object).xyz;
                o.posWorld = mul(_Object2World, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
/////// Normals:
                float3 normalDirection =  i.normalDir;
                
                float nSign = sign( dot( viewDirection, i.normalDir ) ); // Reverse normal if this is a backface
                i.normalDir *= nSign;
                normalDirection *= nSign;
                
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = dot( normalDirection, lightDirection );
                float3 diffuse = max( 0.0, NdotL) * attenColor;
///////// Gloss:
                float gloss = _Gloss;
                float specPow = exp2( gloss * 10.0+1.0);
////// Specular:
                NdotL = max(0.0, NdotL);
                float2 node_191 = i.uv0;
                float4 node_24 = tex2D(_node_24,TRANSFORM_TEX(node_191.rg, _node_24));
                float3 node_120 = (step(node_24.rgb,_noise)*_specFactor);
                float3 specularColor = node_120;
                float3 specular = attenColor * pow(max(0,dot(halfDirection,normalDirection)),specPow) * specularColor;
                float3 finalColor = 0;
                float3 diffuseLight = diffuse;
                finalColor += diffuseLight * lerp((_DiffuseNoise*_node_26.rgb*node_24.rgb),node_120,_DiffuseLerp);
                finalColor += specular;
/// Final Color:
                return fixed4(finalColor * 1,0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
