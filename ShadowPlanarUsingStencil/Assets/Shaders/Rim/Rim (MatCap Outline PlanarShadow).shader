Shader "kokichi/Mobile/Rim/MatCap/Textured Outline PlanarShadow"
{
	Properties
	{
		_basetexture ("Base (RGB) Cutoff(A)", 2D) = "white" {}
		_matcap ("MatCap (RGB)", 2D) = "white" {}
		_rimTex ("Rim Tex (RGB)", 2D) = "black" {}
		_ambientscale("Ambient Scale", Float) = 1.0
		_diffusescale("Diffuse Scale", Float) = 1.0
		_mulscale("Multiple Scale", Float) = 0.8
		_addscale("Add Scale", Float) = 0.8
		_rimlightcolor ("Rim Light Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_rimlightscale ("Rim Light Scale", Float) = 1.0
		_Outline ("Outline Width", Range(0,0.05)) = 0.005
		_OutlineColor ("Outline Color", Color) = (0.2, 0.2, 0.2, 1)
	}
	
	Subshader
	{
		Tags {"QUEUE"="Geometry" }
		Pass
		{
			Tags { "LIGHTMODE"="ForwardBase" "RenderType"="Opaque" }
			Stencil
			{
				Comp Always
				Pass Zero
			}
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
		UsePass "kokichi/Hidden/Outline/OUTLINE"
		UsePass "kokichi/Hidden/Stencil/PLANAR_SHADOW"
	}
	
}