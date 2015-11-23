Shader "kokichi/Mobile/Rim/MatCap/Textured"
{
	Properties
	{
		_basetexture ("Base (RGB)", 2D) = "white" {}
		_matcap ("MatCap (RGB)", 2D) = "white" {}
		_rimTex ("Rim Tex (RGB)", 2D) = "black" {}
		_ambientscale("Ambient Scale", Float) = 1.0
		_diffusescale("Diffuse Scale", Float) = 1.0
		_mulscale("Multiple Scale", Float) = 0.8
		_addscale("Add Scale", Float) = 0.8
		_rimlightcolor ("Rim Light Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_rimlightscale ("Rim Light Scale", Float) = 1.0
	}
	
	Subshader
	{
		Tags {"QUEUE"="Geometry" }
		Pass
		{
			Tags { "LIGHTMODE"="ForwardBase" "RenderType"="Opaque" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc" 
			
			#define RIM_LIGHT	
			#define MAT_CAP 
			
			#include "RimInput.cginc"
			#include "RimFunc.cginc"
			
			ENDCG
		}
		
		
	}
	
}