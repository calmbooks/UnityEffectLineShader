Shader "Custom/GruGruEffect" {

    Properties {
        _FPS ("FPS", Float) = 8.0
	    _TEX ("Base (RGB)", 2D) = "white" {}        
        _WEIGHT ("Weight", Range(0.0, 1.0)) = 0.5
        _CIRCLE ("Circle", Range(0.0, 1.0)) = 0.5
        _DENSITY ("Density", Range(0.0, 1.0)) = 0.95
        _CENTER_X ("Center X", Range(0.0, 1.0)) = 0.5
        _CENTER_Y ("Center Y", Range(0.0, 1.0)) = 0.5
        _COLOR ("Color", Color) = (0.0,0.0,1.0,1.0)
    }
    SubShader {

        ZWrite Off

        Blend SrcAlpha OneMinusSrcAlpha

        Pass {
            CGPROGRAM

            #include "UnityCG.cginc"

            #pragma vertex vert_img
            #pragma fragment frag
            #pragma target 3.0

            #define PI 3.14159

            fixed4 _COLOR;

            float _FPS;
            float _WEIGHT;
            float _CIRCLE;
            float _DENSITY;
            float _CENTER_X;
            float _CENTER_Y;
            sampler2D _TEX;

            float getNoise( vec2 val ) {
                return frac(sin(dot(val.xy ,vec2(12.9898,78.233))) * 437.5453);
            }

            float getFrameTime() {
                return floor(_Time.y * _FPS) / _FPS;
            }

            float4 frag( v2f_img i ) : COLOR {

                /*
                vec2 vec = i.uv.xy - vec2(0.5);

                float l = length(vec);
                float r = atan2(vec.y, vec.x) + PI; // 0-2π
                float t = _Time.y*10;
                float c = sin(l*70+r+t);

                float3 rgb = (float4(1) - _Color) * c;
                rgb = float3(1) - rgb;

                return float4(rgb,_Color.a);
                */

                float4 texColor = tex2D(_TEX, i.uv);

                vec2 vecToCenter = i.uv.xy - vec2(_CENTER_X,_CENTER_Y);
                
                float t = getFrameTime();
                float l = length(vecToCenter) / length(vec2(0.0,0.0) - vec2(0.0,0.5));
                float r = (atan(vecToCenter.y, vecToCenter.x) + PI) / (2.0 * PI);
                float w = mix(3000.0,70.0,_WEIGHT);
                float r2 = floor(r * w) / w * max(fmod(t,10.0), 0.1);
                float den = mix(10.0,0.01,_DENSITY);
                float ran = getNoise( vec2(r2, r2) ) * den + (_CIRCLE * 0.5);

                if( l > ran ) {
                    float4 color = float4(_COLOR.rgb, _COLOR.a * (l - ran));
                    return float4(texColor.rgb + color.rgb * color.a, 1.0);
                }
                return float4(texColor.rgb, 1.0);

                /*
                float3 rgb = (float3(1.0) - _COLOR) * (l - ran);
                rgb = float3(1.0) - rgb;

                return float4(rgb,1.0);
                */

            }

            ENDCG
        }
    }
    Fallback "Diffuse"
}
