Shader "UnityCoder/Rays2"
{
    Properties 
    {
        tDiffuse ("Base (RGB)", 2D) = "white" {}
        fX ("fX", Float) = 0.5 // you can feed mouse xpos here with script: var mpos:Vector3 = Camera.main.ScreenToViewportPoint(Input.mousePosition); renderer.material.SetFloat( "fX", mpos.x);
        fY ("fY", Float) = 0.5 //  mouse ypos
        fExposure ("fExposure", Float) = 0.6
        fDecay ("fDecay", Float) = 0.93
        fDensity ("fDensity", Float) = 0.96
        fWeight ("fWeight", Float) = 0.4
        fClamp ("fClamp", Float) = 1.0
        //iSamples ("iSamples", Int) = 20
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200
        Cull Off
         
        CGPROGRAM
        #pragma target 3.0
        #pragma surface surf Lambert
 
        sampler2D tDiffuse;
        float fX,fY,fExposure,fDecay,fDensity,fWeight,fClamp,iSamples;
 
        struct Input {
            float2 uvtDiffuse;
            float4 screenPos;
        };
 
        void surf (Input IN, inout SurfaceOutput o) 
        {
            int iSamples=100;
            float2 vUv = IN.uvtDiffuse;
            //vUv *= float2(1,1); // repeat?
            float2 deltaTextCoord = float2(vUv - float2(fX,fY));
            deltaTextCoord *= 1.0 /  float(iSamples) * fDensity;
            float2 coord = vUv;
            float illuminationDecay = 1.0;
            float4 FragColor = float4(0.0);
            for(int i=0; i < iSamples ; i++)
            {
                coord -= deltaTextCoord;
                float4 texel = tex2D(tDiffuse, coord);
                texel *= illuminationDecay * fWeight;
                FragColor += texel;
                illuminationDecay *= fDecay;
            }
            FragColor *= fExposure;
            FragColor = clamp(FragColor, 0.0, fClamp);
            float4 c = FragColor;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
             
        }
        ENDCG
    } 
    FallBack "Diffuse"
}