﻿Shader "WorldUV/Localized/BumpedNocolor"
{
	Properties
	{
		_MainTex ("Base", 2D) = "white" {}
		_BumpMap ("Normalmap", 2D) = "bump" {}
		_ScaleX ("Scale X", float) = 1.0
		_ScaleY ("Scale Y", float) = 1.0
	}

	SubShader
	{
		Tags { "RenderType"="Opaque" }
		//LOD 400

		CGPROGRAM
		#pragma surface surf Lambert

		struct Input
		{
			float3 worldPos;
			float3 worldNormal; INTERNAL_DATA
		};

		sampler2D _MainTex;
		sampler2D _BumpMap;

		half _ScaleX;
		half _ScaleY;

		void surf (Input IN, inout SurfaceOutput o)
		{
			float3 correctWorldNormal = WorldNormalVector(IN, float3(0.0, 0.0, 1.0));
			float3 pos = IN.worldPos - mul(_Object2World, float4(0.0, 0.0, 0.0, 1.0));
			float2 uv = pos.xz;

			if (abs(correctWorldNormal.x) > 0.5)
				uv = pos.zy;
			else if (abs(correctWorldNormal.z) > 0.5)
				uv = pos.xy;

			uv.x *= _ScaleX;
			uv.y *= _ScaleY;

			o.Albedo = tex2D(_MainTex, uv).rgb;
			o.Normal = UnpackNormal(tex2D(_BumpMap, uv));
		}

		ENDCG
	}

	FallBack "WorldUV/Localized/Cheap"
}