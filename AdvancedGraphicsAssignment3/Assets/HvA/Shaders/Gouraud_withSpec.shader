//HvA - GP - 2018
//https://en.wikipedia.org/wiki/Gouraud_shading

Shader "HvA/Gouraud_withSpec"
{
	Properties
	{
		_DiffuseColor ("Diffuse Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_SpecularColor ("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_Shininess ("Shininess", Float) = 10

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
			uniform	float4 _SpecularColor;
			uniform	float _Shininess;

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 color : COLOR0;
			};

			
			//verter shader
			v2f vert (appdata v)
			{
				v2f o;

				//transform vertices based on object transform (unity equivalent mul(UNITY_MATRIX_MVP, float4(pos, 1.0)))
				o.vertex = UnityObjectToClipPos(v.vertex);

				float3 normalDir = normalize(mul(unity_ObjectToWorld, v.normal));//normal direction in world space for light calc
				float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);//Pos0 gives the direction vector of the first directional light in the scene
				float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex));//camera direction relative to the vertex

				// diffuse
				float NdotL = max(0.0, dot(normalDir, lightDir));
				float3 diffuse = _DiffuseColor * _LightColor0.rgb * NdotL;
			
				// reflection of LightDir by the normal
				float3 reflectedDir = reflect(-lightDir, normalDir);
				float rv = max(0.0, dot(reflectedDir, viewDir));
				
				float specularAmount = pow(rv, _Shininess);

				float3 specularLight = _SpecularColor.rgb * _LightColor0.rgb * specularAmount;


				o.color = float4(diffuse + specularLight, 1);

				return o;
			}
			
			//pixel shader
			fixed4 frag (v2f i) : SV_Target
			{
				return i.color;
			}

			ENDCG
		}
	}
}
