fixed4 _ShadowColor;

struct app_data
{
	fixed4 vertex : POSITION;
};

struct v2f
{
	fixed4 position : SV_POSITION;
};

v2f vert(app_data IN)
{
	v2f OUT;
	
	OUT.position = IN.vertex;
	
	return OUT;
}

float4 frag() : COLOR
{
	return _ShadowColor;
}

