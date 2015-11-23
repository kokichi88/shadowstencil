Shader "kokichi/Mobile/MatCap/Textured Transparent PlanarShadow"
{
	Properties
	{
		_basetexture ("Base (RGB) Alpha(A)", 2D) = "white" {}
		_matcap ("MatCap (RGB)", 2D) = "white" {}
		_ambientscale("Ambient Scale", Float) = 1.0
		_diffusescale("Diffuse Scale", Float) = 1.0
		_mulscale("Multiple Scale", Float) = 0.8
		_addscale("Add Scale", Float) = 0.8
	}
	
	Subshader
	{
		Tags { "Queue" = "Transparent" }
		Pass
		{
		
			Tags { "LIGHTMODE"="ForwardBase" "IGNOREPROJECTOR"="true" "RenderType"="Transparent" }
			Stencil
			{
				Comp Always
				Pass Zero
			}
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc" 
				
			#define MAT_CAP 
			
			#include "RimInput.cginc"
			#include "RimFunc.cginc"
			
			ENDCG
		}
		UsePass "kokichi/Hidden/Stencil/PLANAR_SHADOW"
	}
	
}