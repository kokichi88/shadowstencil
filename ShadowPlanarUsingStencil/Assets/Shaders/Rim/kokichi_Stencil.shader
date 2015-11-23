Shader "kokichi/Hidden/Stencil"
{
	Properties
	{
	}
	
	SubShader
	{
		Pass
		{
			Name "PLANAR_SHADOW"
			Offset -1.0, -2.0 			
			Stencil
			{
				Ref 1
				Comp Equal
				Pass IncrSat
			}
			
			Lighting Off
			ZWrite Off
			Blend Zero One
			Fog
			{
				Mode Off
			}
 
	         CGPROGRAM
	 		
	         #pragma vertex vert 
	         #pragma fragment frag
	 
	         #include "UnityCG.cginc"
	 
	         // User-specified uniforms
	         fixed4 _ShadowColor;
	         uniform fixed4x4 _World2Receiver; // transformation from 
												// world coordinates to the coordinate system of the plane
	         uniform fixed4 _LightDir;
	            
	 
	         fixed4 vert(fixed4 vertexPos : POSITION) : SV_POSITION
	         {
	            fixed4x4 modelMatrix = _Object2World;
	            fixed4x4 modelMatrixInverse = _World2Object * unity_Scale.w;
	            fixed4 lightDirection;
	            lightDirection = lerp(normalize(_LightDir), normalize(mul(modelMatrix, vertexPos) - _LightDir), _LightDir.w);
	            fixed4 vertexInWorldSpace = mul(modelMatrix, vertexPos);
	            fixed4 world2ReceiverRow1 = fixed4(_World2Receiver[1][0], _World2Receiver[1][1], 
	               									_World2Receiver[1][2], _World2Receiver[1][3]);
	            fixed distanceOfVertex = dot(world2ReceiverRow1, vertexInWorldSpace); 
	            fixed lengthOfLightDirectionInY = dot(world2ReceiverRow1, lightDirection); 
	            if (distanceOfVertex > 0.0 && lengthOfLightDirectionInY < 0.0)
	            {
	               lightDirection = lightDirection  * (distanceOfVertex / (-lengthOfLightDirectionInY));
	            }
	            else
	            {
	               lightDirection = fixed4(0.0, 0.0, 0.0, 0.0); 
	                  // don't move vertex
	            }
	            return mul(UNITY_MATRIX_VP, vertexInWorldSpace + lightDirection);
	         }
	 
	         fixed4 frag(void) : COLOR 
	         {
	            return _ShadowColor;
	         }
			ENDCG
		}
		
	}
}
