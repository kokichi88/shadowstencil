Shader "kokichi/Mobile/Rim/ToonRamp/Default (One Light)" {
	Properties {
		_basetexture("Diffuse (RGB) ", 2D)	= "white" {}
		_ramp ("Toon Ramp (RGB)", 2D) = "gray" {}
		_ambientscale	("Ambient Scale", Float) = 1.0
		_diffusescale("Diffuse Scale", Float) = 1.0
		_mulscale("Multiple Scale", Float) = 0.8
		_addscale("Add Scale", Float) = 0.8
		_rimlightcolor ("Rim Light Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_rimlightscale ("Rim Light Scale", Float) = 1.0
		_rimlightpower ("Rim Light Power", Float) = 0.2
	}
	SubShader {
	
		Tags {"QUEUE"="Geometry" }
		Pass
		{
			Tags { "LIGHTMODE"="ForwardBase" "RenderType"="Opaque" }
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#define RIM_LIGHT
			#define TOON_RAMP
			
			#include "RimInput.cginc"
			#include "RimFunc.cginc"
			
			ENDCG
		}
		
	} 
	FallBack "Diffuse"
}
