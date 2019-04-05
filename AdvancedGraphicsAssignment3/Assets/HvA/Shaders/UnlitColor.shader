//HvA - GP - 2018

Shader "HvA/UnlitColor"
{
	Properties
	{
		_DiffuseColor ("Diffuse Color", Color) = (1.0, 1.0, 1.0, 1.0)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
			};

			float4 _DiffuseColor;
			
			//verter shader
			v2f vert (appdata v)
			{
				v2f o;

				//transform vertices based on object transform (unity equivalent mul(UNITY_MATRIX_MVP, float4(pos, 1.0)))
				o.vertex = UnityObjectToClipPos(v.vertex);

				return o;
			}
			
			//pixel shader
			fixed4 frag (v2f i) : SV_Target
			{
				return _DiffuseColor;
			}

			ENDCG
		}
	}
}
