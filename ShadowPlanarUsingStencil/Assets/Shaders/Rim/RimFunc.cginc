

v2f vert(app_data input) 
{
	v2f output;

	fixed3x3 modelMatrix = _Object2World;
	fixed3x3 modelMatrixInverse = _World2Object; 
	
	fixed3 normalDirection = normalize(mul(input.normal, modelMatrixInverse)); 
	fixed attenuation = 1.0; // no attenuation
	#ifndef MAT_CAP
		fixed4 posWorld = mul(_Object2World, input.vertex);
		fixed3 lightDirection = normalize(_WorldSpaceLightPos0.xyz); 
		if (0.0 == _WorldSpaceLightPos0.w) // directional light?
		{
			attenuation = 1.0; // no attenuation
		} 
		else // point or spot light
		{
			fixed3 vertexToLightSource = 
			_WorldSpaceLightPos0.xyz - posWorld.xyz;
			fixed distance = length(vertexToLightSource);
			attenuation = 1.0 / distance; // linear attenuation 
			lightDirection = normalize(vertexToLightSource);
		}

		fixed NdotL = (dot(normalDirection, lightDirection));
		fixed halfLambert = (0.5 * NdotL + 0.5);
	#endif
	
	fixed3 ambientLighting = ShadeSH9 (fixed4(normalDirection,1.0)) * _ambientscale;
	
	#ifdef TOON_RAMP
		output.cap = halfLambert;
		fixed3 diffuseReflection = ambientLighting;
	#elif defined(MAT_CAP)
		fixed3 capCoord = normalize(mul(input.normal,modelMatrixInverse));
		capCoord = mul((fixed3x3)UNITY_MATRIX_V, capCoord);
		output.cap = capCoord.xy * 0.5 + 0.5;
		fixed3 diffuseReflection = ambientLighting;
	#else
		fixed3 lightColor = _LightColor0.rgb * 1.5;
		fixed3 diffuseReflection = attenuation * lightColor * halfLambert;
		diffuseReflection += ambientLighting;
	#endif
	output.tex = input.texcoord;
	output.pos = mul(UNITY_MATRIX_MVP, input.vertex);
	output.diffuse = diffuseReflection;
#ifdef RIM_LIGHT
	#ifndef MAT_CAP
		fixed rim = 1.0f - saturate( dot(normalize(ObjSpaceViewDir(input.vertex)), input.normal) );
		fixed3 rimlight = (_rimlightcolor.rgb * pow(rim, _rimlightpower));
		if (0.0 != _WorldSpaceLightPos0.w)
		{ rimlight *= attenuation; }
		output.rim = rimlight * _rimlightscale;
	#endif
#endif

	
	return output;
}

fixed4 frag(v2f input) : COLOR
{
	fixed4 finalColor = (0,0,0,0);
	fixed4 diffuseColor = tex2D(_basetexture, input.tex);
#ifdef HUE
	fixed3 shift = fixed3(_HueShift, _Sat, _Val);  
	diffuseColor.rgb = low_shift_col(diffuseColor, shift);
#endif
	finalColor.a = diffuseColor.a;
#ifdef ALPHA_CUT
	if(diffuseColor.a < _AlphaCut)
		discard;
#endif
#ifdef TOON_RAMP
	fixed3 ramp = tex2D(_ramp, input.cap.xy);
	input.diffuse = input.diffuse * _diffusescale + input.diffuse * ramp * _mulscale + ramp * _addscale;
#elif defined(MAT_CAP)
	fixed3 ramp = tex2D(_matcap, input.cap.xy);
	input.diffuse = input.diffuse * _diffusescale + input.diffuse * ramp * _mulscale + ramp * _addscale;
//	input.diffuse = ramp * _addscale;
#endif
	finalColor.rgb = diffuseColor.rgb * input.diffuse;
#ifdef RIM_LIGHT
	#ifndef MAT_CAP
		fixed3 rimlight = input.rim;
		#if defined(RIM_MASK) && !defined(ALPHA_CUT)
			rimlight *= diffuseColor.a;
		#endif
	#else
		fixed3 rimlight = tex2D(_rimTex, input.cap.xy) * _rimlightcolor * _rimlightscale;
	#endif
	finalColor.rgb += rimlight;
#endif
	return finalColor;
}