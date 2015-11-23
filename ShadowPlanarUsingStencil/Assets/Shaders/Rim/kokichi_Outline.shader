Shader "kokichi/Hidden/Outline"
{
	Properties
	{
		//OUTLINE
		_Outline ("Outline Width", Float) = 1.0
		_OutlineColor ("Outline Color", Color) = (0.2, 0.2, 0.2, 1)
	}
	
	SubShader
	{
		Tags { "RenderType"="Opaque" "Queue"="Geometry" }
		
		//Outline default
		Pass
		{
			Name "OUTLINE"
			Cull Front
//			ZWrite Off
//			ZTest Always
//			ColorMask RGB
//			Blend SrcAlpha OneMinusSrcAlpha 
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct a2v
			{
				fixed4 vertex : POSITION;
				fixed3 normal : NORMAL;
			}; 
			
			struct v2f
			{
				fixed4 pos : POSITION;
			};
			
			fixed _Outline;
			fixed4 _OutlineColor;
			
			v2f vert (a2v v)
			{
				v2f o;
				fixed4 pos = mul( UNITY_MATRIX_MV, v.vertex + fixed4(v.normal,0) * _Outline);
				o.pos = mul(UNITY_MATRIX_P, pos);
				return o;
			}
			
			fixed4 frag (v2f IN) : COLOR
			{
				return _OutlineColor;
			}
			ENDCG
		}
	}
}
