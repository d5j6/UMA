//	============================================================
//	Name:		AtlasShader
//	Author: 	Joen Joensen (@UnLogick)
//	============================================================

Shader "UMA/AtlasShaderNormal" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_AdditiveColor ("Additive Color", Color) = (0,0,0,0)
	_MainTex ("Normalmap", 2D) = "bump" {}
	_ExtraTex ("mask", 2D) = "white" {}
	_AlphaMask("Alpha Mask", Float) = 1
}

SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}

	Pass 
	{	
		Tags { "LightMode" = "Vertex" }
    	Fog { Mode Off }
		Blend Zero SrcAlpha
		Lighting Off
CGPROGRAM
#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"

float4 _Color;
float4 _AdditiveColor;
float _AlphaMask;
sampler2D _MainTex;
sampler2D _ExtraTex;

struct v2f {
    float4  pos : SV_POSITION;
    float2  uv : TEXCOORD0;
};

float4 _MainTex_ST;

v2f vert (appdata_base v)
{
    v2f o;
    o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
    o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
    return o;
}

half4 frag (v2f i) : COLOR
{
	float mask = tex2D(_ExtraTex, i.uv).a * _AlphaMask;
	float value = 1 - mask;
    return half4(value, value, value, value);
}
ENDCG
	}
	Pass 
	{
		Tags { "LightMode" = "Vertex" }
   		Fog { Mode Off }
		Blend One One
		Lighting Off
CGPROGRAM
#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"

float4 _Color;
float4 _AdditiveColor;
float _AlphaMask;
sampler2D _MainTex;
sampler2D _ExtraTex;

struct v2f {
    float4  pos : SV_POSITION;
    float2  uv : TEXCOORD0;
};

float4 _MainTex_ST;

v2f vert (appdata_base v)
{
    v2f o;
    o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
    o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
    return o;
}

half4 frag (v2f i) : COLOR
{
    half4 texcol = tex2D (_MainTex, i.uv) * _Color + _AdditiveColor;
	float mask = tex2D(_ExtraTex, i.uv).a * _AlphaMask;
	return texcol * mask;
}
ENDCG
	}
}

Fallback "Transparent/VertexLit"
} 
