Shader "kokichi/Mobile/MatCap/Textured Outline PlanarShadow Hue"
{
	Properties
	{
		_basetexture ("Base (RGB) Cutoff(A)", 2D) = "white" {}
		_matcap ("MatCap (RGB)", 2D) = "white" {}
		_ambientscale("Ambient Scale", Float) = 1.0
		_diffusescale("Diffuse Scale", Float) = 1.0
		_mulscale("Multiple Scale", Float) = 0.8
		_addscale("Add Scale", Float) = 0.8
		_Outline ("Outline Width", Range(0,0.05)) = 0.005
		_OutlineColor ("Outline Color", Color) = (0.2, 0.2, 0.2, 1)
		_HueShift("HueShift", Range(0,359) ) = 0
         _Sat("Saturation", Range(0,1)) = 1
         _Val("Value", Range(0,1)) = 1
	}
	
	Subshader
	{
		Tags {"QUEUE"="Geometry" }
		Pass
		{
			Tags { "LIGHTMODE"="ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			
			#include "UnityCG.cginc" 
			#include "../CGIncludes/HueLib.cginc"
				
			#define MAT_CAP 
			#define HUE
			
			#include "RimInput.cginc"
			#include "RimFunc.cginc"
			
			ENDCG
		}
		UsePass "kokichi/Hidden/Outline/OUTLINE"
		UsePass "kokichi/Hidden/Stencil/PLANAR_SHADOW"
		
	}
	
	
}