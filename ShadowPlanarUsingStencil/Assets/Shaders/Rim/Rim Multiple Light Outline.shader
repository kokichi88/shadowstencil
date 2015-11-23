Shader "kokichi/Mobile/Rim/Rim (Multiple Light) Outline" {
	Properties {
		_basetexture("Diffuse (RGB) RimMask (A)", 2D)	= "white" {}
		
		_ambientscale	("Ambient Scale", Float) = 1.0

		_rimlightcolor ("Rim Light Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_rimlightscale ("Rim Light Scale", Float) = 1.0
		_rimlightpower ("Rim Light Power", Float) = 0.2
		
		_Outline ("Outline Width", Range(0,0.05)) = 0.005
		_OutlineColor ("Outline Color", Color) = (0.2, 0.2, 0.2, 1)
	}
	SubShader {
	
	Pass
	{
		Tags { "LIGHTMODE"="ForwardBase" "QUEUE"="Geometry"}
		
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		#define RIM_LIGHT
		
		#include "RimInput.cginc"
		#include "RimFunc.cginc"
		ENDCG
	}
	
	Pass
	{
		Tags { "LIGHTMODE"="ForwardAdd" "QUEUE"="Geometry"}
		Blend One One
		
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		
		#include "RimInput.cginc"
		#include "RimFunc.cginc"
		
		ENDCG
	}
	
	UsePass "kokichi/Hidden/Outline/OUTLINE"
	
	} 
	FallBack "Diffuse"
}
