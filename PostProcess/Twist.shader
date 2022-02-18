Shader "Hidden/Twist"
{
    Properties
    {
        _Transition ("Transition", Range(0, 1)) = 1
        _OverlayTex ("Overlay Tex", 2D) = "white" {}
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            sampler2D _OverlayTex;
            float _Transition;

            float2 centerize_uv(float2 uv)
            {
                uv.x -= 0.5;
                uv.x *= 2;
                uv.y -= 0.5;
                uv.y *= 2;
                return uv;
            }
            float2 redo_centrize_uv(float2 uv)
            {
                uv.x /= 2;
                uv.x += 0.5;
                uv.y /= 2;
                uv.y += 0.5;
                return uv;
            }


            // angle in radians
            float2 rotate_around_center(float2 p, float angle)
            {
                float s = sin(angle);
                float c = cos(angle);

                return float2(  p.x * c - p.y * s, 
                                p.x * s + p.y * c);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 old_uv = i.uv;
                i.uv = centerize_uv(i.uv);

                float lerp_val = min(1, _Transition + _Transition * distance(i.uv, 0));
                
                i.uv = rotate_around_center(i.uv, 6.28318530718 * lerp_val);

                
                i.uv = redo_centrize_uv(i.uv);

                fixed4 overlayCol = tex2D(_OverlayTex, i.uv);
                // fixed4 overlayCol = fixed4(1, 0, 0, 0);
                fixed4 mainCol = tex2D(_MainTex, i.uv);
                fixed4 col = lerp(overlayCol, mainCol, lerp_val);
                return col;
            }
            ENDCG
        }
    }
}
