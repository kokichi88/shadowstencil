Shader "kokichi/Hidden/Screen/Stencil Clear"
{
	SubShader
	{
		Tags
		{
			"Queue" = "Background-1"
			"IgnoreProjector" = "True"
		}
		
		Pass
		{
			Stencil
			{
				Comp Always
				Pass Zero
			}
			
			Lighting Off
			Cull Off
			ZTest Always
			ZWrite Off
			Blend Zero One
			
			Fog
			{
				Mode Off
			}
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "kokichi_StencilScreen.cginc"
			ENDCG
		}
	}
}