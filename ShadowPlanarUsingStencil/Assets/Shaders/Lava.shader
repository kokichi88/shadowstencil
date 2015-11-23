Shader "Transparent/Lava" {
Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
    _MainTex ("Base (RGB) ", 2D) = "white" {}
    _lavaEmissiveMaskTexture("lava Emissive MaskMap", 2D) = "white"{}
    addMixVal("Min value", Range(1,2)) = 1
    offsetX("offset X", Range(0,1)) = 1
    offsetY("offset Y", Range(0,1)) = 1
    offsetVectorXY("offset Vector XY", Vector) = (0,0,0,0)
    SineSpeed("SineSpeed", Range(0,1)) = 0.169
    deformSinVert("deformSinVert", Vector) = (0,0,0,0)
    WaveSinSpeed("WaveSinSpeed", Range(0,2)) = 1
    LavaSinWaveFactor("LavaSinWaveFactor", Range(0,10)) = 1
    
}
SubShader {
    Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
    LOD 200

    // extra pass that renders to depth buffer only
    Pass {
        Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		uniform float4 _Color;
		uniform sampler2D _MainTex;
		uniform sampler2D _lavaEmissiveMaskTexture;
		uniform float addMixVal;
		uniform float offsetX;
		uniform float offsetY;
		uniform float2 offsetVectorXY;
		uniform float SineSpeed;
		uniform float3 deformSinVert;
		uniform float WaveSinSpeed;
		uniform float LavaSinWaveFactor;
		
		struct a2v {
			float4 position  : POSITION; // In this simple shader, all we really need passed is the position
			float2 texCoord  : TEXCOORD0;
		 
		};
 
		struct v2f {
			float4 position  : POSITION;
			float2 texCoord  : TEXCOORD0;
		 
		};
		
		v2f vert(a2v In)
		{
			v2f Out;
			 
			float4 deformamtionVertPos = In.position;
			float4 deformationVertPosVertical = In.position;
			 
			 
			 
			deformamtionVertPos.xyz = deformamtionVertPos.xyz + (sin(_Time * WaveSinSpeed + In.position.z * LavaSinWaveFactor )) * deformSinVert ;
			 
			deformationVertPosVertical.xyz = deformationVertPosVertical.xyz + (sin(_Time * WaveSinSpeed + In.position.x * LavaSinWaveFactor )) * deformSinVert ;
			 
			float4 mixed_deformationVertPos = (deformamtionVertPos + deformationVertPosVertical); 
			 
			Out.position = mul(UNITY_MATRIX_MVP, mixed_deformationVertPos);
//			Out.position = mul(UNITY_MATRIX_MVP, In.position);
			 
			Out.texCoord = In.texCoord;
			 
			return Out;
		}
		
		float4 frag(v2f In) : COLOR
		{
		 
			float4 outColor;
			float4 addColor;
			float4 colorMap;
			float4 variationMixedColor;
			float4 emmiveMaskMap;
			float4 uvScaleTranslate;
			 
			 
			uvScaleTranslate.x = offsetX;
			uvScaleTranslate.y = offsetY;
			 
			 
			float2 uv = (In.texCoord - 0.5f) * uvScaleTranslate.xy + uvScaleTranslate.zw + (_Time * SineSpeed * offsetVectorXY )  + 0.5f;
//			float2 uv = In.texCoord;
			 
			colorMap = tex2D(_MainTex , uv);
			emmiveMaskMap = tex2D(_lavaEmissiveMaskTexture , uv);
			addColor = _Color;
//			 
//			 
			variationMixedColor = (cos(sin((_Time/4.0f) *  addMixVal)));
//			 
			outColor.rgb += ( colorMap.rgb * addColor.rgb ) * (emmiveMaskMap.rgb + variationMixedColor) ;
//			outColor.rgb = colorMap.rgb;
			outColor.a = 1.0f;
			 
			return outColor;
		}
		ENDCG
    }

    // paste in forward rendering passes from Transparent/Diffuse
}
Fallback "Transparent/VertexLit"
}