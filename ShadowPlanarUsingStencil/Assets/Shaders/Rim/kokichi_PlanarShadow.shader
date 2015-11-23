Shader "kokichi/Hidden/PlanarShadow"
{
	Properties
	{
		_ShadowColor ("Shadow's Color", Color) = (212,212,212,255)
     	_LightDir("Light Direction", Vector) = (9,-148,7)
	}
	
	SubShader
	{
		Tags { "Queue" = "Geometry" }
		ZWrite Off
		Offset -1.0, -2.0 
				
//		Pass
//		{
//			Name "PLANAR_SHADOW"
//            // make sure shadow polygons are on top of shadow receiver
// 			Tags { "LightMode" = "ForwardBase"}
//	         CGPROGRAM
//	 		
//	         #pragma vertex vert 
//	         #pragma fragment frag
//	 
//	         #include "UnityCG.cginc"
//	 
//	         // User-specified uniforms
//	         uniform fixed4 _ShadowColor;
//	         uniform fixed4x4 _World2Receiver; // transformation from 
//												// world coordinates to the coordinate system of the plane
//	         uniform fixed4 _LightDir;
//	            
//	 
//	         fixed4 vert(fixed4 vertexPos : POSITION) : SV_POSITION
//	         {
//	            fixed4x4 modelMatrix = _Object2World;
//	            fixed4x4 modelMatrixInverse = _World2Object * unity_Scale.w;
//	            modelMatrixInverse[3][3] = 1.0; 
//	            fixed4 lightDirection;
//				if (0.0 != _LightDir.w) 
//	            {
//	               // point or spot light
//	               	lightDirection = normalize(mul(modelMatrix, vertexPos) - _LightDir);
//	            } 
//	            else 
//	            {
//	               // directional light
//	               	lightDirection = normalize(_LightDir);
//	            }
//	            
//	            fixed4 vertexInWorldSpace = mul(modelMatrix, vertexPos);
//	            fixed4 world2ReceiverRow1 = fixed4(_World2Receiver[1][0], _World2Receiver[1][1], 
//	               									_World2Receiver[1][2], _World2Receiver[1][3]);
//	            fixed distanceOfVertex = dot(world2ReceiverRow1, vertexInWorldSpace); 
//	            fixed lengthOfLightDirectionInY = dot(world2ReceiverRow1, lightDirection); 
//	            if (distanceOfVertex > 0.0 && lengthOfLightDirectionInY < 0.0)
//	            {
//	               	lightDirection = lightDirection  * (distanceOfVertex / (-lengthOfLightDirectionInY));
//	            }
//	            else
//	            {
//	               	lightDirection = fixed4(0.0, 0.0, 0.0, 0.0); 
//	                  // don't move vertex
//	            }
//	            return mul(UNITY_MATRIX_VP, vertexInWorldSpace + lightDirection);
//	         }
//	 
//	         fixed4 frag(void) : COLOR 
//	         {
//	            return _ShadowColor;
//	         }
//			ENDCG
//		}
		
		Pass
		{
			Name "PLANAR_SHADOW"
            // make sure shadow polygons are on top of shadow receiver
 			Tags { "LightMode" = "ForwardAdd"}
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
	            fixed4 lightDirection;
				if (0.0 != _LightDir.w) 
	            {
	               // point or spot light
	               	lightDirection = normalize(mul(modelMatrix, vertexPos) - _LightDir);
	            } 
	            else 
	            {
	               // directional light
	               	lightDirection = normalize(_LightDir);
	            }
	            
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
