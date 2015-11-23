shader "CodexShader/Metal/Cook-Torrance"
{
 properties
  {
  _Color ("Main Color", Color) = (1,1,1,1)
  
    _SpecularColor ("Specular Color", Color) = (1,1,1,1)
  
    _MainTex ("Base (RGB) Specular Mask (A)", 2D) = "white" {}
 
    _BumpMap ("Normalmap", 2D) = "bump" {}
    
    _ReflectionTex ("Reflection Tex", 2D) = "white" {}
    
    _ReflectionMask ("Reflection Mask", 2D) = "white" {}
 
    _Fo("F0",range(0,1))=0.3
 
    _Dm("Dm",range(0,1))=0.3
        
    _DiffAmount("DiffAmount" , range (1,3)) = 1.5
  }
 
  subshader
  {
   Tags{ "rendertype"="opaque" }
   LOD 200
   
    CGPROGRAM
    #pragma surface surf Cook_Torrance vertex:vert
    #pragma target 3.0
   #include "UnityCG.cginc"
   
    uniform sampler2D _MainTex;
    uniform sampler2D _BumpMap;
    uniform sampler2D _ReflectionTex;
    uniform sampler2D _ReflectionMask;
 
    uniform fixed4 _Color;
    uniform fixed4 _SpecularColor;
    uniform fixed _Fo;
    uniform fixed _Dm;
    uniform fixed _DiffAmount;
    
   struct SurfaceOutputRefl
   {
      fixed3 Albedo;
      fixed3 ReflAlbedo;
      fixed3 Normal;
      fixed3 Emission;
      fixed Specular;
      fixed Alpha;
      fixed MaskAlpha;
      fixed ReflMaskAlpha;
  };

    fixed4 LightingCook_Torrance( SurfaceOutputRefl s, fixed3 lightDir, fixed3 viewDir, fixed atten )
    {  
      fixed kd= saturate( dot( normalize( s.Normal ), normalize( lightDir ) ) );
      fixed4 diffuseColor;
      diffuseColor.rgb = kd  * s.Albedo * _LightColor0 * atten;
      diffuseColor = lerp( diffuseColor, fixed4( s.ReflAlbedo, 0.0 ), s.ReflMaskAlpha );
      diffuseColor.a=1;
      
      fixed3 V = normalize( viewDir );
    fixed3 L = normalize( lightDir );
      fixed3 N = normalize( s.Normal );
      fixed3 H = normalize( V + L );
      fixed NV = dot( N, V );
   fixed NH = dot( N, H );
   fixed VH = dot( V, H );
   fixed NL = dot( N, L );
   fixed LH = dot( L, H );
      
    fixed F = _Fo + ( 1 - _Fo ) * ( pow( 1 - dot( V, H ), 5 ) );  
      fixed NH2 = NH * NH;
   fixed D = exp( ( NH2 - 1 ) / ( NH2 * _Dm * _Dm ) ) / ( 4 * _Dm * _Dm * NH2 * NH2 );
   fixed G1 = 2 * NH * NV / VH;
   fixed G2 = 2 * NH * NL / VH;
    fixed G = min( 1, min( G1, G2 ) );
      
      fixed4 c;
 
      c = diffuseColor + ( _SpecularColor * max( 0, F * D * G / NV ) * ( 1 - s.MaskAlpha ) );
 
      c.a= 1;
      return c;
     }
 
     struct Input 
     {
      fixed2 uv_MainTex;
      fixed2 uv_BumpMap;
      fixed3 TtoV0;
         fixed3 TtoV1;
    };
   
   void vert ( inout appdata_full v, out Input o ) 
   {                   
            TANGENT_SPACE_ROTATION;
            o.TtoV0 = mul(rotation, UNITY_MATRIX_IT_MV[0].xyz);
            o.TtoV1 = mul(rotation, UNITY_MATRIX_IT_MV[1].xyz);
   } 
   
    void surf( in Input IN, inout SurfaceOutputRefl o )
    {
      fixed4 tex = tex2D(_MainTex, IN.uv_MainTex );
      o.Albedo = (_Color.rgb * tex.rgb) * _DiffAmount;
      o.MaskAlpha = tex.a;
      o.Normal = UnpackNormal( tex2D( _BumpMap, IN.uv_BumpMap ) );
      fixed2 vn;
            vn.x = dot( IN.TtoV0, o.Normal );
            vn.y = dot( IN.TtoV1, o.Normal );
      o.ReflAlbedo = tex2D( _ReflectionTex, vn * 0.5 + 0.5 ).rgb;
      o.ReflMaskAlpha = tex2D( _ReflectionMask, IN.uv_MainTex ).r;
      o.Alpha = 1;
    }
   ENDCG
  }
  FallBack "Diffuse"
}
