//HvA - GP - 2018
//https://en.wikipedia.org/wiki/Gouraud_shading

Shader "HvA/Phong_DiffuseOnly"
{
	Properties
	{
		_DiffuseColor ("Diffuse Color", Color) = (1.0, 1.0, 1.0, 1.0)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "LightMode" = "ForwardBase"}

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"


			uniform float4 _LightColor0; 
			uniform	float4 _DiffuseColor;

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 worldNormal : TEXCOORD1;
			};

			
			//verter shader
			v2f vert (appdata v)
			{
				v2f o;

				//transform vertices based on object transform (unity equivalent mul(UNITY_MATRIX_MVP, float4(pos, 1.0)))
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject)); 

				return o;
			}
			
			//pixel shader
			fixed4 frag (v2f i) : SV_Target
			{
				float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);//Pos0 gives the direction vector of the first directional light in the scene

				float NdotL  = max(0.0, dot(i.worldNormal, lightDir));
				float3 diffuse = _DiffuseColor * _LightColor0.rgb * NdotL;

				return float4(diffuse, 0);
			}

			ENDCG
		}
	}
}
