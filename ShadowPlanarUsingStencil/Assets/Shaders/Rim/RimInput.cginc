

fixed	_ambientscale;
sampler2D	_basetexture;
#ifdef TOON_RAMP
sampler2D _ramp;
fixed _diffusescale;
fixed _mulscale;
fixed _addscale;
#endif
#ifdef MAT_CAP
sampler2D _matcap;
fixed _diffusescale;
fixed _mulscale;
fixed _addscale;
#endif
#ifdef RIM_LIGHT
fixed	_rimlightscale;
fixed3	_rimlightcolor;
	#ifndef MAT_CAP
		fixed	_rimlightpower;
	#else
		sampler2D _rimTex;
	#endif
#endif
fixed4 _LightColor0;
#ifdef ALPHA_CUT
fixed _AlphaCut;
#endif

#ifdef HUE
fixed _HueShift;
fixed _Sat;
fixed _Val;
#endif
struct app_data
{
	fixed4 vertex : POSITION;
	float3 normal : NORMAL;
	fixed4 texcoord : TEXCOORD0;
};

struct v2f
{
	fixed4 pos : SV_POSITION;
	fixed2 tex : TEXCOORD0;
	fixed3 diffuse : TEXCOORD1;
#if defined(RIM_LIGHT) && !defined(MAT_CAP)
	fixed3 rim : TEXCOORD2;
#endif
#if defined(MAT_CAP) || defined(TOON_RAMP)
	fixed2 cap : TEXCOORD3;
#endif
};