Shader "kokichi/Hidden/Stencil(Without Receiver)"
{
	Properties
	{
		_ShadowColor ("Shadow's Color", Color) = (212,212,212,255)
//     	_LightDir("Light Direction", Vector) = (9,-148,7)
	}
	
	SubShader
	{
		Tags { "Queue" = "AlphaTest+505" }
		Pass
		{
			Name "PLANAR_SHADOW"
			Offset -1.0, -2.0 			
			Stencil
			{
				Ref 2
				Comp Always
				Pass Replace
				Fail Keep
				ZFail Keep
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
	         uniform fixed4 _ShadowColor;
	         uniform fixed4x4 _World2Receiver; // transformation from 
												// world coordinates to the coordinate system of the plane
	         uniform fixed4 _LightDir;
	            
	 
	         fixed4 vert(fixed4 vertexPos : POSITION) : SV_POSITION
	         {
	            fixed4x4 modelMatrix = _Object2World;
	            fixed4x4 modelMatrixInverse = _World2Object * unity_Scale.w;
	            modelMatrixInverse[3][3] = 1.0; 
	            fixed4x4 viewMatrix = mul(UNITY_MATRIX_MV, modelMatrixInverse);
	 
	            fixed4 lightDirection = normalize(_LightDir);
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
