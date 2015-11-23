 Shader "Custom/ToonRamp" {
     Properties 
     {
         _MainTex ("Base (RGB)", 2D) = "white" {}
         _ToonRampTex ("ToonRamp Texture", 2D) = "gray" {}
         _AlphaCut("CutOff", Range(0,1)) = 0
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
         sampler2D _ToonRampTex;
 		fixed _AlphaCut;
 		uniform fixed4 _LightColor0;
		struct v2f
		{
			float4 pos	: POSITION;
			float2 uv 	: TEXCOORD0;
			float2 cap	: TEXCOORD1;
			float4 diff	: TEXCOORD2;
		};
         
         v2f vert (appdata_base v)
		{
			v2f o;
			o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
			o.uv = v.texcoord;
			
			//directional light
			float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);	
			float3 normalDir = normalize(mul(float4(v.normal, 0.0), _World2Object).xyz);
			float NdotL = dot(normalDir, lightDir);
			float halfNdotL = NdotL * 0.5 + 0.5;
			o.cap = halfNdotL;
			return o;
		}

		float4 frag (v2f i) : COLOR
		{
			float4 tex = tex2D(_MainTex, i.uv);
			float4 mc = tex2D(_ToonRampTex, float2(i.cap));
			if(tex.a < _AlphaCut)
				discard;
			else
				return tex * mc;
		}
         ENDCG
     } 
     
     }
     FallBack "Diffuse"
 }