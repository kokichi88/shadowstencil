 Shader "Custom/BRDFOutline" {
     Properties 
     {
         _MainTex ("Base (RGB)", 2D) = "white" {}
         _BRDFTex ("BRDF Texture", 2D) = "gray" {}
         _AlphaCut("CutOff", Range(0,1)) = 0
         _OutlineColor("Outline Color", Color) = (1,1,1,1)
         _Outline("Outline Thickness", Float) = 1
         _OutlineDiffusion("Outline Diffusion", Float) = 1
     }
     SubShader {
         Tags { "RenderQueue"="Geometry" }
       Pass
	{
		Tags { "LIGHTMODE"="ForwardBase" "QUEUE"="Geometry"}
//		Blend SrcAlpha OneMinusSrcAlpha
         LOD 200
         CGPROGRAM
         #pragma vertex vert
         #pragma fragment frag
         #include "UnityCG.cginc"
         sampler2D _MainTex;
         sampler2D _BRDFTex;
 		fixed _AlphaCut;
 		fixed4 _OutlineColor;
 		fixed _Outline;
 		fixed _OutlineDiffusion;
 		uniform fixed4 _LightColor0;
		struct v2f
		{
			float4 pos	: POSITION;
			float2 uv 	: TEXCOORD0;
			float2 cap	: TEXCOORD1;
//			float4 diff	: TEXCOORD2;
			float3 normal	: TEXCOORD3;
			float3 viewDir	: TEXCOORD4;
		};
         
         v2f vert (appdata_base v)
		{
			v2f o;
			o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
			o.uv = v.texcoord;
			
			float3 posWorld = mul(_Object2World, v.vertex).xyz;
			float3 viewDir = normalize(_WorldSpaceCameraPos - posWorld);
			float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);	
			float3 normalDir = normalize(mul(float4(v.normal, 0.0), _World2Object).xyz);
			float NdotL = dot(normalDir, lightDir);
			float halfNdotL = NdotL * 0.5 + 0.5;
			float NdotE = dot(normalDir, viewDir);
			o.cap = float2(halfNdotL, NdotE);
			o.normal = normalDir;
			o.viewDir = viewDir;
			return o;
		}

		float4 frag (v2f i) : COLOR
		{
			float4 tex = tex2D(_MainTex, i.uv);
			float4 mc = tex2D(_BRDFTex, float2(i.cap));
			float outlineStren = saturate((dot(i.normal, i.viewDir) - _Outline) * 
								pow(2-_OutlineDiffusion, 10) + _Outline);
			float4 outlineOverlay = float4(_OutlineColor.rgb * (1-outlineStren) + outlineStren,1);
			if(tex.a < _AlphaCut)
				discard;
			return tex * mc * outlineOverlay;
//			return tex * mc;
			//return mc;
		}
         ENDCG
     } 
//     UsePass "kokichi/Hidden/Outline/OUTLINE"
     }
     FallBack "Diffuse"
 }