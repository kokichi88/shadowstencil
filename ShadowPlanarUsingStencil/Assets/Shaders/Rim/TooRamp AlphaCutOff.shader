Shader "kokichi/Mobile/ToonRamp/Textured Alpha Cutoff" {
	Properties {
		_basetexture("Diffuse (RGB) Cutoff(A)", 2D)	= "white" {}
		_ramp("Toon Ramp (RGB)", 2D) = "gray" {}
		_ambientscale("Ambient Scale", Float) = 1.0
		_diffusescale("Diffuse Scale", Float) = 1.0
		_mulscale("Multiple Scale", Float) = 0.8
		_addscale("Add Scale", Float) = 0.8
		_AlphaCut("Alpha Cutoff", Range(0,1)) = 0
	}
	SubShader {
	Pass
	{
		Tags { "LIGHTMODE"="ForwardBase" "QUEUE"="Geometry"}
		
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		#define TOON_RAMP
		#define ALPHA_CUT
		
		#include "RimInput.cginc"
		#include "RimFunc.cginc"
		
		ENDCG
	}
		
	} 
	FallBack "Diffuse"
}
