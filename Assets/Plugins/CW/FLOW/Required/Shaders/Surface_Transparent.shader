// Upgrade NOTE: replaced 'defined FOG_COMBINED_WITH_WORLD_POS' with 'defined (FOG_COMBINED_WITH_WORLD_POS)'

//<HASH>-1407514345</HASH>
////////////////////////////////////////
// Generated with Better Shaders
//
// Auto-generated shader code, don't hand edit!
//
//   Unity Version: 2019.4.12f1
//   Render Pipeline: Standard
//   Platform: WindowsEditor
////////////////////////////////////////


Shader "FLOW/Surface_Transparent"
{
   Properties
   {
      


	_Sink("Sink", Float) = 1

	[Header(WAVE)]
	[NoScaleOffset]_NormalFoamMap("	Normal (RGB) Foam (A)", 2D) = "bump" {}
	_WaveStrengthMin("	Strength Min", Range(0,2)) = 0.0
	_WaveStrengthMax("	Strength Max", Range(0,2)) = 0.5
	_WaveStrengthScale("	Strength Scale", Float) = 1

	_Tiling ("	Tiling", Float) = 1
	_AnimationSpeed ("	Animation Speed", Float) = 1

	[Header(STOCHASTIC)]
	[Toggle(_STOCHASTIC_ON)] _HasStochastic ("	Enabled", Float) = 0
	[NoScaleOffset]_NoiseMap("	Noise (A)", 2D) = "black" {}

	[Header(FOAM)]
	[KeywordEnum(Off, Alpha, Cutout)] _Foam ("	Mode", Float) = 0
	_FoamBrightness("	Brightness", Range(0,2)) = 1


	[Header(FACETED)]
	[Toggle(_FACETED_ON)] _HasFaceted ("	Enabled", Float) = 0
	_FlatShadingBlend("	Flat Amount", Range(0,3)) = 0.9


	[Header(TRANSPARENCY)]
	[KeywordEnum(Off, Vertical, Depth, March Fluid, March Fluid And Depth)] _Alpha ("	Mode", Float) = 0
	_RangeMax ("	Range Max", Float) = 25
	_AlphaStep ("	Step", Float) = 2.0
	_AlphaMaxSteps ("	Max Steps", Int) = 100
	_AlphaDepthScale ("	Depth Scale", Float) = 0.1


    [Header(UNITY FOG)]
    [Toggle(DISABLEFOG)] _CW_DisableFog("	Disable", Float) = 0


   }
   SubShader
   {
      Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }

            GrabPass {"_Grab"}

      
ZWrite Off ColorMask RGB


      Pass
      {
		   Name "FORWARD"
		   Tags { "LightMode" = "ForwardBase" }
         Blend SrcAlpha OneMinusSrcAlpha
         	ZWrite On


         CGPROGRAM
         // compile directives
            #pragma vertex Vert
   #pragma fragment Frag

         #pragma target 3.0
         #pragma multi_compile_instancing
         #pragma multi_compile_fog
         #pragma multi_compile_fwdbase
         #include "HLSLSupport.cginc"
         #define UNITY_INSTANCED_LOD_FADE
         #define UNITY_INSTANCED_SH
         #define UNITY_INSTANCED_LIGHTMAPSTS

         #include "UnityShaderVariables.cginc"
         #include "UnityShaderUtilities.cginc"
         // -------- variant for: <when no other keywords are defined>

         #include "UnityCG.cginc"
         #include "Lighting.cginc"
         #include "UnityPBSLighting.cginc"
         #include "AutoLight.cginc"
         #define SHADER_PASS SHADERPASS_FORWARD
         #define _PASSFORWARD 1

         
	#include "Flow.cginc"


	#pragma shader_feature_local _ _STOCHASTIC_ON
	#pragma shader_feature_local _FOAM_OFF _FOAM_ALPHA _FOAM_CUTOUT


	#pragma shader_feature_local _ _FACETED_ON


	#pragma shader_feature_local _ALPHA_OFF _ALPHA_VERTICAL _ALPHA_DEPTH _ALPHA_MARCH_FLUID _ALPHA_MARCH_FLUID_AND_DEPTH


    #pragma shader_feature_local DISABLEFOG    


   #define _STANDARD 1

   #define _ALPHABLEND_ON 1
// If your looking in here and thinking WTF, yeah, I know. These are taken from the SRPs, to allow us to use the same
// texturing library they use. However, since they are not included in the standard pipeline by default, there is no
// way to include them in and they have to be inlined, since someone could copy this shader onto another machine without
// Better Shaders installed. Unfortunate, but I'd rather do this and have a nice library for texture sampling instead
// of the patchy one Unity provides being inlined/emulated in HDRP/URP. Strangely, PSSL and XBoxOne libraries are not
// included in the standard SRP code, but they are in tons of Unity own projects on the web, so I grabbed them from there.

#if defined(SHADER_API_GAMECORE)

	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }

	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) textureName.CalculateLevelOfDetail(samplerName, coord2)

	// Texture abstraction

	#define TEXTURE2D(textureName)                Texture2D textureName
	#define TEXTURE2D_ARRAY(textureName)          Texture2DArray textureName
	#define TEXTURECUBE(textureName)              TextureCube textureName
	#define TEXTURECUBE_ARRAY(textureName)        TextureCubeArray textureName
	#define TEXTURE3D(textureName)                Texture3D textureName

	#define TEXTURE2D_FLOAT(textureName)          TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_FLOAT(textureName)    TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_FLOAT(textureName)        TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)  TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_FLOAT(textureName)          TEXTURE3D(textureName)

	#define TEXTURE2D_HALF(textureName)           TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_HALF(textureName)     TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_HALF(textureName)         TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_HALF(textureName)   TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_HALF(textureName)           TEXTURE3D(textureName)

	#define TEXTURE2D_SHADOW(textureName)         TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_SHADOW(textureName)   TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_SHADOW(textureName)       TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_SHADOW(textureName) TEXTURECUBE_ARRAY(textureName)

	#define RW_TEXTURE2D(type, textureName)       RWTexture2D<type> textureName
	#define RW_TEXTURE2D_ARRAY(type, textureName) RWTexture2DArray<type> textureName
	#define RW_TEXTURE3D(type, textureName)       RWTexture3D<type> textureName

	#define SAMPLER(samplerName)                  SamplerState samplerName
	#define SAMPLER_CMP(samplerName)              SamplerComparisonState samplerName
	#define ASSIGN_SAMPLER(samplerName, samplerValue) samplerName = samplerValue

	#define TEXTURE2D_PARAM(textureName, samplerName)                 TEXTURE2D(textureName),         SAMPLER(samplerName)
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)           TEXTURE2D_ARRAY(textureName),   SAMPLER(samplerName)
	#define TEXTURECUBE_PARAM(textureName, samplerName)               TEXTURECUBE(textureName),       SAMPLER(samplerName)
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)         TEXTURECUBE_ARRAY(textureName), SAMPLER(samplerName)
	#define TEXTURE3D_PARAM(textureName, samplerName)                 TEXTURE3D(textureName),         SAMPLER(samplerName)

	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)          TEXTURE2D(textureName),         SAMPLER_CMP(samplerName)
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)    TEXTURE2D_ARRAY(textureName),   SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)        TEXTURECUBE(textureName),       SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_ARRAY_SHADOW_PARAM(textureName, samplerName)  TEXTURECUBE_ARRAY(textureName), SAMPLER_CMP(samplerName)

	#define TEXTURE2D_ARGS(textureName, samplerName)                textureName, samplerName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)          textureName, samplerName
	#define TEXTURECUBE_ARGS(textureName, samplerName)              textureName, samplerName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)        textureName, samplerName
	#define TEXTURE3D_ARGS(textureName, samplerName)                textureName, samplerName

	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)         textureName, samplerName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)   textureName, samplerName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)       textureName, samplerName
	#define TEXTURECUBE_ARRAY_SHADOW_ARGS(textureName, samplerName) textureName, samplerName

	#define PLATFORM_SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               textureName.Sample(samplerName, coord2)
	#define PLATFORM_SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      textureName.SampleLevel(samplerName, coord2, lod)
	#define PLATFORM_SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    textureName.SampleBias(samplerName, coord2, bias)
	#define PLATFORM_SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)              textureName.SampleGrad(samplerName, coord2, dpdx, dpdy)
	#define PLATFORM_SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  textureName.Sample(samplerName, float3(coord2, index))
	#define PLATFORM_SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         textureName.SampleLevel(samplerName, float3(coord2, index), lod)
	#define PLATFORM_SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       textureName.SampleBias(samplerName, float3(coord2, index), bias)
	#define PLATFORM_SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) textureName.SampleGrad(samplerName, float3(coord2, index), dpdx, dpdy)
	#define PLATFORM_SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             textureName.Sample(samplerName, coord3)
	#define PLATFORM_SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    textureName.SampleLevel(samplerName, coord3, lod)
	#define PLATFORM_SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  textureName.SampleBias(samplerName, coord3, bias)
	#define PLATFORM_SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)                textureName.Sample(samplerName, float4(coord3, index))
	#define PLATFORM_SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)       textureName.SampleLevel(samplerName, float4(coord3, index), lod)
	#define PLATFORM_SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)     textureName.SampleBias(samplerName, float4(coord3, index), bias)
	#define PLATFORM_SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                               textureName.Sample(samplerName, coord3)
	#define PLATFORM_SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                      textureName.SampleLevel(samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               PLATFORM_SAMPLE_TEXTURE2D(textureName, samplerName, coord2)
	#define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      PLATFORM_SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)
	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    PLATFORM_SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)              PLATFORM_SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  PLATFORM_SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         PLATFORM_SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       PLATFORM_SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) PLATFORM_SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             PLATFORM_SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    PLATFORM_SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  PLATFORM_SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)                PLATFORM_SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)       PLATFORM_SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)     PLATFORM_SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)
	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                               PLATFORM_SAMPLE_TEXTURE3D(textureName, samplerName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                      PLATFORM_SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                    textureName.SampleCmpLevelZero(samplerName, (coord3).xy, (coord3).z)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)       textureName.SampleCmpLevelZero(samplerName, float3((coord3).xy, index), (coord3).z)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                  textureName.SampleCmpLevelZero(samplerName, (coord4).xyz, (coord4).w)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)     textureName.SampleCmpLevelZero(samplerName, float4((coord4).xyz, index), (coord4).w)

	#define SAMPLE_DEPTH_TEXTURE(textureName, samplerName, coord2)          SAMPLE_TEXTURE2D(textureName, samplerName, coord2).r
	#define SAMPLE_DEPTH_TEXTURE_LOD(textureName, samplerName, coord2, lod) SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod).r

	#define LOAD_TEXTURE2D(textureName, unCoord2)                                   textureName.Load(int3(unCoord2, 0))
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)                          textureName.Load(int3(unCoord2, lod))
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)                 textureName.Load(unCoord2, sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)                      textureName.Load(int4(unCoord2, index, 0))
	#define LOAD_TEXTURE2D_ARRAY_MSAA(textureName, unCoord2, index, sampleIndex)    textureName.Load(int3(unCoord2, index), sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod)             textureName.Load(int4(unCoord2, index, lod))
	#define LOAD_TEXTURE3D(textureName, unCoord3)                                   textureName.Load(int4(unCoord3, 0))
	#define LOAD_TEXTURE3D_LOD(textureName, unCoord3, lod)                          textureName.Load(int4(unCoord3, lod))

	#define PLATFORM_SUPPORT_GATHER
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                textureName.Gather(samplerName, coord2)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)   textureName.Gather(samplerName, float3(coord2, index))
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)              textureName.Gather(samplerName, coord3)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index) textureName.Gather(samplerName, float4(coord3, index))
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)            textureName.GatherRed(samplerName, coord2)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherGreen(samplerName, coord2)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)           textureName.GatherBlue(samplerName, coord2)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherAlpha(samplerName, coord2)


#elif defined(SHADER_API_XBOXONE)
	
	// Initialize arbitrary structure with zero values.
	// Do not exist on some platform, in this case we need to have a standard name that call a function that will initialize all parameters to 0
	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }

	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) textureName.CalculateLevelOfDetail(samplerName, coord2)

	// Texture abstraction

	#define TEXTURE2D(textureName)                Texture2D textureName
	#define TEXTURE2D_ARRAY(textureName)          Texture2DArray textureName
	#define TEXTURECUBE(textureName)              TextureCube textureName
	#define TEXTURECUBE_ARRAY(textureName)        TextureCubeArray textureName
	#define TEXTURE3D(textureName)                Texture3D textureName

	#define TEXTURE2D_FLOAT(textureName)          TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_FLOAT(textureName)    TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_FLOAT(textureName)        TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)  TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_FLOAT(textureName)          TEXTURE3D(textureName)

	#define TEXTURE2D_HALF(textureName)           TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_HALF(textureName)     TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_HALF(textureName)         TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_HALF(textureName)   TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_HALF(textureName)           TEXTURE3D(textureName)

	#define TEXTURE2D_SHADOW(textureName)         TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_SHADOW(textureName)   TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_SHADOW(textureName)       TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_SHADOW(textureName) TEXTURECUBE_ARRAY(textureName)

	#define RW_TEXTURE2D(type, textureName)       RWTexture2D<type> textureName
	#define RW_TEXTURE2D_ARRAY(type, textureName) RWTexture2DArray<type> textureName
	#define RW_TEXTURE3D(type, textureName)       RWTexture3D<type> textureName

	#define SAMPLER(samplerName)                  SamplerState samplerName
	#define SAMPLER_CMP(samplerName)              SamplerComparisonState samplerName

	#define TEXTURE2D_PARAM(textureName, samplerName)                 TEXTURE2D(textureName),         SAMPLER(samplerName)
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)           TEXTURE2D_ARRAY(textureName),   SAMPLER(samplerName)
	#define TEXTURECUBE_PARAM(textureName, samplerName)               TEXTURECUBE(textureName),       SAMPLER(samplerName)
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)         TEXTURECUBE_ARRAY(textureName), SAMPLER(samplerName)
	#define TEXTURE3D_PARAM(textureName, samplerName)                 TEXTURE3D(textureName),         SAMPLER(samplerName)

	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)          TEXTURE2D(textureName),         SAMPLER_CMP(samplerName)
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)    TEXTURE2D_ARRAY(textureName),   SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)        TEXTURECUBE(textureName),       SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_ARRAY_SHADOW_PARAM(textureName, samplerName)  TEXTURECUBE_ARRAY(textureName), SAMPLER_CMP(samplerName)

	#define TEXTURE2D_ARGS(textureName, samplerName)                textureName, samplerName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)          textureName, samplerName
	#define TEXTURECUBE_ARGS(textureName, samplerName)              textureName, samplerName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)        textureName, samplerName
	#define TEXTURE3D_ARGS(textureName, samplerName)                textureName, samplerName

	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)         textureName, samplerName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)   textureName, samplerName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)       textureName, samplerName
	#define TEXTURECUBE_ARRAY_SHADOW_ARGS(textureName, samplerName) textureName, samplerName

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               textureName.Sample(samplerName, coord2)
	#define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      textureName.SampleLevel(samplerName, coord2, lod)
	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    textureName.SampleBias(samplerName, coord2, bias)
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)              textureName.SampleGrad(samplerName, coord2, dpdx, dpdy)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  textureName.Sample(samplerName, float3(coord2, index))
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         textureName.SampleLevel(samplerName, float3(coord2, index), lod)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       textureName.SampleBias(samplerName, float3(coord2, index), bias)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) textureName.SampleGrad(samplerName, float3(coord2, index), dpdx, dpdy)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    textureName.SampleLevel(samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  textureName.SampleBias(samplerName, coord3, bias)
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)                textureName.Sample(samplerName, float4(coord3, index))
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)       textureName.SampleLevel(samplerName, float4(coord3, index), lod)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)     textureName.SampleBias(samplerName, float4(coord3, index), bias)
	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                               textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                      textureName.SampleLevel(samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                    textureName.SampleCmpLevelZero(samplerName, (coord3).xy, (coord3).z)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)       textureName.SampleCmpLevelZero(samplerName, float3((coord3).xy, index), (coord3).z)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                  textureName.SampleCmpLevelZero(samplerName, (coord4).xyz, (coord4).w)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)     textureName.SampleCmpLevelZero(samplerName, float4((coord4).xyz, index), (coord4).w)

	#define LOAD_TEXTURE2D(textureName, unCoord2)                                   textureName.Load(int3(unCoord2, 0))
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)                          textureName.Load(int3(unCoord2, lod))
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)                 textureName.Load(unCoord2, sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)                      textureName.Load(int4(unCoord2, index, 0))
	#define LOAD_TEXTURE2D_ARRAY_MSAA(textureName, unCoord2, index, sampleIndex)    textureName.Load(int3(unCoord2, index), sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod)             textureName.Load(int4(unCoord2, index, lod))
	#define LOAD_TEXTURE3D(textureName, unCoord3)                                   textureName.Load(int4(unCoord3, 0))
	#define LOAD_TEXTURE3D_LOD(textureName, unCoord3, lod)                          textureName.Load(int4(unCoord3, lod))

	#define PLATFORM_SUPPORT_GATHER
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                textureName.Gather(samplerName, coord2)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)   textureName.Gather(samplerName, float3(coord2, index))
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)              textureName.Gather(samplerName, coord3)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index) textureName.Gather(samplerName, float4(coord3, index))
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)            textureName.GatherRed(samplerName, coord2)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherGreen(samplerName, coord2)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)           textureName.GatherBlue(samplerName, coord2)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherAlpha(samplerName, coord2)


#elif defined(SHADER_API_PSSL)

	// Initialize arbitrary structure with zero values.
	// Do not exist on some platform, in this case we need to have a standard name that call a function that will initialize all parameters to 0
	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }

	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) textureName.GetLOD(samplerName, coord2)

	// Texture abstraction

	#define TEXTURE2D(textureName)                Texture2D textureName
	#define TEXTURE2D_ARRAY(textureName)          Texture2DArray textureName
	#define TEXTURECUBE(textureName)              TextureCube textureName
	#define TEXTURECUBE_ARRAY(textureName)        TextureCubeArray textureName
	#define TEXTURE3D(textureName)                Texture3D textureName

	#define TEXTURE2D_FLOAT(textureName)          TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_FLOAT(textureName)    TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_FLOAT(textureName)        TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)  TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_FLOAT(textureName)          TEXTURE3D(textureName)

	#define TEXTURE2D_HALF(textureName)           TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_HALF(textureName)     TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_HALF(textureName)         TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_HALF(textureName)   TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_HALF(textureName)           TEXTURE3D(textureName)

	#define TEXTURE2D_SHADOW(textureName)         TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_SHADOW(textureName)   TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_SHADOW(textureName)       TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_SHADOW(textureName) TEXTURECUBE_ARRAY(textureName)

	#define RW_TEXTURE2D(type, textureName)       RW_Texture2D<type> textureName
	#define RW_TEXTURE2D_ARRAY(type, textureName) RW_Texture2D_Array<type> textureName
	#define RW_TEXTURE3D(type, textureName)       RW_Texture3D<type> textureName

	#define SAMPLER(samplerName)                  SamplerState samplerName
	#define SAMPLER_CMP(samplerName)              SamplerComparisonState samplerName

	#define TEXTURE2D_PARAM(textureName, samplerName)                 TEXTURE2D(textureName),         SAMPLER(samplerName)
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)           TEXTURE2D_ARRAY(textureName),   SAMPLER(samplerName)
	#define TEXTURECUBE_PARAM(textureName, samplerName)               TEXTURECUBE(textureName),       SAMPLER(samplerName)
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)         TEXTURECUBE_ARRAY(textureName), SAMPLER(samplerName)
	#define TEXTURE3D_PARAM(textureName, samplerName)                 TEXTURE3D(textureName),         SAMPLER(samplerName)

	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)          TEXTURE2D(textureName),         SAMPLER_CMP(samplerName)
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)    TEXTURE2D_ARRAY(textureName),   SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)        TEXTURECUBE(textureName),       SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_ARRAY_SHADOW_PARAM(textureName, samplerName)  TEXTURECUBE_ARRAY(textureName), SAMPLER_CMP(samplerName)

	#define TEXTURE2D_ARGS(textureName, samplerName)                textureName, samplerName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)          textureName, samplerName
	#define TEXTURECUBE_ARGS(textureName, samplerName)              textureName, samplerName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)        textureName, samplerName
	#define TEXTURE3D_ARGS(textureName, samplerName)                textureName, samplerName

	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)         textureName, samplerName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)   textureName, samplerName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)       textureName, samplerName
	#define TEXTURECUBE_ARRAY_SHADOW_ARGS(textureName, samplerName) textureName, samplerName

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               textureName.Sample(samplerName, coord2)
	#define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      textureName.SampleLevel(samplerName, coord2, lod)
	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    textureName.SampleBias(samplerName, coord2, bias)
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)              textureName.SampleGrad(samplerName, coord2, dpdx, dpdy)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  textureName.Sample(samplerName, float3(coord2, index))
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         textureName.SampleLevel(samplerName, float3(coord2, index), lod)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       textureName.SampleBias(samplerName, float3(coord2, index), bias)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) textureName.SampleGrad(samplerName, float3(coord2, index), dpdx, dpdy)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    textureName.SampleLevel(samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  textureName.SampleBias(samplerName, coord3, bias)
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)                textureName.Sample(samplerName, float4(coord3, index))
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)       textureName.SampleLevel(samplerName, float4(coord3, index), lod)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)     textureName.SampleBias(samplerName, float4(coord3, index), bias)
	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                               textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                      textureName.SampleLevel(samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                    textureName.SampleCmpLevelZero(samplerName, (coord3).xy, (coord3).z)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)       textureName.SampleCmpLevelZero(samplerName, float3((coord3).xy, index), (coord3).z)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                  textureName.SampleCmpLevelZero(samplerName, (coord4).xyz, (coord4).w)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)     textureName.SampleCmpLevelZero(samplerName, float4((coord4).xyz, index), (coord4).w)

	#define LOAD_TEXTURE2D(textureName, unCoord2)                                   textureName.Load(int3(unCoord2, 0))
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)                          textureName.Load(int3(unCoord2, lod))
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)                 textureName.Load(unCoord2, sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)                      textureName.Load(int4(unCoord2, index, 0))
	#define LOAD_TEXTURE2D_ARRAY_MSAA(textureName, unCoord2, index, sampleIndex)    textureName.Load(int3(unCoord2, index), sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod)             textureName.Load(int4(unCoord2, index, lod))
	#define LOAD_TEXTURE3D(textureName, unCoord3)                                   textureName.Load(int4(unCoord3, 0))
	#define LOAD_TEXTURE3D_LOD(textureName, unCoord3, lod)                          textureName.Load(int4(unCoord3, lod))

	#define PLATFORM_SUPPORT_GATHER
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                textureName.Gather(samplerName, coord2)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)   textureName.Gather(samplerName, float3(coord2, index))
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)              textureName.Gather(samplerName, coord3)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index) textureName.Gather(samplerName, float4(coord3, index))
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)            textureName.GatherRed(samplerName, coord2)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherGreen(samplerName, coord2)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)           textureName.GatherBlue(samplerName, coord2)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherAlpha(samplerName, coord2)



#elif defined(SHADER_API_D3D11)

	// Initialize arbitrary structure with zero values.
	// Do not exist on some platform, in this case we need to have a standard name that call a function that will initialize all parameters to 0
	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }

	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) textureName.CalculateLevelOfDetail(samplerName, coord2)

	// Texture abstraction

	#define TEXTURE2D(textureName)                Texture2D textureName
	#define TEXTURE2D_ARRAY(textureName)          Texture2DArray textureName
	#define TEXTURECUBE(textureName)              TextureCube textureName
	#define TEXTURECUBE_ARRAY(textureName)        TextureCubeArray textureName
	#define TEXTURE3D(textureName)                Texture3D textureName

	#define TEXTURE2D_FLOAT(textureName)          TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_FLOAT(textureName)    TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_FLOAT(textureName)        TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)  TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_FLOAT(textureName)          TEXTURE3D(textureName)

	#define TEXTURE2D_HALF(textureName)           TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_HALF(textureName)     TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_HALF(textureName)         TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_HALF(textureName)   TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_HALF(textureName)           TEXTURE3D(textureName)

	#define TEXTURE2D_SHADOW(textureName)         TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_SHADOW(textureName)   TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_SHADOW(textureName)       TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_SHADOW(textureName) TEXTURECUBE_ARRAY(textureName)

	#define RW_TEXTURE2D(type, textureName)       RWTexture2D<type> textureName
	#define RW_TEXTURE2D_ARRAY(type, textureName) RWTexture2DArray<type> textureName
	#define RW_TEXTURE3D(type, textureName)       RWTexture3D<type> textureName

	#define SAMPLER(samplerName)                  SamplerState samplerName
	#define SAMPLER_CMP(samplerName)              SamplerComparisonState samplerName

	#define TEXTURE2D_PARAM(textureName, samplerName)                 TEXTURE2D(textureName),         SAMPLER(samplerName)
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)           TEXTURE2D_ARRAY(textureName),   SAMPLER(samplerName)
	#define TEXTURECUBE_PARAM(textureName, samplerName)               TEXTURECUBE(textureName),       SAMPLER(samplerName)
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)         TEXTURECUBE_ARRAY(textureName), SAMPLER(samplerName)
	#define TEXTURE3D_PARAM(textureName, samplerName)                 TEXTURE3D(textureName),         SAMPLER(samplerName)

	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)          TEXTURE2D(textureName),         SAMPLER_CMP(samplerName)
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)    TEXTURE2D_ARRAY(textureName),   SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)        TEXTURECUBE(textureName),       SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_ARRAY_SHADOW_PARAM(textureName, samplerName)  TEXTURECUBE_ARRAY(textureName), SAMPLER_CMP(samplerName)

	#define TEXTURE2D_ARGS(textureName, samplerName)                textureName, samplerName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)          textureName, samplerName
	#define TEXTURECUBE_ARGS(textureName, samplerName)              textureName, samplerName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)        textureName, samplerName
	#define TEXTURE3D_ARGS(textureName, samplerName)                textureName, samplerName

	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)         textureName, samplerName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)   textureName, samplerName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)       textureName, samplerName
	#define TEXTURECUBE_ARRAY_SHADOW_ARGS(textureName, samplerName) textureName, samplerName

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               textureName.Sample(samplerName, coord2)
	#define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      textureName.SampleLevel(samplerName, coord2, lod)
	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    textureName.SampleBias(samplerName, coord2, bias)
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)              textureName.SampleGrad(samplerName, coord2, dpdx, dpdy)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  textureName.Sample(samplerName, float3(coord2, index))
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         textureName.SampleLevel(samplerName, float3(coord2, index), lod)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       textureName.SampleBias(samplerName, float3(coord2, index), bias)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) textureName.SampleGrad(samplerName, float3(coord2, index), dpdx, dpdy)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    textureName.SampleLevel(samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  textureName.SampleBias(samplerName, coord3, bias)
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)                textureName.Sample(samplerName, float4(coord3, index))
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)       textureName.SampleLevel(samplerName, float4(coord3, index), lod)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)     textureName.SampleBias(samplerName, float4(coord3, index), bias)
	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                               textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                      textureName.SampleLevel(samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                    textureName.SampleCmpLevelZero(samplerName, (coord3).xy, (coord3).z)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)       textureName.SampleCmpLevelZero(samplerName, float3((coord3).xy, index), (coord3).z)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                  textureName.SampleCmpLevelZero(samplerName, (coord4).xyz, (coord4).w)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)     textureName.SampleCmpLevelZero(samplerName, float4((coord4).xyz, index), (coord4).w)

	#define LOAD_TEXTURE2D(textureName, unCoord2)                                   textureName.Load(int3(unCoord2, 0))
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)                          textureName.Load(int3(unCoord2, lod))
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)                 textureName.Load(unCoord2, sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)                      textureName.Load(int4(unCoord2, index, 0))
	#define LOAD_TEXTURE2D_ARRAY_MSAA(textureName, unCoord2, index, sampleIndex)    textureName.Load(int3(unCoord2, index), sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod)             textureName.Load(int4(unCoord2, index, lod))
	#define LOAD_TEXTURE3D(textureName, unCoord3)                                   textureName.Load(int4(unCoord3, 0))
	#define LOAD_TEXTURE3D_LOD(textureName, unCoord3, lod)                          textureName.Load(int4(unCoord3, lod))

	#define PLATFORM_SUPPORT_GATHER
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                textureName.Gather(samplerName, coord2)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)   textureName.Gather(samplerName, float3(coord2, index))
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)              textureName.Gather(samplerName, coord3)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index) textureName.Gather(samplerName, float4(coord3, index))
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)            textureName.GatherRed(samplerName, coord2)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherGreen(samplerName, coord2)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)           textureName.GatherBlue(samplerName, coord2)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherAlpha(samplerName, coord2)

#elif defined(SHADER_API_METAL)

	// Initialize arbitrary structure with zero values.
	// Do not exist on some platform, in this case we need to have a standard name that call a function that will initialize all parameters to 0
	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }

	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) textureName.CalculateLevelOfDetail(samplerName, coord2)

	// Texture abstraction

	#define TEXTURE2D(textureName)                Texture2D textureName
	#define TEXTURE2D_ARRAY(textureName)          Texture2DArray textureName
	#define TEXTURECUBE(textureName)              TextureCube textureName
	#define TEXTURECUBE_ARRAY(textureName)        TextureCubeArray textureName
	#define TEXTURE3D(textureName)                Texture3D textureName

	#define TEXTURE2D_FLOAT(textureName)          Texture2D_float textureName
	#define TEXTURE2D_ARRAY_FLOAT(textureName)    Texture2DArray textureName    // no support to _float on Array, it's being added
	#define TEXTURECUBE_FLOAT(textureName)        TextureCube_float textureName
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)  TextureCubeArray textureName  // no support to _float on Array, it's being added
	#define TEXTURE3D_FLOAT(textureName)          Texture3D_float textureName

	#define TEXTURE2D_HALF(textureName)           Texture2D_half textureName
	#define TEXTURE2D_ARRAY_HALF(textureName)     Texture2DArray textureName    // no support to _float on Array, it's being added
	#define TEXTURECUBE_HALF(textureName)         TextureCube_half textureName
	#define TEXTURECUBE_ARRAY_HALF(textureName)   TextureCubeArray textureName  // no support to _float on Array, it's being added
	#define TEXTURE3D_HALF(textureName)           Texture3D_half textureName

	#define TEXTURE2D_SHADOW(textureName)         TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_SHADOW(textureName)   TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_SHADOW(textureName)       TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_SHADOW(textureName) TEXTURECUBE_ARRAY(textureName)

	#define RW_TEXTURE2D(type, textureName)       RWTexture2D<type> textureName
	#define RW_TEXTURE2D_ARRAY(type, textureName) RWTexture2DArray<type> textureName
	#define RW_TEXTURE3D(type, textureName)       RWTexture3D<type> textureName

	#define SAMPLER(samplerName)                  SamplerState samplerName
	#define SAMPLER_CMP(samplerName)              SamplerComparisonState samplerName

	#define TEXTURE2D_PARAM(textureName, samplerName)                 TEXTURE2D(textureName),         SAMPLER(samplerName)
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)           TEXTURE2D_ARRAY(textureName),   SAMPLER(samplerName)
	#define TEXTURECUBE_PARAM(textureName, samplerName)               TEXTURECUBE(textureName),       SAMPLER(samplerName)
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)         TEXTURECUBE_ARRAY(textureName), SAMPLER(samplerName)
	#define TEXTURE3D_PARAM(textureName, samplerName)                 TEXTURE3D(textureName),         SAMPLER(samplerName)

	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)          TEXTURE2D(textureName),         SAMPLER_CMP(samplerName)
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)    TEXTURE2D_ARRAY(textureName),   SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)        TEXTURECUBE(textureName),       SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_ARRAY_SHADOW_PARAM(textureName, samplerName)  TEXTURECUBE_ARRAY(textureName), SAMPLER_CMP(samplerName)

	#define TEXTURE2D_ARGS(textureName, samplerName)                textureName, samplerName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)          textureName, samplerName
	#define TEXTURECUBE_ARGS(textureName, samplerName)              textureName, samplerName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)        textureName, samplerName
	#define TEXTURE3D_ARGS(textureName, samplerName)                textureName, samplerName

	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)         textureName, samplerName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)   textureName, samplerName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)       textureName, samplerName
	#define TEXTURECUBE_ARRAY_SHADOW_ARGS(textureName, samplerName) textureName, samplerName

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               textureName.Sample(samplerName, coord2)
	#define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      textureName.SampleLevel(samplerName, coord2, lod)
	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    textureName.SampleBias(samplerName, coord2, bias)
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)              textureName.SampleGrad(samplerName, coord2, dpdx, dpdy)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  textureName.Sample(samplerName, float3(coord2, index))
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         textureName.SampleLevel(samplerName, float3(coord2, index), lod)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       textureName.SampleBias(samplerName, float3(coord2, index), bias)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) textureName.SampleGrad(samplerName, float3(coord2, index), dpdx, dpdy)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    textureName.SampleLevel(samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  textureName.SampleBias(samplerName, coord3, bias)
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)                textureName.Sample(samplerName, float4(coord3, index))
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)       textureName.SampleLevel(samplerName, float4(coord3, index), lod)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)     textureName.SampleBias(samplerName, float4(coord3, index), bias)
	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                               textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                      textureName.SampleLevel(samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                    textureName.SampleCmpLevelZero(samplerName, (coord3).xy, (coord3).z)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)       textureName.SampleCmpLevelZero(samplerName, float3((coord3).xy, index), (coord3).z)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                  textureName.SampleCmpLevelZero(samplerName, (coord4).xyz, (coord4).w)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)     textureName.SampleCmpLevelZero(samplerName, float4((coord4).xyz, index), (coord4).w)

	#define LOAD_TEXTURE2D(textureName, unCoord2)                                   textureName.Load(int3(unCoord2, 0))
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)                          textureName.Load(int3(unCoord2, lod))
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)                 textureName.Load(unCoord2, sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)                      textureName.Load(int4(unCoord2, index, 0))
	#define LOAD_TEXTURE2D_ARRAY_MSAA(textureName, unCoord2, index, sampleIndex)    textureName.Load(int3(unCoord2, index), sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod)             textureName.Load(int4(unCoord2, index, lod))
	#define LOAD_TEXTURE3D(textureName, unCoord3)                                   textureName.Load(int4(unCoord3, 0))
	#define LOAD_TEXTURE3D_LOD(textureName, unCoord3, lod)                          textureName.Load(int4(unCoord3, lod))

	#define PLATFORM_SUPPORT_GATHER
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                textureName.Gather(samplerName, coord2)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)   textureName.Gather(samplerName, float3(coord2, index))
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)              textureName.Gather(samplerName, coord3)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index) textureName.Gather(samplerName, float4(coord3, index))
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)            textureName.GatherRed(samplerName, coord2)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherGreen(samplerName, coord2)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)           textureName.GatherBlue(samplerName, coord2)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherAlpha(samplerName, coord2)

#elif defined(SHADER_API_VULKAN)
// This file assume SHADER_API_VULKAN is defined
	// TODO: This is a straight copy from D3D11.hlsl. Go through all this stuff and adjust where needed.


	// Initialize arbitrary structure with zero values.
	// Do not exist on some platform, in this case we need to have a standard name that call a function that will initialize all parameters to 0
	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }

	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) textureName.CalculateLevelOfDetail(samplerName, coord2)

	// Texture abstraction

	#define TEXTURE2D(textureName)                Texture2D textureName
	#define TEXTURE2D_ARRAY(textureName)          Texture2DArray textureName
	#define TEXTURECUBE(textureName)              TextureCube textureName
	#define TEXTURECUBE_ARRAY(textureName)        TextureCubeArray textureName
	#define TEXTURE3D(textureName)                Texture3D textureName

	#define TEXTURE2D_FLOAT(textureName)          Texture2D_float textureName
	#define TEXTURE2D_ARRAY_FLOAT(textureName)    Texture2DArray textureName    // no support to _float on Array, it's being added
	#define TEXTURECUBE_FLOAT(textureName)        TextureCube_float textureName
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)  TextureCubeArray textureName  // no support to _float on Array, it's being added
	#define TEXTURE3D_FLOAT(textureName)          Texture3D_float textureName

	#define TEXTURE2D_HALF(textureName)           Texture2D_half textureName
	#define TEXTURE2D_ARRAY_HALF(textureName)     Texture2DArray textureName    // no support to _float on Array, it's being added
	#define TEXTURECUBE_HALF(textureName)         TextureCube_half textureName
	#define TEXTURECUBE_ARRAY_HALF(textureName)   TextureCubeArray textureName  // no support to _float on Array, it's being added
	#define TEXTURE3D_HALF(textureName)           Texture3D_half textureName

	#define TEXTURE2D_SHADOW(textureName)         TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_SHADOW(textureName)   TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_SHADOW(textureName)       TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_SHADOW(textureName) TEXTURECUBE_ARRAY(textureName)

	#define RW_TEXTURE2D(type, textureName)       RWTexture2D<type> textureName
	#define RW_TEXTURE2D_ARRAY(type, textureName) RWTexture2DArray<type> textureName
	#define RW_TEXTURE3D(type, textureName)       RWTexture3D<type> textureName

	#define SAMPLER(samplerName)                  SamplerState samplerName
	#define SAMPLER_CMP(samplerName)              SamplerComparisonState samplerName

	#define TEXTURE2D_PARAM(textureName, samplerName)                 TEXTURE2D(textureName),         SAMPLER(samplerName)
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)           TEXTURE2D_ARRAY(textureName),   SAMPLER(samplerName)
	#define TEXTURECUBE_PARAM(textureName, samplerName)               TEXTURECUBE(textureName),       SAMPLER(samplerName)
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)         TEXTURECUBE_ARRAY(textureName), SAMPLER(samplerName)
	#define TEXTURE3D_PARAM(textureName, samplerName)                 TEXTURE3D(textureName),         SAMPLER(samplerName)

	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)          TEXTURE2D(textureName),         SAMPLER_CMP(samplerName)
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)    TEXTURE2D_ARRAY(textureName),   SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)        TEXTURECUBE(textureName),       SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_ARRAY_SHADOW_PARAM(textureName, samplerName)  TEXTURECUBE_ARRAY(textureName), SAMPLER_CMP(samplerName)

	#define TEXTURE2D_ARGS(textureName, samplerName)                textureName, samplerName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)          textureName, samplerName
	#define TEXTURECUBE_ARGS(textureName, samplerName)              textureName, samplerName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)        textureName, samplerName
	#define TEXTURE3D_ARGS(textureName, samplerName)                textureName, samplerName

	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)         textureName, samplerName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)   textureName, samplerName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)       textureName, samplerName
	#define TEXTURECUBE_ARRAY_SHADOW_ARGS(textureName, samplerName) textureName, samplerName

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               textureName.Sample(samplerName, coord2)
	#define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      textureName.SampleLevel(samplerName, coord2, lod)
	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    textureName.SampleBias(samplerName, coord2, bias)
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)              textureName.SampleGrad(samplerName, coord2, dpdx, dpdy)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  textureName.Sample(samplerName, float3(coord2, index))
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         textureName.SampleLevel(samplerName, float3(coord2, index), lod)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       textureName.SampleBias(samplerName, float3(coord2, index), bias)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) textureName.SampleGrad(samplerName, float3(coord2, index), dpdx, dpdy)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    textureName.SampleLevel(samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  textureName.SampleBias(samplerName, coord3, bias)
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)                textureName.Sample(samplerName, float4(coord3, index))
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)       textureName.SampleLevel(samplerName, float4(coord3, index), lod)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)     textureName.SampleBias(samplerName, float4(coord3, index), bias)
	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                               textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                      textureName.SampleLevel(samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                    textureName.SampleCmpLevelZero(samplerName, (coord3).xy, (coord3).z)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)       textureName.SampleCmpLevelZero(samplerName, float3((coord3).xy, index), (coord3).z)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                  textureName.SampleCmpLevelZero(samplerName, (coord4).xyz, (coord4).w)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)     textureName.SampleCmpLevelZero(samplerName, float4((coord4).xyz, index), (coord4).w)

	#define LOAD_TEXTURE2D(textureName, unCoord2)                                   textureName.Load(int3(unCoord2, 0))
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)                          textureName.Load(int3(unCoord2, lod))
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)                 textureName.Load(unCoord2, sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)                      textureName.Load(int4(unCoord2, index, 0))
	#define LOAD_TEXTURE2D_ARRAY_MSAA(textureName, unCoord2, index, sampleIndex)    textureName.Load(int3(unCoord2, index), sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod)             textureName.Load(int4(unCoord2, index, lod))
	#define LOAD_TEXTURE3D(textureName, unCoord3)                                   textureName.Load(int4(unCoord3, 0))
	#define LOAD_TEXTURE3D_LOD(textureName, unCoord3, lod)                          textureName.Load(int4(unCoord3, lod))

	#define PLATFORM_SUPPORT_GATHER
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                textureName.Gather(samplerName, coord2)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)   textureName.Gather(samplerName, float3(coord2, index))
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)              textureName.Gather(samplerName, coord3)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index) textureName.Gather(samplerName, float4(coord3, index))
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)            textureName.GatherRed(samplerName, coord2)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherGreen(samplerName, coord2)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)           textureName.GatherBlue(samplerName, coord2)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherAlpha(samplerName, coord2)

#elif defined(SHADER_API_SWITCH)
	// This file assume SHADER_API_SWITCH is defined

	// Initialize arbitrary structure with zero values.
	// Do not exist on some platform, in this case we need to have a standard name that call a function that will initialize all parameters to 0
	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }

	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) textureName.CalculateLevelOfDetail(samplerName, coord2)

	// Texture abstraction

	#define TEXTURE2D(textureName)                Texture2D textureName
	#define TEXTURE2D_ARRAY(textureName)          Texture2DArray textureName
	#define TEXTURECUBE(textureName)              TextureCube textureName
	#define TEXTURECUBE_ARRAY(textureName)        TextureCubeArray textureName
	#define TEXTURE3D(textureName)                Texture3D textureName

	#define TEXTURE2D_FLOAT(textureName)          Texture2D_float textureName
	#define TEXTURE2D_ARRAY_FLOAT(textureName)    Texture2DArray textureName    // no support to _float on Array, it's being added
	#define TEXTURECUBE_FLOAT(textureName)        TextureCube_float textureName
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)  TextureCubeArray textureName  // no support to _float on Array, it's being added
	#define TEXTURE3D_FLOAT(textureName)          Texture3D_float textureName

	#define TEXTURE2D_HALF(textureName)           Texture2D_half textureName
	#define TEXTURE2D_ARRAY_HALF(textureName)     Texture2DArray textureName    // no support to _float on Array, it's being added
	#define TEXTURECUBE_HALF(textureName)         TextureCube_half textureName
	#define TEXTURECUBE_ARRAY_HALF(textureName)   TextureCubeArray textureName  // no support to _float on Array, it's being added
	#define TEXTURE3D_HALF(textureName)           Texture3D_half textureName

	#define TEXTURE2D_SHADOW(textureName)         TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_SHADOW(textureName)   TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_SHADOW(textureName)       TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_SHADOW(textureName) TEXTURECUBE_ARRAY(textureName)

	#define RW_TEXTURE2D(type, textureName)       RWTexture2D<type> textureName
	#define RW_TEXTURE2D_ARRAY(type, textureName) RWTexture2DArray<type> textureName
	#define RW_TEXTURE3D(type, textureName)       RWTexture3D<type> textureName

	#define SAMPLER(samplerName)                  SamplerState samplerName
	#define SAMPLER_CMP(samplerName)              SamplerComparisonState samplerName

	#define TEXTURE2D_PARAM(textureName, samplerName)                 TEXTURE2D(textureName),         SAMPLER(samplerName)
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)           TEXTURE2D_ARRAY(textureName),   SAMPLER(samplerName)
	#define TEXTURECUBE_PARAM(textureName, samplerName)               TEXTURECUBE(textureName),       SAMPLER(samplerName)
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)         TEXTURECUBE_ARRAY(textureName), SAMPLER(samplerName)
	#define TEXTURE3D_PARAM(textureName, samplerName)                 TEXTURE3D(textureName),         SAMPLER(samplerName)

	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)          TEXTURE2D(textureName),         SAMPLER_CMP(samplerName)
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)    TEXTURE2D_ARRAY(textureName),   SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)        TEXTURECUBE(textureName),       SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_ARRAY_SHADOW_PARAM(textureName, samplerName)  TEXTURECUBE_ARRAY(textureName), SAMPLER_CMP(samplerName)

	#define TEXTURE2D_ARGS(textureName, samplerName)                textureName, samplerName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)          textureName, samplerName
	#define TEXTURECUBE_ARGS(textureName, samplerName)              textureName, samplerName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)        textureName, samplerName
	#define TEXTURE3D_ARGS(textureName, samplerName)                textureName, samplerName

	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)         textureName, samplerName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)   textureName, samplerName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)       textureName, samplerName
	#define TEXTURECUBE_ARRAY_SHADOW_ARGS(textureName, samplerName) textureName, samplerName

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               textureName.Sample(samplerName, coord2)
	#define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      textureName.SampleLevel(samplerName, coord2, lod)
	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    textureName.SampleBias(samplerName, coord2, bias)
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)              textureName.SampleGrad(samplerName, coord2, dpdx, dpdy)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  textureName.Sample(samplerName, float3(coord2, index))
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         textureName.SampleLevel(samplerName, float3(coord2, index), lod)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       textureName.SampleBias(samplerName, float3(coord2, index), bias)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) textureName.SampleGrad(samplerName, float3(coord2, index), dpdx, dpdy)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    textureName.SampleLevel(samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  textureName.SampleBias(samplerName, coord3, bias)
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)                textureName.Sample(samplerName, float4(coord3, index))
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)       textureName.SampleLevel(samplerName, float4(coord3, index), lod)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)     textureName.SampleBias(samplerName, float4(coord3, index), bias)
	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                               textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                      textureName.SampleLevel(samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                    textureName.SampleCmpLevelZero(samplerName, (coord3).xy, (coord3).z)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)       textureName.SampleCmpLevelZero(samplerName, float3((coord3).xy, index), (coord3).z)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                  textureName.SampleCmpLevelZero(samplerName, (coord4).xyz, (coord4).w)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)     textureName.SampleCmpLevelZero(samplerName, float4((coord4).xyz, index), (coord4).w)


	#define LOAD_TEXTURE2D(textureName, unCoord2)                       textureName.Load(int3(unCoord2, 0))
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)              textureName.Load(int3(unCoord2, lod))
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)     textureName.Load(unCoord2, sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)          textureName.Load(int4(unCoord2, index, 0))
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod) textureName.Load(int4(unCoord2, index, lod))
	#define LOAD_TEXTURE3D(textureName, unCoord3)                       textureName.Load(int4(unCoord3, 0))
	#define LOAD_TEXTURE3D_LOD(textureName, unCoord3, lod)              textureName.Load(int4(unCoord3, lod))

	#define PLATFORM_SUPPORT_GATHER
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                textureName.Gather(samplerName, coord2)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)   textureName.Gather(samplerName, float3(coord2, index))
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)              textureName.Gather(samplerName, coord3)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index) textureName.Gather(samplerName, float4(coord3, index))
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)            textureName.GatherRed(samplerName, coord2)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherGreen(samplerName, coord2)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)           textureName.GatherBlue(samplerName, coord2)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherAlpha(samplerName, coord2)

#elif defined(SHADER_API_GLCORE)

	// OpenGL 4.1 SM 5.0 https://docs.unity3d.com/Manual/SL-ShaderCompileTargets.html
	#if (SHADER_TARGET >= 46)
	#define OPENGL4_1_SM5 1
	#else
	#define OPENGL4_1_SM5 0
	#endif

	// Initialize arbitrary structure with zero values.
	// Do not exist on some platform, in this case we need to have a standard name that call a function that will initialize all parameters to 0
	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }

	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) textureName.CalculateLevelOfDetail(samplerName, coord2)

	// Texture abstraction

	#define TEXTURE2D(textureName)                  Texture2D textureName
	#define TEXTURE2D_ARRAY(textureName)            Texture2DArray textureName
	#define TEXTURECUBE(textureName)                TextureCube textureName
	#define TEXTURECUBE_ARRAY(textureName)          TextureCubeArray textureName
	#define TEXTURE3D(textureName)                  Texture3D textureName

	#define TEXTURE2D_FLOAT(textureName)            TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_FLOAT(textureName)      TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_FLOAT(textureName)          TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)    TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_FLOAT(textureName)            TEXTURE3D(textureName)

	#define TEXTURE2D_HALF(textureName)             TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_HALF(textureName)       TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_HALF(textureName)           TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_HALF(textureName)     TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_HALF(textureName)             TEXTURE3D(textureName)

	#define TEXTURE2D_SHADOW(textureName)           TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_SHADOW(textureName)     TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_SHADOW(textureName)         TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_SHADOW(textureName)   TEXTURECUBE_ARRAY(textureName)

	#define RW_TEXTURE2D(type, textureName)         RWTexture2D<type> textureName
	#define RW_TEXTURE2D_ARRAY(type, textureName)   RWTexture2DArray<type> textureName
	#define RW_TEXTURE3D(type, textureName)         RWTexture3D<type> textureName

	#define SAMPLER(samplerName)                    SamplerState samplerName
	#define SAMPLER_CMP(samplerName)                SamplerComparisonState samplerName

	#define TEXTURE2D_PARAM(textureName, samplerName)                 TEXTURE2D(textureName),         SAMPLER(samplerName)
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)           TEXTURE2D_ARRAY(textureName),   SAMPLER(samplerName)
	#define TEXTURECUBE_PARAM(textureName, samplerName)               TEXTURECUBE(textureName),       SAMPLER(samplerName)
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)         TEXTURECUBE_ARRAY(textureName), SAMPLER(samplerName)
	#define TEXTURE3D_PARAM(textureName, samplerName)                 TEXTURE3D(textureName),         SAMPLER(samplerName)

	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)          TEXTURE2D(textureName),         SAMPLER_CMP(samplerName)
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)    TEXTURE2D_ARRAY(textureName),   SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)        TEXTURECUBE(textureName),       SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_ARRAY_SHADOW_PARAM(textureName, samplerName)  TEXTURECUBE_ARRAY(textureName), SAMPLER_CMP(samplerName)

	#define TEXTURE2D_ARGS(textureName, samplerName)                textureName, samplerName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)          textureName, samplerName
	#define TEXTURECUBE_ARGS(textureName, samplerName)              textureName, samplerName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)        textureName, samplerName
	#define TEXTURE3D_ARGS(textureName, samplerName)                textureName, samplerName

	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)         textureName, samplerName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)   textureName, samplerName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)       textureName, samplerName
	#define TEXTURECUBE_ARRAY_SHADOW_ARGS(textureName, samplerName) textureName, samplerName

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               textureName.Sample(samplerName, coord2)
	#define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      textureName.SampleLevel(samplerName, coord2, lod)
	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    textureName.SampleBias(samplerName, coord2, bias)
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, ddx, ddy)                textureName.SampleGrad(samplerName, coord2, ddx, ddy)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  textureName.Sample(samplerName, float3(coord2, index))
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         textureName.SampleLevel(samplerName, float3(coord2, index), lod)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       textureName.SampleBias(samplerName, float3(coord2, index), bias)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) textureName.SampleGrad(samplerName, float3(coord2, index), dpdx, dpdy)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    textureName.SampleLevel(samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  textureName.SampleBias(samplerName, coord3, bias)
	#ifdef UNITY_NO_CUBEMAP_ARRAY
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)           ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY)
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)  ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY_LOD)
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, bias) ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY_LOD)
	#else
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)           textureName.Sample(samplerName, float4(coord3, index))
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)  textureName.SampleLevel(samplerName, float4(coord3, index), lod)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)textureName.SampleBias(samplerName, float4(coord3, index), bias)
	#endif
	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                          textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                 textureName.SampleLevel(samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                   textureName.SampleCmpLevelZero(samplerName, (coord3).xy, (coord3).z)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)      textureName.SampleCmpLevelZero(samplerName, float3((coord3).xy, index), (coord3).z)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                 textureName.SampleCmpLevelZero(samplerName, (coord4).xyz, (coord4).w)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)    textureName.SampleCmpLevelZero(samplerName, float4((coord4).xyz, index), (coord4).w)

	#define LOAD_TEXTURE2D(textureName, unCoord2)                                   textureName.Load(int3(unCoord2, 0))
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)                          textureName.Load(int3(unCoord2, lod))
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)                 textureName.Load(unCoord2, sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)                      textureName.Load(int4(unCoord2, index, 0))
	#define LOAD_TEXTURE2D_ARRAY_MSAA(textureName, unCoord2, index, sampleIndex)    textureName.Load(int3(unCoord2, index), sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod)             textureName.Load(int4(unCoord2, index, lod))

	#if OPENGL4_1_SM5
	#define PLATFORM_SUPPORT_GATHER
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                  textureName.Gather(samplerName, coord2)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)     textureName.Gather(samplerName, float3(coord2, index))
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)                textureName.Gather(samplerName, coord3)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)   textureName.Gather(samplerName, float4(coord3, index))
	#else
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                  ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURE2D)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)     ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURE2D_ARRAY)
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)                ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURECUBE)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)   ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURECUBE_ARRAY)
	#endif


	#elif defined(SHADER_API_GLES3)

	// GLES 3.1 + AEP shader feature https://docs.unity3d.com/Manual/SL-ShaderCompileTargets.html
	#if (SHADER_TARGET >= 40)
	#define GLES3_1_AEP 1
	#else
	#define GLES3_1_AEP 0
	#endif

	// Initialize arbitrary structure with zero values.
	// Do not exist on some platform, in this case we need to have a standard name that call a function that will initialize all parameters to 0
	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }

	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) textureName.CalculateLevelOfDetail(samplerName, coord2)

	// Texture abstraction

	#define TEXTURE2D(textureName)                  Texture2D textureName
	#define TEXTURE2D_ARRAY(textureName)            Texture2DArray textureName
	#define TEXTURECUBE(textureName)                TextureCube textureName
	#define TEXTURECUBE_ARRAY(textureName)          TextureCubeArray textureName
	#define TEXTURE3D(textureName)                  Texture3D textureName

	#define TEXTURE2D_FLOAT(textureName)            Texture2D_float textureName
	#define TEXTURE2D_ARRAY_FLOAT(textureName)      Texture2DArray textureName    // no support to _float on Array, it's being added
	#define TEXTURECUBE_FLOAT(textureName)          TextureCube_float textureName
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)    TextureCubeArray textureName  // no support to _float on Array, it's being added
	#define TEXTURE3D_FLOAT(textureName)            Texture3D_float textureName

	#define TEXTURE2D_HALF(textureName)             Texture2D_half textureName
	#define TEXTURE2D_ARRAY_HALF(textureName)       Texture2DArray textureName    // no support to _float on Array, it's being added
	#define TEXTURECUBE_HALF(textureName)           TextureCube_half textureName
	#define TEXTURECUBE_ARRAY_HALF(textureName)     TextureCubeArray textureName  // no support to _float on Array, it's being added
	#define TEXTURE3D_HALF(textureName)             Texture3D_half textureName

	#define TEXTURE2D_SHADOW(textureName)           TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_SHADOW(textureName)     TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_SHADOW(textureName)         TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_SHADOW(textureName)   TEXTURECUBE_ARRAY(textureName)

	#if GLES3_1_AEP
	#define RW_TEXTURE2D(type, textureName)         RWTexture2D<type> textureName
	#define RW_TEXTURE2D_ARRAY(type, textureName)   RWTexture2DArray<type> textureName
	#define RW_TEXTURE3D(type, textureName)         RWTexture3D<type> textureName
	#else
	#define RW_TEXTURE2D(type, textureName)         ERROR_ON_UNSUPPORTED_FUNCTION(RWTexture2D)
	#define RW_TEXTURE2D_ARRAY(type, textureName)   ERROR_ON_UNSUPPORTED_FUNCTION(RWTexture2DArray)
	#define RW_TEXTURE3D(type, textureName)         ERROR_ON_UNSUPPORTED_FUNCTION(RWTexture3D)
	#endif

	#define SAMPLER(samplerName)                    SamplerState samplerName
	#define SAMPLER_CMP(samplerName)                SamplerComparisonState samplerName

	#define TEXTURE2D_PARAM(textureName, samplerName)                 TEXTURE2D(textureName),         SAMPLER(samplerName)
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)           TEXTURE2D_ARRAY(textureName),   SAMPLER(samplerName)
	#define TEXTURECUBE_PARAM(textureName, samplerName)               TEXTURECUBE(textureName),       SAMPLER(samplerName)
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)         TEXTURECUBE_ARRAY(textureName), SAMPLER(samplerName)
	#define TEXTURE3D_PARAM(textureName, samplerName)                 TEXTURE3D(textureName),         SAMPLER(samplerName)

	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)          TEXTURE2D(textureName),         SAMPLER_CMP(samplerName)
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)    TEXTURE2D_ARRAY(textureName),   SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)        TEXTURECUBE(textureName),       SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_ARRAY_SHADOW_PARAM(textureName, samplerName)  TEXTURECUBE_ARRAY(textureName), SAMPLER_CMP(samplerName)

	#define TEXTURE2D_ARGS(textureName, samplerName)                textureName, samplerName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)          textureName, samplerName
	#define TEXTURECUBE_ARGS(textureName, samplerName)              textureName, samplerName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)        textureName, samplerName
	#define TEXTURE3D_ARGS(textureName, samplerName)                textureName, samplerName

	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)         textureName, samplerName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)   textureName, samplerName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)       textureName, samplerName
	#define TEXTURECUBE_ARRAY_SHADOW_ARGS(textureName, samplerName) textureName, samplerName

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               textureName.Sample(samplerName, coord2)
	#define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      textureName.SampleLevel(samplerName, coord2, lod)
	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    textureName.SampleBias(samplerName, coord2, bias)
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, ddx, ddy)                textureName.SampleGrad(samplerName, coord2, ddx, ddy)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  textureName.Sample(samplerName, float3(coord2, index))
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         textureName.SampleLevel(samplerName, float3(coord2, index), lod)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       textureName.SampleBias(samplerName, float3(coord2, index), bias)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) textureName.SampleGrad(samplerName, float3(coord2, index), dpdx, dpdy)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    textureName.SampleLevel(samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  textureName.SampleBias(samplerName, coord3, bias)

	#ifdef UNITY_NO_CUBEMAP_ARRAY
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)           ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY)
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)  ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY_LOD)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY_BIAS)
	#else
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)           textureName.Sample(samplerName, float4(coord3, index))
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)  textureName.SampleLevel(samplerName, float4(coord3, index), lod)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)textureName.SampleBias(samplerName, float4(coord3, index), bias)
	#endif

	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                          textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                 textureName.SampleLevel(samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                   textureName.SampleCmpLevelZero(samplerName, (coord3).xy, (coord3).z)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)      textureName.SampleCmpLevelZero(samplerName, float3((coord3).xy, index), (coord3).z)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                 textureName.SampleCmpLevelZero(samplerName, (coord4).xyz, (coord4).w)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)    textureName.SampleCmpLevelZero(samplerName, float4((coord4).xyz, index), (coord4).w)


	#define LOAD_TEXTURE2D(textureName, unCoord2)                                       textureName.Load(int3(unCoord2, 0))
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)                              textureName.Load(int3(unCoord2, lod))
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)                     textureName.Load(unCoord2, sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)                          textureName.Load(int4(unCoord2, index, 0))
	#define LOAD_TEXTURE2D_ARRAY_MSAA(textureName, unCoord2, index, sampleIndex)        textureName.Load(int3(unCoord2, index), sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod)                 textureName.Load(int4(unCoord2, index, lod))
	#define LOAD_TEXTURE3D(textureName, unCoord3)                                       textureName.Load(int4(unCoord3, 0))
	#define LOAD_TEXTURE3D_LOD(textureName, unCoord3, lod)                              textureName.Load(int4(unCoord3, lod))

	#if GLES3_1_AEP
	#define PLATFORM_SUPPORT_GATHER
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                  textureName.Gather(samplerName, coord2)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)     textureName.Gather(samplerName, float3(coord2, index))
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)                textureName.Gather(samplerName, coord3)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)   textureName.Gather(samplerName, float4(coord3, index))
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)              textureName.GatherRed(samplerName, coord2)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)            textureName.GatherGreen(samplerName, coord2)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)             textureName.GatherBlue(samplerName, coord2)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)            textureName.GatherAlpha(samplerName, coord2)
	#else
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                  ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURE2D)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)     ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURE2D_ARRAY)
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)                ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURECUBE)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)   ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURECUBE_ARRAY)
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)              ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_RED_TEXTURE2D)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)            ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_GREEN_TEXTURE2D)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)             ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_BLUE_TEXTURE2D)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)            ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_ALPHA_TEXTURE2D)
	#endif


#elif defined(SHADER_API_GLES)


	#define uint int

	#define rcp(x) 1.0 / (x)
	#define ddx_fine ddx
	#define ddy_fine ddy
	#define asfloat
	#define asuint(x) asint(x)
	#define f32tof16
	#define f16tof32

	#define ERROR_ON_UNSUPPORTED_FUNCTION(funcName) #error #funcName is not supported on GLES 2.0

	// Initialize arbitrary structure with zero values.
	// Do not exist on some platform, in this case we need to have a standard name that call a function that will initialize all parameters to 0
	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }


	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) #error calculate Level of Detail not supported in GLES2

	// Texture abstraction

	#define TEXTURE2D(textureName)                          sampler2D textureName
	#define TEXTURE2D_ARRAY(textureName)                    samplerCUBE textureName // No support to texture2DArray
	#define TEXTURECUBE(textureName)                        samplerCUBE textureName
	#define TEXTURECUBE_ARRAY(textureName)                  samplerCUBE textureName // No supoport to textureCubeArray and can't emulate with texture2DArray
	#define TEXTURE3D(textureName)                          sampler3D textureName

	#define TEXTURE2D_FLOAT(textureName)                    sampler2D_float textureName
	#define TEXTURE2D_ARRAY_FLOAT(textureName)              TEXTURECUBE_FLOAT(textureName) // No support to texture2DArray
	#define TEXTURECUBE_FLOAT(textureName)                  samplerCUBE_float textureName
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)            TEXTURECUBE_FLOAT(textureName) // No support to textureCubeArray
	#define TEXTURE3D_FLOAT(textureName)                    sampler3D_float textureName

	#define TEXTURE2D_HALF(textureName)                     sampler2D_half textureName
	#define TEXTURE2D_ARRAY_HALF(textureName)               TEXTURECUBE_HALF(textureName) // No support to texture2DArray
	#define TEXTURECUBE_HALF(textureName)                   samplerCUBE_half textureName
	#define TEXTURECUBE_ARRAY_HALF(textureName)             TEXTURECUBE_HALF(textureName) // No support to textureCubeArray
	#define TEXTURE3D_HALF(textureName)                     sampler3D_half textureName

	#define TEXTURE2D_SHADOW(textureName)                   SHADOW2D_TEXTURE_AND_SAMPLER textureName
	#define TEXTURE2D_ARRAY_SHADOW(textureName)             TEXTURECUBE_SHADOW(textureName) // No support to texture array
	#define TEXTURECUBE_SHADOW(textureName)                 SHADOWCUBE_TEXTURE_AND_SAMPLER textureName
	#define TEXTURECUBE_ARRAY_SHADOW(textureName)           TEXTURECUBE_SHADOW(textureName) // No support to texture array

	#define RW_TEXTURE2D(type, textureNam)                  ERROR_ON_UNSUPPORTED_FUNCTION(RWTexture2D)
	#define RW_TEXTURE2D_ARRAY(type, textureName)           ERROR_ON_UNSUPPORTED_FUNCTION(RWTexture2DArray)
	#define RW_TEXTURE3D(type, textureNam)                  ERROR_ON_UNSUPPORTED_FUNCTION(RWTexture3D)

	#define SAMPLER(samplerName)
	#define SAMPLER_CMP(samplerName)

	#define TEXTURE2D_PARAM(textureName, samplerName)                sampler2D textureName
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)          samplerCUBE textureName
	#define TEXTURECUBE_PARAM(textureName, samplerName)              samplerCUBE textureName
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)        samplerCUBE textureName
	#define TEXTURE3D_PARAM(textureName, samplerName)                sampler3D textureName
	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)         SHADOW2D_TEXTURE_AND_SAMPLER textureName
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)   SHADOWCUBE_TEXTURE_AND_SAMPLER textureName
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)       SHADOWCUBE_TEXTURE_AND_SAMPLER textureName

	#define TEXTURE2D_ARGS(textureName, samplerName)               textureName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)         textureName
	#define TEXTURECUBE_ARGS(textureName, samplerName)             textureName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)       textureName
	#define TEXTURE3D_ARGS(textureName, samplerName)               textureName
	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)        textureName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)  textureName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)      textureName

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2) tex2D(textureName, coord2)

	#if (SHADER_TARGET >= 30)
	    #define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod) tex2Dlod(textureName, float4(coord2, 0, lod))
	#else
	    // No lod support. Very poor approximation with bias.
	    #define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod) SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, lod)
	#endif

	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                       tex2Dbias(textureName, float4(coord2, 0, bias))
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, ddx, ddy)                   SAMPLE_TEXTURE2D(textureName, samplerName, coord2)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                     ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURE2D_ARRAY)
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)            ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURE2D_ARRAY_LOD)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)          ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURE2D_ARRAY_BIAS)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy)    ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURE2D_ARRAY_GRAD)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                                texCUBE(textureName, coord3)
	// No lod support. Very poor approximation with bias.
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                       SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                     texCUBEbias(textureName, float4(coord3, bias))
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)                   ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY)
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)          ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY_LOD)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)        ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY_BIAS)
	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                                  tex3D(textureName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                         ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURE3D_LOD)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                           SHADOW2D_SAMPLE(textureName, samplerName, coord3)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)              ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURE2D_ARRAY_SHADOW)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                         SHADOWCUBE_SAMPLE(textureName, samplerName, coord4)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)            ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY_SHADOW)


	// Not supported. Can't define as error because shader library is calling these functions.
	#define LOAD_TEXTURE2D(textureName, unCoord2)                                               half4(0, 0, 0, 0)
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)                                      half4(0, 0, 0, 0)
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)                             half4(0, 0, 0, 0)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)                                  half4(0, 0, 0, 0)
	#define LOAD_TEXTURE2D_ARRAY_MSAA(textureName, unCoord2, index, sampleIndex)                half4(0, 0, 0, 0)
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod)                         half4(0, 0, 0, 0)
	#define LOAD_TEXTURE3D(textureName, unCoord3)                                               ERROR_ON_UNSUPPORTED_FUNCTION(LOAD_TEXTURE3D)
	#define LOAD_TEXTURE3D_LOD(textureName, unCoord3, lod)                                      ERROR_ON_UNSUPPORTED_FUNCTION(LOAD_TEXTURE3D_LOD)

	// Gather not supported. Fallback to regular texture sampling.
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                  ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURE2D)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)     ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURE2D_ARRAY)
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)                ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURECUBE)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)   ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURECUBE_ARRAY)
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)              ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_RED_TEXTURE2D)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)            ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_GREEN_TEXTURE2D)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)             ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_BLUE_TEXTURE2D)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)            ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_ALPHA_TEXTURE2D)

#else
#error unsupported shader api
#endif




// default flow control attributes
#ifndef UNITY_BRANCH
#   define UNITY_BRANCH
#endif
#ifndef UNITY_FLATTEN
#   define UNITY_FLATTEN
#endif
#ifndef UNITY_UNROLL
#   define UNITY_UNROLL
#endif
#ifndef UNITY_UNROLLX
#   define UNITY_UNROLLX(_x)
#endif
#ifndef UNITY_LOOP
#   define UNITY_LOOP
#endif



#define _GRABPASSUSED 1
#define REQUIRE_OPAQUE_TEXTURE


         // data across stages, stripped like the above.
         struct VertexToPixel
         {
            UNITY_POSITION(pos);
            float3 worldPos : TEXCOORD0;
            float3 worldNormal : TEXCOORD1;
            float4 worldTangent : TEXCOORD2;
             float4 texcoord0 : TEXCOORD3;
            // float4 texcoord1 : TEXCOORD4;
            // float4 texcoord2 : TEXCOORD5;
            // #if %TEXCOORD3REQUIREKEY%
            // float4 texcoord3 : TEXCOORD6;
            // #endif

            // #if %SCREENPOSREQUIREKEY%
             float4 screenPos : TEXCOORD7;
            // #endif

            float4 lmap : TEXCOORD8;
            #if UNITY_SHOULD_SAMPLE_SH
               half3 sh : TEXCOORD9; // SH
            #endif
            #ifdef LIGHTMAP_ON
               UNITY_LIGHTING_COORDS(10,11)
               UNITY_FOG_COORDS(12)
            #else
               UNITY_FOG_COORDS(10)
               UNITY_SHADOW_COORDS(11)
            #endif

            // #if %VERTEXCOLORREQUIREKEY%
             float4 vertexColor : COLOR;
            // #endif

            // #if %EXTRAV2F0REQUIREKEY%
             float4 extraV2F0 : TEXCOORD13;
            // #endif

            // #if %EXTRAV2F1REQUIREKEY%
             float4 extraV2F1 : TEXCOORD14;
            // #endif

            // #if %EXTRAV2F2REQUIREKEY%
            // float4 extraV2F2 : TEXCOORD15;
            // #endif

            // #if %EXTRAV2F3REQUIREKEY%
            // float4 extraV2F3 : TEXCOORD16;
            // #endif

            // #if %EXTRAV2F4REQUIREKEY%
            // float4 extraV2F4 : TEXCOORD17;
            // #endif

            // #if %EXTRAV2F5REQUIREKEY%
            // float4 extraV2F5 : TEXCOORD18;
            // #endif

            // #if %EXTRAV2F6REQUIREKEY%
            // float4 extraV2F6 : TEXCOORD19;
            // #endif

            // #if %EXTRAV2F7REQUIREKEY%
            // float4 extraV2F7 : TEXCOORD20;
            // #endif


            UNITY_VERTEX_INPUT_INSTANCE_ID
            UNITY_VERTEX_OUTPUT_STEREO
         };

         
            
            // data describing the user output of a pixel
            struct Surface
            {
               half3 Albedo;
               half Height;
               half3 Normal;
               half Smoothness;
               half3 Emission;
               half Metallic;
               half3 Specular;
               half Occlusion;
               half SpecularPower; // for simple lighting
               half Alpha;
               float outputDepth; // if written, SV_Depth semantic is used. ShaderData.clipPos.z is unused value
               // HDRP Only
               half SpecularOcclusion;
               half SubsurfaceMask;
               half Thickness;
               half CoatMask;
               half CoatSmoothness;
               half Anisotropy;
               half IridescenceMask;
               half IridescenceThickness;
               int DiffusionProfileHash;
               float SpecularAAThreshold;
               float SpecularAAScreenSpaceVariance;
               // requires _OVERRIDE_BAKEDGI to be defined, but is mapped in all pipelines
               float3 DiffuseGI;
               float3 BackDiffuseGI;
               float3 SpecularGI;
               // requires _OVERRIDE_SHADOWMASK to be defines
               float4 ShadowMask;
            };

            // Data the user declares in blackboard blocks
            struct Blackboard
            {
                
	float  groundHeight;
	float  surfaceHeight;
	float3 surfaceNormal;

	Fluid fluid;


	float foam;


                float blackboardDummyData;
            };

            // data the user might need, this will grow to be big. But easy to strip
            struct ShaderData
            {
               float4 clipPos; // SV_POSITION
               float3 localSpacePosition;
               float3 localSpaceNormal;
               float3 localSpaceTangent;
        
               float3 worldSpacePosition;
               float3 worldSpaceNormal;
               float3 worldSpaceTangent;
               float tangentSign;

               float3 worldSpaceViewDir;
               float3 tangentSpaceViewDir;

               float4 texcoord0;
               float4 texcoord1;
               float4 texcoord2;
               float4 texcoord3;

               float2 screenUV;
               float4 screenPos;

               float4 vertexColor;
               bool isFrontFace;

               float4 extraV2F0;
               float4 extraV2F1;
               float4 extraV2F2;
               float4 extraV2F3;
               float4 extraV2F4;
               float4 extraV2F5;
               float4 extraV2F6;
               float4 extraV2F7;

               float3x3 TBNMatrix;
               Blackboard blackboard;
            };

            struct VertexData
            {
               #if SHADER_TARGET > 30
               // uint vertexID : SV_VertexID;
               #endif
               float4 vertex : POSITION;
               float3 normal : NORMAL;
               float4 tangent : TANGENT;
               float4 texcoord0 : TEXCOORD0;

               // optimize out mesh coords when not in use by user or lighting system
               #if _URP && (_USINGTEXCOORD1 || _PASSMETA || _PASSFORWARD || _PASSGBUFFER)
                  float4 texcoord1 : TEXCOORD1;
               #endif

               #if _URP && (_USINGTEXCOORD2 || _PASSMETA || ((_PASSFORWARD || _PASSGBUFFER) && defined(DYNAMICLIGHTMAP_ON)))
                  float4 texcoord2 : TEXCOORD2;
               #endif

               #if _STANDARD && (_USINGTEXCOORD1 || (_PASSMETA || ((_PASSFORWARD || _PASSGBUFFER || _PASSFORWARDADD) && LIGHTMAP_ON)))
                  float4 texcoord1 : TEXCOORD1;
               #endif
               #if _STANDARD && (_USINGTEXCOORD2 || (_PASSMETA || ((_PASSFORWARD || _PASSGBUFFER) && DYNAMICLIGHTMAP_ON)))
                  float4 texcoord2 : TEXCOORD2;
               #endif


               #if _HDRP
                  float4 texcoord1 : TEXCOORD1;
                  float4 texcoord2 : TEXCOORD2;
               #endif

               // #if %TEXCOORD3REQUIREKEY%
               // float4 texcoord3 : TEXCOORD3;
               // #endif

               // #if %VERTEXCOLORREQUIREKEY%
                float4 vertexColor : COLOR;
               // #endif

               #if _HDRP && (_PASSMOTIONVECTOR || ((_PASSFORWARD || _PASSUNLIT) && defined(_WRITE_TRANSPARENT_MOTION_VECTOR)))
                  float3 previousPositionOS : TEXCOORD4; // Contain previous transform position (in case of skinning for example)
                  #if defined (_ADD_PRECOMPUTED_VELOCITY)
                     float3 precomputedVelocity    : TEXCOORD5; // Add Precomputed Velocity (Alembic computes velocities on runtime side).
                  #endif
               #endif

               UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct TessVertex 
            {
               float4 vertex : INTERNALTESSPOS;
               float3 normal : NORMAL;
               float4 tangent : TANGENT;
               float4 texcoord0 : TEXCOORD0;
               float4 texcoord1 : TEXCOORD1;
               float4 texcoord2 : TEXCOORD2;

               // #if %TEXCOORD3REQUIREKEY%
               // float4 texcoord3 : TEXCOORD3;
               // #endif

               // #if %VERTEXCOLORREQUIREKEY%
                float4 vertexColor : COLOR;
               // #endif

               // #if %EXTRAV2F0REQUIREKEY%
                float4 extraV2F0 : TEXCOORD5;
               // #endif

               // #if %EXTRAV2F1REQUIREKEY%
                float4 extraV2F1 : TEXCOORD6;
               // #endif

               // #if %EXTRAV2F2REQUIREKEY%
               // float4 extraV2F2 : TEXCOORD7;
               // #endif

               // #if %EXTRAV2F3REQUIREKEY%
               // float4 extraV2F3 : TEXCOORD8;
               // #endif

               // #if %EXTRAV2F4REQUIREKEY%
               // float4 extraV2F4 : TEXCOORD9;
               // #endif

               // #if %EXTRAV2F5REQUIREKEY%
               // float4 extraV2F5 : TEXCOORD10;
               // #endif

               // #if %EXTRAV2F6REQUIREKEY%
               // float4 extraV2F6 : TEXCOORD11;
               // #endif

               // #if %EXTRAV2F7REQUIREKEY%
               // float4 extraV2F7 : TEXCOORD12;
               // #endif

               #if _HDRP && (_PASSMOTIONVECTOR || ((_PASSFORWARD || _PASSUNLIT) && defined(_WRITE_TRANSPARENT_MOTION_VECTOR)))
                  float3 previousPositionOS : TEXCOORD13; // Contain previous transform position (in case of skinning for example)
                  #if defined (_ADD_PRECOMPUTED_VELOCITY)
                     float3 precomputedVelocity : TEXCOORD14;
                  #endif
               #endif

               UNITY_VERTEX_INPUT_INSTANCE_ID
               UNITY_VERTEX_OUTPUT_STEREO
            };

            struct ExtraV2F
            {
               float4 extraV2F0;
               float4 extraV2F1;
               float4 extraV2F2;
               float4 extraV2F3;
               float4 extraV2F4;
               float4 extraV2F5;
               float4 extraV2F6;
               float4 extraV2F7;
               Blackboard blackboard;
               float4 time;
            };


            float3 WorldToTangentSpace(ShaderData d, float3 normal)
            {
               return mul(d.TBNMatrix, normal);
            }

            float3 TangentToWorldSpace(ShaderData d, float3 normal)
            {
               return mul(normal, d.TBNMatrix);
            }

            // in this case, make standard more like SRPs, because we can't fix
            // unity_WorldToObject in HDRP, since it already does macro-fu there

            #if _STANDARD
               float3 TransformWorldToObject(float3 p) { return mul(unity_WorldToObject, float4(p, 1)); };
               float3 TransformObjectToWorld(float3 p) { return mul(unity_ObjectToWorld, float4(p, 1)); };
               float4 TransformWorldToObject(float4 p) { return mul(unity_WorldToObject, p); };
               float4 TransformObjectToWorld(float4 p) { return mul(unity_ObjectToWorld, p); };
               float4x4 GetWorldToObjectMatrix() { return unity_WorldToObject; }
               float4x4 GetObjectToWorldMatrix() { return unity_ObjectToWorld; }
               #if (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (SHADER_TARGET_SURFACE_ANALYSIS && !SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))
                 #define UNITY_SAMPLE_TEX2D_LOD(tex,coord, lod) tex.SampleLevel (sampler##tex,coord, lod)
                 #define UNITY_SAMPLE_TEX2D_SAMPLER_LOD(tex,samplertex,coord, lod) tex.SampleLevel (sampler##samplertex,coord, lod)
              #else
                 #define UNITY_SAMPLE_TEX2D_LOD(tex,coord,lod) tex2D (tex,coord,0,lod)
                 #define UNITY_SAMPLE_TEX2D_SAMPLER_LOD(tex,samplertex,coord,lod) tex2D (tex,coord,0,lod)
              #endif

               #undef UNITY_MATRIX_I_M

               #define UNITY_MATRIX_I_M   unity_WorldToObject


            #endif

            float3 GetCameraWorldPosition()
            {
               #if _HDRP
                  return GetCameraRelativePositionWS(_WorldSpaceCameraPos);
               #else
                  return _WorldSpaceCameraPos;
               #endif
            }

            #if _GRABPASSUSED
               #if _STANDARD
                  TEXTURE2D(_Grab);
                  SAMPLER(sampler__Grab);
               #endif

               half3 GetSceneColor(float2 uv)
               {
                  #if _STANDARD
                     return SAMPLE_TEXTURE2D(_Grab, sampler__Grab, uv).rgb;
                  #else
                     return SHADERGRAPH_SAMPLE_SCENE_COLOR(uv);
                  #endif
               }
            #endif


      
            #if _STANDARD
               UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
               float GetSceneDepth(float2 uv) { return SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv); }
               float GetLinear01Depth(float2 uv) { return Linear01Depth(GetSceneDepth(uv)); }
               float GetLinearEyeDepth(float2 uv) { return LinearEyeDepth(GetSceneDepth(uv)); } 
            #else
               float GetSceneDepth(float2 uv) { return SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv); }
               float GetLinear01Depth(float2 uv) { return Linear01Depth(GetSceneDepth(uv), _ZBufferParams); }
               float GetLinearEyeDepth(float2 uv) { return LinearEyeDepth(GetSceneDepth(uv), _ZBufferParams); } 
            #endif

            float3 GetWorldPositionFromDepthBuffer(float2 uv, float3 worldSpaceViewDir)
            {
               float eye = GetLinearEyeDepth(uv);
               float3 camView = mul((float3x3)UNITY_MATRIX_M, transpose(mul(UNITY_MATRIX_I_M, UNITY_MATRIX_I_V)) [2].xyz);

               float dt = dot(worldSpaceViewDir, camView);
               float3 div = worldSpaceViewDir/dt;
               float3 wpos = (eye * div) + GetCameraWorldPosition();
               return wpos;
            }

            #if _HDRP
            float3 ObjectToWorldSpacePosition(float3 pos)
            {
               return GetAbsolutePositionWS(TransformObjectToWorld(pos));
            }
            #else
            float3 ObjectToWorldSpacePosition(float3 pos)
            {
               return TransformObjectToWorld(pos);
            }
            #endif

            #if _STANDARD
               UNITY_DECLARE_SCREENSPACE_TEXTURE(_CameraDepthNormalsTexture);
               float3 GetSceneNormal(float2 uv, float3 worldSpaceViewDir)
               {
                  float4 depthNorms = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_CameraDepthNormalsTexture, uv);
                  float3 norms = DecodeViewNormalStereo(depthNorms);
                  norms = mul((float3x3)UNITY_MATRIX_V, norms) * 0.5 + 0.5;
                  return norms;
               }
            #elif _HDRP
               float3 GetSceneNormal(float2 uv, float3 worldSpaceViewDir)
               {
                  NormalData nd;
                  DecodeFromNormalBuffer(_ScreenSize.xy * uv, nd);
                  return nd.normalWS;
               }
            #elif _URP
               #if (SHADER_LIBRARY_VERSION_MAJOR >= 10)
                  #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareNormalsTexture.hlsl"
               #endif

               float3 GetSceneNormal(float2 uv, float3 worldSpaceViewDir)
               {
                  #if (SHADER_LIBRARY_VERSION_MAJOR >= 10)
                     return SampleSceneNormals(uv);
                  #else
                     float3 wpos = GetWorldPositionFromDepthBuffer(uv, worldSpaceViewDir);
                     return normalize(-cross(ddx(wpos), ddy(wpos))) * 0.5 + 0.5;
                  #endif

                }
             #endif

             #if _HDRP

               half3 UnpackNormalmapRGorAG(half4 packednormal)
               {
                     // This do the trick
                  packednormal.x *= packednormal.w;

                  half3 normal;
                  normal.xy = packednormal.xy * 2 - 1;
                  normal.z = sqrt(1 - saturate(dot(normal.xy, normal.xy)));
                  return normal;
               }
               half3 UnpackNormal(half4 packednormal)
               {
                  #if defined(UNITY_NO_DXT5nm)
                     return packednormal.xyz * 2 - 1;
                  #else
                     return UnpackNormalmapRGorAG(packednormal);
                  #endif
               }
               #endif
               #if _HDRP || _URP

               half3 UnpackScaleNormal(half4 packednormal, half scale)
               {
                 #ifndef UNITY_NO_DXT5nm
                   // Unpack normal as DXT5nm (1, y, 1, x) or BC5 (x, y, 0, 1)
                   // Note neutral texture like "bump" is (0, 0, 1, 1) to work with both plain RGB normal and DXT5nm/BC5
                   packednormal.x *= packednormal.w;
                 #endif
                   half3 normal;
                   normal.xy = (packednormal.xy * 2 - 1) * scale;
                   normal.z = sqrt(1 - saturate(dot(normal.xy, normal.xy)));
                   return normal;
               }	

             #endif


            void GetSun(out float3 lightDir, out float3 color)
            {
               lightDir = float3(0.5, 0.5, 0);
               color = 1;
               #if _HDRP
                  if (_DirectionalLightCount > 0)
                  {
                     DirectionalLightData light = _DirectionalLightDatas[0];
                     lightDir = -light.forward.xyz;
                     color = light.color;
                  }
               #elif _STANDARD
			         lightDir = normalize(_WorldSpaceLightPos0.xyz);
                  color = _LightColor0.rgb;
               #elif _URP
	               Light light = GetMainLight();
	               lightDir = light.direction;
	               color = light.color;
               #endif
            }


            
         
	float    _FlowDensity;
	float2   _FlowSeparationXZ;
	float    _FlowSimulationHeight;
	float    _FlowCameraHeight;
	float2   _FlowCountXZ;
	float4   _FlowCoordU000;
	float4   _FlowCoord0V00;
	float    _FlowSpeed;
	float4x4 _FlowMatrix;

	float _Sink;


	float _WaveStrengthMin;
	float _WaveStrengthMax;
	float _WaveStrengthScale;

	float _Tiling;
	float _AnimationSpeed;
	float _FoamBrightness;


	half _FlatShadingBlend;


	float _RangeMax;
	float _AlphaStep;
	int _AlphaMaxSteps;
	float _AlphaDepthScale;





         

         

         
	TEXTURE2D(_FlowDataA);
	SAMPLER(sampler_FlowDataA);
	TEXTURE2D(_FlowDataB);
	SAMPLER(sampler_FlowDataB);
	TEXTURE2D(_FlowDataC);
	SAMPLER(sampler_FlowDataC);
	TEXTURE2D(_FlowDataD);
	SAMPLER(sampler_FlowDataD);
	TEXTURE2D(_FlowDataE);
	SAMPLER(sampler_FlowDataE);
	TEXTURE2D(_FlowDataF);
	SAMPLER(sampler_FlowDataF);

	float4 SGT_O2W(float4 v)
	{
		v = mul(UNITY_MATRIX_M, v);
		#if _HDRP
			v.xyz = GetAbsolutePositionWS(v.xyz);
		#endif
		return v;
	}

	float4 SGT_W2O(float4 v)
	{
		#if _HDRP
			v.xyz = GetCameraRelativePositionWS(v.xyz);
		#endif
		return mul(UNITY_MATRIX_I_M, v);
	}

	float4 SGT_O2V(float4 v)
	{
		#if _STANDARD
			return float4(UnityObjectToViewPos(v.xyz), 1.0f);
		#else
			return float4(TransformWorldToView(TransformObjectToWorld(v.xyz)), 1.0f);
		#endif
	}

	float GetFluidHeight(float2 uv)
	{
		float groundHeight = SAMPLE_TEXTURE2D_LOD(_FlowDataA, sampler_FlowDataA, uv, 0).r;
		float fluidDepth   = SAMPLE_TEXTURE2D_LOD(_FlowDataC, sampler_FlowDataC, uv, 0).r;

		return groundHeight + fluidDepth;
	}

	float2 GetHeightAndDepth(float2 uv)
	{
		float groundHeight = SAMPLE_TEXTURE2D_LOD(_FlowDataA, sampler_FlowDataA, uv, 0).r;
		float fluidDepth   = SAMPLE_TEXTURE2D_LOD(_FlowDataC, sampler_FlowDataC, uv, 0).r;

		return float2(groundHeight, fluidDepth);
	}

	Column GetColumn(float2 uv)
	{
		return DecodeColumn(SAMPLE_TEXTURE2D_LOD(_FlowDataA, sampler_FlowDataA, uv, 0), SAMPLE_TEXTURE2D_LOD(_FlowDataB, sampler_FlowDataB, uv, 0));
	}

	Fluid GetColumnFluid(float2 uv)
	{
		float4 c = SAMPLE_TEXTURE2D_LOD(_FlowDataC, sampler_FlowDataC, uv, 0);
		float4 d = SAMPLE_TEXTURE2D_LOD(_FlowDataD, sampler_FlowDataD, uv, 0);
		float4 e = SAMPLE_TEXTURE2D_LOD(_FlowDataE, sampler_FlowDataE, uv, 0);
		float4 f = SAMPLE_TEXTURE2D_LOD(_FlowDataF, sampler_FlowDataF, uv, 0);
		return DecodeFluid(c, d, e, f);
	}

	bool InsideFluid(float3 wpos)
	{
		float2 columnPixel = mul(_FlowMatrix, float4(wpos, 1.0f)).xy;
		float2 columnCoord = CoordFromPixel(columnPixel, _FlowCountXZ);
		float2 columnHAD   = GetHeightAndDepth(columnCoord);

		return min(columnCoord.x, columnCoord.y) >= 0.0 && max(columnCoord.x, columnCoord.y) <= 1.0f && wpos.y > columnHAD.x && wpos.y < (columnHAD.x + columnHAD.y);
	}

	bool UnderFluid(float3 wpos)
	{
		float2 columnPixel = mul(_FlowMatrix, float4(wpos, 1.0f)).xy;
		float2 columnCoord = CoordFromPixel(columnPixel, _FlowCountXZ);
		float2 columnHAD   = GetHeightAndDepth(columnCoord);

		return min(columnCoord.x, columnCoord.y) >= 0.0 && max(columnCoord.x, columnCoord.y) <= 1.0f && wpos.y < (columnHAD.x + columnHAD.y);
	}

	float RayMarchInside(float3 wpos, float3 wdir, float step, int maxs, float maxd)
	{
		float epsi = step * 0.01f;
		float dist = 0.0f;

		for (int i = 0; i < maxs && step > epsi; i++)
		{
			dist += step;

			float3 pos = wpos + wdir * dist;

			if (InsideFluid(pos) == false)
			{
				dist -= step;
				step *= 0.5f;
			}

			if (dist > maxd)
			{
				return maxd;
			}
		}

		return dist;
	}

	float RayMarchUnder(float3 wpos, float3 wdir, float step, int maxs, float maxd)
	{
		float epsi = step * 0.01f;
		float dist = 0.0f;

		for (int i = 0; i < maxs && step > epsi; i++)
		{
			dist += step;

			float3 pos = wpos + wdir * dist;

			if (UnderFluid(pos) == false)
			{
				dist -= step;
				step *= 0.5f;
			}

			if (dist > maxd)
			{
				return maxd;
			}
		}

		return dist;
	}

	void Ext_ModifyVertex0 (inout VertexData v, inout ExtraV2F e)
	{
		float4 wpos        = SGT_O2W(v.vertex);
		float2 columnPixel = mul(_FlowMatrix, float4(wpos.xyz, 1.0f)).xy;
		float2 columnCoord = SnapCoordFromPixel(round(columnPixel), _FlowCountXZ);

		Column column0 = GetColumn(columnCoord);
		Column columnL = GetColumn(columnCoord - _FlowCoordU000.xy);
		Column columnR = GetColumn(columnCoord + _FlowCoordU000.xy);
		Column columnB = GetColumn(columnCoord - _FlowCoord0V00.xy);
		Column columnT = GetColumn(columnCoord + _FlowCoord0V00.xy);

		Fluid fluid0 = GetColumnFluid(columnCoord);
		Fluid fluidL = GetColumnFluid(columnCoord - _FlowCoordU000.xy);
		Fluid fluidR = GetColumnFluid(columnCoord + _FlowCoordU000.xy);
		Fluid fluidB = GetColumnFluid(columnCoord - _FlowCoord0V00.xy);
		Fluid fluidT = GetColumnFluid(columnCoord + _FlowCoord0V00.xy);

		float ww = fluidL.Depth + fluidR.Depth + fluidB.Depth + fluidT.Depth + 0.001f;
		float wL = fluidL.Depth / ww;
		float wR = fluidR.Depth / ww;
		float wB = fluidB.Depth / ww;
		float wT = fluidT.Depth / ww;
		float w0 = saturate(fluid0.Depth * 10);

		float hL = columnL.GroundHeight + fluidL.Depth;
		float hR = columnR.GroundHeight + fluidR.Depth;
		float hB = columnB.GroundHeight + fluidB.Depth;
		float hT = columnT.GroundHeight + fluidT.Depth;
		float hh = hL * wL + hR * wR + hB * wB + hT * wT;
		float h0 = column0.GroundHeight + fluid0.Depth;

		hh = lerp(hh, h0 - _Sink, saturate(0.01f / ww)); // Prevent skirts going down too far

		Fluid fluid = fluid0;

		fluid.Depth = lerp(fluidL.Depth * wL + fluidR.Depth * wR + fluidB.Depth * wB + fluidT.Depth * wT, fluid.Depth, w0);
		fluid.RGBA  = lerp(fluidL.RGBA  * wL + fluidR.RGBA  * wR + fluidB.RGBA  * wB + fluidT.RGBA  * wT, fluid.RGBA , w0);
		fluid.ESMV  = lerp(fluidL.ESMV  * wL + fluidR.ESMV  * wR + fluidB.ESMV  * wB + fluidT.ESMV  * wT, fluid.ESMV , w0);
		fluid.F123  = lerp(fluidL.F123  * wL + fluidR.F123  * wR + fluidB.F123  * wB + fluidT.F123  * wT, fluid.F123 , w0);

		e.blackboard.groundHeight  = column0.GroundHeight;
		e.blackboard.surfaceHeight = lerp(hh, h0, w0);
		e.blackboard.surfaceNormal = normalize(float3((hL - hR) / _FlowSeparationXZ.x, 2.0f, (hB - hT) / _FlowSeparationXZ.y));
		e.blackboard.fluid         = fluid;
	}


	TEXTURE2D(_NoiseMap);
	SAMPLER(sampler_NoiseMap);

	TEXTURE2D(_NormalFoamMap);
	SAMPLER(sampler_NormalFoamMap);

	void Ext_ModifyVertex3 (inout VertexData v, inout ExtraV2F e)
	{
		v.vertex.y = lerp(e.blackboard.groundHeight, e.blackboard.surfaceHeight, v.texcoord0.w) - _FlowSimulationHeight;

		v.normal = lerp(e.blackboard.surfaceNormal, v.normal, v.texcoord0.z);

		v.vertexColor = e.blackboard.fluid.RGBA;

		e.extraV2F0.xyz = SGT_O2V(v.vertex).xyz;
		e.extraV2F0.w   = e.blackboard.fluid.Depth;

		e.extraV2F1.xyz = e.blackboard.fluid.ESMV.xyz;
		e.extraV2F1.w = e.blackboard.fluid.F123.x;
	}

	float3 FlowUVW(float2 uv, float2 flowVector, float2 jump, float tiling, float time, float phaseOffset)
	{
		float progress = frac(time + phaseOffset);
		float3 uvw;
		uvw.xy = uv - flowVector * (progress - 0.5f);
		uvw.xy *= tiling;
		uvw.xy += phaseOffset;
		uvw.xy += (time - progress) * jump;
		uvw.z = 1 - abs(1 - 2 * progress);
		return uvw;
	}

	float3 CombineNormals(float3 n1, float3 n2)
	{
		return normalize(half3(n1.xy + n2.xy, n1.z*n2.z));
	}

	float3 UnpackNormalAndScale(float2 xy, float scale)
	{
		xy = xy * 2.0f - 1.0f; xy *= scale; return float3(xy, sqrt(1.0 - saturate(dot(xy, xy))));
	}

	float4 SampleStochastic(float2 uv, float noise)
	{
		float cur_height = uv.y + noise;
		float this_index = floor(cur_height);
		float next_index = this_index + 1.0f;

		float2 uvA     = uv + sin(float2(1.0f, 2.0f) * this_index);
		float2 uvB     = uv + sin(float2(1.0f, 2.0f) * next_index);
		float2 gradX   = ddx(uv);
		float2 gradY   = ddy(uv);

		float4 sampleA = SAMPLE_TEXTURE2D_GRAD(_NormalFoamMap, sampler_NormalFoamMap, uvA, gradX, gradY);
		float4 sampleB = SAMPLE_TEXTURE2D_GRAD(_NormalFoamMap, sampler_NormalFoamMap, uvB, gradX, gradY);

		return lerp(sampleA, sampleB, cur_height - this_index);
	}

	void Ext_SurfaceFunction3 (inout Surface o, inout ShaderData d)
	{
		d.blackboard.fluid.RGBA     = d.vertexColor;
		d.blackboard.fluid.Depth    = d.extraV2F0.w;
		d.blackboard.fluid.ESMV.xyz = d.extraV2F1.xyz;
		d.blackboard.fluid.F123.x   = d.extraV2F1.w;

		if (d.blackboard.fluid.Depth < 0.01f)
		{
			discard;
		}

		float2 uv          = d.worldSpacePosition.xz;
		float2 columnPixel = mul(_FlowMatrix, float4(d.worldSpacePosition, 1.0f)).xy;
		float2 columnCoord = CoordFromPixel(columnPixel, _FlowCountXZ);
		Column column      = GetColumn(columnCoord);

		float  time = _Time.y * _AnimationSpeed;
		float2 jump = float2(0.13f, 0.17f);
		float2 fvec = (column.Outflow.yw - column.Outflow.xz) * _FlowSeparationXZ * _FlowSpeed;
		float  fmag = log10(1.0f + length(fvec)) * 0.1f;

		float3 flowA = FlowUVW(uv, fvec / _AnimationSpeed, jump, _Tiling, time, 0.0f);
		float3 flowB = FlowUVW(uv, fvec / _AnimationSpeed, jump, _Tiling, time, 0.5f);

		#if _STOCHASTIC_ON
			float  noise = SAMPLE_TEXTURE2D(_NoiseMap, sampler_NoiseMap, uv * 0.0025f).a * 4.0f;
			float4 nfmA  = SampleStochastic(flowA, noise);
			float4 nfmB  = SampleStochastic(flowB, noise);
		#else
			float4 nfmA = SAMPLE_TEXTURE2D(_NormalFoamMap, sampler_NormalFoamMap, flowA.xy);
			float4 nfmB = SAMPLE_TEXTURE2D(_NormalFoamMap, sampler_NormalFoamMap, flowB.xy);
		#endif

		// Water normals
		float  normalStr    = lerp(_WaveStrengthMin, _WaveStrengthMax, saturate(_WaveStrengthScale * fmag));
		float3 waterNormalA = UnpackNormalAndScale(nfmA.xy, flowA.z * normalStr);
		float3 waterNormalB = UnpackNormalAndScale(nfmB.xy, flowB.z * normalStr);
		float3 waterNormals = CombineNormals(waterNormalA, waterNormalB);

		o.Normal = lerp(waterNormals, o.Normal, d.texcoord0.z);
		o.Albedo = d.blackboard.fluid.RGBA.xyz;

		#if _FOAM_OFF
			d.blackboard.foam = 0.0f;
		#else
			d.blackboard.foam = d.blackboard.fluid.F123.x * (1.0f - d.texcoord0.z);

			#if _FOAM_ALPHA
				float3 foamAlbedo = (nfmA.w * flowA.z + nfmB.w * flowB.z) * _FoamBrightness;
			#elif _FOAM_CUTOUT
				float3 foamAlbedo = _FoamBrightness;
				float  foamRamp   = nfmA.w * flowA.z + nfmB.w * flowB.z;
				d.blackboard.foam = saturate((d.blackboard.foam - foamRamp) * 10.0f);
			#endif

			float3 foamNormal = float3(0.0f, 0.0f, 1.0f);

			o.Albedo = lerp(o.Albedo, foamAlbedo, d.blackboard.foam);
			o.Normal = lerp(o.Normal, foamNormal, d.blackboard.foam);
		#endif

		o.Smoothness = d.blackboard.fluid.ESMV.y;
		o.Metallic   = d.blackboard.fluid.ESMV.z;
	}


	void Ext_SurfaceFunction4 (inout Surface o, inout ShaderData d)
	{
	#if _FACETED_ON
		// lets just affect the TBN data, so we flat shade the original polygons, not the normal map
		float3 dx = ddx(d.worldSpacePosition);
		float3 dy = ddy(d.worldSpacePosition);
		float3 worldNormal = normalize(cross(dy, dx));
		worldNormal = lerp(d.worldSpaceNormal, worldNormal, _FlatShadingBlend);
		d.worldSpaceNormal = worldNormal;
		d.TBNMatrix[2] = worldNormal;
	#endif
	}


	void Ext_SurfaceFunction5 (inout Surface o, ShaderData d)
	{
		#if _ALPHA_OFF
		#else
			float3 position  = d.worldSpacePosition;
			float3 step      = d.worldSpacePosition - _WorldSpaceCameraPos;
			float2 bentScrUV = d.screenUV + o.Normal.xy * 0.05f * log(1.0f + d.blackboard.fluid.Depth * 1.0f);
			float  distMax   = max(_RangeMax * 0.001f, _RangeMax * (1.0f - d.blackboard.fluid.RGBA.w));
			float  distRange = distMax;
			float  vertDist  = length(d.extraV2F0.xyz);
			float  camtDist  = GetLinearEyeDepth(bentScrUV) * length(d.extraV2F0.xyz / d.extraV2F0.z);

			if (camtDist < vertDist)
			{
				camtDist = GetLinearEyeDepth(d.screenUV) * length(d.extraV2F0.xyz / d.extraV2F0.z);
			}

			float diffDist = max(0.0f, camtDist - vertDist);

			// The depth buffer becomes unusable at certain ranges, so fade it out
			diffDist += max(0.0f, camtDist * _AlphaDepthScale - _RangeMax);
			distRange = min(distRange, diffDist);

			#if _ALPHA_VERTICAL
				float dist = d.blackboard.fluid.Depth;
			#elif _ALPHA_DEPTH
				float dist = diffDist;
			#elif _ALPHA_MARCH_FLUID
				float dist = RayMarchInside(position, normalize(step), _AlphaStep, _AlphaMaxSteps, distMax);
			#elif _ALPHA_MARCH_FLUID_AND_DEPTH
				float dist = RayMarchInside(position, normalize(step), _AlphaStep, _AlphaMaxSteps, distRange);
			#endif

			// Set opacity based on distance through fluid relative to the maximum distance, and make sure high opacity fluids become solid
			float opacity = saturate(dist / distMax + d.blackboard.foam + pow(d.blackboard.fluid.RGBA.w, 10.0f));

			o.Albedo    = lerp(0.0f, o.Albedo, opacity);
			o.Emission  = lerp(GetSceneColor(bentScrUV), o.Emission, opacity);
			o.Emission += o.Albedo * d.blackboard.fluid.ESMV.x * opacity;
		#endif
	}





        
            void ChainSurfaceFunction(inout Surface l, inout ShaderData d)
            {
                 // Ext_SurfaceFunction0(l, d);
                 // Ext_SurfaceFunction1(l, d);
                 // Ext_SurfaceFunction2(l, d);
                  Ext_SurfaceFunction3(l, d);
                  Ext_SurfaceFunction4(l, d);
                  Ext_SurfaceFunction5(l, d);
                 // Ext_SurfaceFunction6(l, d);
                 // Ext_SurfaceFunction7(l, d);
                 // Ext_SurfaceFunction8(l, d);
                 // Ext_SurfaceFunction9(l, d);
		           // Ext_SurfaceFunction10(l, d);
                 // Ext_SurfaceFunction11(l, d);
                 // Ext_SurfaceFunction12(l, d);
                 // Ext_SurfaceFunction13(l, d);
                 // Ext_SurfaceFunction14(l, d);
                 // Ext_SurfaceFunction15(l, d);
                 // Ext_SurfaceFunction16(l, d);
                 // Ext_SurfaceFunction17(l, d);
                 // Ext_SurfaceFunction18(l, d);
		           // Ext_SurfaceFunction19(l, d);
                 // Ext_SurfaceFunction20(l, d);
                 // Ext_SurfaceFunction21(l, d);
                 // Ext_SurfaceFunction22(l, d);
                 // Ext_SurfaceFunction23(l, d);
                 // Ext_SurfaceFunction24(l, d);
                 // Ext_SurfaceFunction25(l, d);
                 // Ext_SurfaceFunction26(l, d);
                 // Ext_SurfaceFunction27(l, d);
                 // Ext_SurfaceFunction28(l, d);
		           // Ext_SurfaceFunction29(l, d);
            }

            void ChainModifyVertex(inout VertexData v, inout VertexToPixel v2p, float4 time)
            {
                 ExtraV2F d;
                 
                 ZERO_INITIALIZE(ExtraV2F, d);
                 ZERO_INITIALIZE(Blackboard, d.blackboard);
                 // due to motion vectors in HDRP, we need to use the last
                 // time in certain spots. So if you are going to use _Time to adjust vertices,
                 // you need to use this time or motion vectors will break. 
                 d.time = time;

                   Ext_ModifyVertex0(v, d);
                 // Ext_ModifyVertex1(v, d);
                 // Ext_ModifyVertex2(v, d);
                  Ext_ModifyVertex3(v, d);
                 // Ext_ModifyVertex4(v, d);
                 // Ext_ModifyVertex5(v, d);
                 // Ext_ModifyVertex6(v, d);
                 // Ext_ModifyVertex7(v, d);
                 // Ext_ModifyVertex8(v, d);
                 // Ext_ModifyVertex9(v, d);
                 // Ext_ModifyVertex10(v, d);
                 // Ext_ModifyVertex11(v, d);
                 // Ext_ModifyVertex12(v, d);
                 // Ext_ModifyVertex13(v, d);
                 // Ext_ModifyVertex14(v, d);
                 // Ext_ModifyVertex15(v, d);
                 // Ext_ModifyVertex16(v, d);
                 // Ext_ModifyVertex17(v, d);
                 // Ext_ModifyVertex18(v, d);
                 // Ext_ModifyVertex19(v, d);
                 // Ext_ModifyVertex20(v, d);
                 // Ext_ModifyVertex21(v, d);
                 // Ext_ModifyVertex22(v, d);
                 // Ext_ModifyVertex23(v, d);
                 // Ext_ModifyVertex24(v, d);
                 // Ext_ModifyVertex25(v, d);
                 // Ext_ModifyVertex26(v, d);
                 // Ext_ModifyVertex27(v, d);
                 // Ext_ModifyVertex28(v, d);
                 // Ext_ModifyVertex29(v, d);


                 // #if %EXTRAV2F0REQUIREKEY%
                  v2p.extraV2F0 = d.extraV2F0;
                 // #endif

                 // #if %EXTRAV2F1REQUIREKEY%
                  v2p.extraV2F1 = d.extraV2F1;
                 // #endif

                 // #if %EXTRAV2F2REQUIREKEY%
                 // v2p.extraV2F2 = d.extraV2F2;
                 // #endif

                 // #if %EXTRAV2F3REQUIREKEY%
                 // v2p.extraV2F3 = d.extraV2F3;
                 // #endif

                 // #if %EXTRAV2F4REQUIREKEY%
                 // v2p.extraV2F4 = d.extraV2F4;
                 // #endif

                 // #if %EXTRAV2F5REQUIREKEY%
                 // v2p.extraV2F5 = d.extraV2F5;
                 // #endif

                 // #if %EXTRAV2F6REQUIREKEY%
                 // v2p.extraV2F6 = d.extraV2F6;
                 // #endif

                 // #if %EXTRAV2F7REQUIREKEY%
                 // v2p.extraV2F7 = d.extraV2F7;
                 // #endif
            }

            void ChainModifyTessellatedVertex(inout VertexData v, inout VertexToPixel v2p)
            {
               ExtraV2F d;
               ZERO_INITIALIZE(ExtraV2F, d);
               ZERO_INITIALIZE(Blackboard, d.blackboard);

               // #if %EXTRAV2F0REQUIREKEY%
                d.extraV2F0 = v2p.extraV2F0;
               // #endif

               // #if %EXTRAV2F1REQUIREKEY%
                d.extraV2F1 = v2p.extraV2F1;
               // #endif

               // #if %EXTRAV2F2REQUIREKEY%
               // d.extraV2F2 = v2p.extraV2F2;
               // #endif

               // #if %EXTRAV2F3REQUIREKEY%
               // d.extraV2F3 = v2p.extraV2F3;
               // #endif

               // #if %EXTRAV2F4REQUIREKEY%
               // d.extraV2F4 = v2p.extraV2F4;
               // #endif

               // #if %EXTRAV2F5REQUIREKEY%
               // d.extraV2F5 = v2p.extraV2F5;
               // #endif

               // #if %EXTRAV2F6REQUIREKEY%
               // d.extraV2F6 = v2p.extraV2F6;
               // #endif

               // #if %EXTRAV2F7REQUIREKEY%
               // d.extraV2F7 = v2p.extraV2F7;
               // #endif


               // Ext_ModifyTessellatedVertex0(v, d);
               // Ext_ModifyTessellatedVertex1(v, d);
               // Ext_ModifyTessellatedVertex2(v, d);
               // Ext_ModifyTessellatedVertex3(v, d);
               // Ext_ModifyTessellatedVertex4(v, d);
               // Ext_ModifyTessellatedVertex5(v, d);
               // Ext_ModifyTessellatedVertex6(v, d);
               // Ext_ModifyTessellatedVertex7(v, d);
               // Ext_ModifyTessellatedVertex8(v, d);
               // Ext_ModifyTessellatedVertex9(v, d);
               // Ext_ModifyTessellatedVertex10(v, d);
               // Ext_ModifyTessellatedVertex11(v, d);
               // Ext_ModifyTessellatedVertex12(v, d);
               // Ext_ModifyTessellatedVertex13(v, d);
               // Ext_ModifyTessellatedVertex14(v, d);
               // Ext_ModifyTessellatedVertex15(v, d);
               // Ext_ModifyTessellatedVertex16(v, d);
               // Ext_ModifyTessellatedVertex17(v, d);
               // Ext_ModifyTessellatedVertex18(v, d);
               // Ext_ModifyTessellatedVertex19(v, d);
               // Ext_ModifyTessellatedVertex20(v, d);
               // Ext_ModifyTessellatedVertex21(v, d);
               // Ext_ModifyTessellatedVertex22(v, d);
               // Ext_ModifyTessellatedVertex23(v, d);
               // Ext_ModifyTessellatedVertex24(v, d);
               // Ext_ModifyTessellatedVertex25(v, d);
               // Ext_ModifyTessellatedVertex26(v, d);
               // Ext_ModifyTessellatedVertex27(v, d);
               // Ext_ModifyTessellatedVertex28(v, d);
               // Ext_ModifyTessellatedVertex29(v, d);

               // #if %EXTRAV2F0REQUIREKEY%
                v2p.extraV2F0 = d.extraV2F0;
               // #endif

               // #if %EXTRAV2F1REQUIREKEY%
                v2p.extraV2F1 = d.extraV2F1;
               // #endif

               // #if %EXTRAV2F2REQUIREKEY%
               // v2p.extraV2F2 = d.extraV2F2;
               // #endif

               // #if %EXTRAV2F3REQUIREKEY%
               // v2p.extraV2F3 = d.extraV2F3;
               // #endif

               // #if %EXTRAV2F4REQUIREKEY%
               // v2p.extraV2F4 = d.extraV2F4;
               // #endif

               // #if %EXTRAV2F5REQUIREKEY%
               // v2p.extraV2F5 = d.extraV2F5;
               // #endif

               // #if %EXTRAV2F6REQUIREKEY%
               // v2p.extraV2F6 = d.extraV2F6;
               // #endif

               // #if %EXTRAV2F7REQUIREKEY%
               // v2p.extraV2F7 = d.extraV2F7;
               // #endif
            }

            void ChainFinalColorForward(inout Surface l, inout ShaderData d, inout half4 color)
            {
               //   Ext_FinalColorForward0(l, d, color);
               //   Ext_FinalColorForward1(l, d, color);
               //   Ext_FinalColorForward2(l, d, color);
               //   Ext_FinalColorForward3(l, d, color);
               //   Ext_FinalColorForward4(l, d, color);
               //   Ext_FinalColorForward5(l, d, color);
               //   Ext_FinalColorForward6(l, d, color);
               //   Ext_FinalColorForward7(l, d, color);
               //   Ext_FinalColorForward8(l, d, color);
               //   Ext_FinalColorForward9(l, d, color);
               //  Ext_FinalColorForward10(l, d, color);
               //  Ext_FinalColorForward11(l, d, color);
               //  Ext_FinalColorForward12(l, d, color);
               //  Ext_FinalColorForward13(l, d, color);
               //  Ext_FinalColorForward14(l, d, color);
               //  Ext_FinalColorForward15(l, d, color);
               //  Ext_FinalColorForward16(l, d, color);
               //  Ext_FinalColorForward17(l, d, color);
               //  Ext_FinalColorForward18(l, d, color);
               //  Ext_FinalColorForward19(l, d, color);
               //  Ext_FinalColorForward20(l, d, color);
               //  Ext_FinalColorForward21(l, d, color);
               //  Ext_FinalColorForward22(l, d, color);
               //  Ext_FinalColorForward23(l, d, color);
               //  Ext_FinalColorForward24(l, d, color);
               //  Ext_FinalColorForward25(l, d, color);
               //  Ext_FinalColorForward26(l, d, color);
               //  Ext_FinalColorForward27(l, d, color);
               //  Ext_FinalColorForward28(l, d, color);
               //  Ext_FinalColorForward29(l, d, color);
            }

            void ChainFinalGBufferStandard(inout Surface s, inout ShaderData d, inout half4 GBuffer0, inout half4 GBuffer1, inout half4 GBuffer2, inout half4 outEmission, inout half4 outShadowMask)
            {
               //   Ext_FinalGBufferStandard0(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //   Ext_FinalGBufferStandard1(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //   Ext_FinalGBufferStandard2(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //   Ext_FinalGBufferStandard3(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //   Ext_FinalGBufferStandard4(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //   Ext_FinalGBufferStandard5(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //   Ext_FinalGBufferStandard6(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //   Ext_FinalGBufferStandard7(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //   Ext_FinalGBufferStandard8(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //   Ext_FinalGBufferStandard9(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard10(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard11(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard12(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard13(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard14(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard15(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard16(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard17(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard18(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard19(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard20(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard21(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard22(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard23(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard24(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard25(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard26(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard27(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard28(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard29(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
            }



         

         ShaderData CreateShaderData(VertexToPixel i
                  #if NEED_FACING
                     , bool facing
                  #endif
         )
         {
            ShaderData d = (ShaderData)0;
            d.clipPos = i.pos;
            d.worldSpacePosition = i.worldPos;

            d.worldSpaceNormal = normalize(i.worldNormal);
            d.worldSpaceTangent = normalize(i.worldTangent.xyz);
            d.tangentSign = i.worldTangent.w;
            float3 bitangent = cross(i.worldTangent.xyz, i.worldNormal) * d.tangentSign * -1;
            

            d.TBNMatrix = float3x3(d.worldSpaceTangent, bitangent, d.worldSpaceNormal);
            d.worldSpaceViewDir = normalize(_WorldSpaceCameraPos - i.worldPos);

            d.tangentSpaceViewDir = mul(d.TBNMatrix, d.worldSpaceViewDir);
             d.texcoord0 = i.texcoord0;
            // d.texcoord1 = i.texcoord1;
            // d.texcoord2 = i.texcoord2;

            // #if %TEXCOORD3REQUIREKEY%
            // d.texcoord3 = i.texcoord3;
            // #endif

            // d.isFrontFace = facing;
            // #if %VERTEXCOLORREQUIREKEY%
             d.vertexColor = i.vertexColor;
            // #endif

            // these rarely get used, so we back transform them. Usually will be stripped.
            #if _HDRP
                // d.localSpacePosition = mul(unity_WorldToObject, float4(GetCameraRelativePositionWS(i.worldPos), 1)).xyz;
            #else
                // d.localSpacePosition = mul(unity_WorldToObject, float4(i.worldPos, 1)).xyz;
            #endif
            // d.localSpaceNormal = normalize(mul((float3x3)unity_WorldToObject, i.worldNormal));
            // d.localSpaceTangent = normalize(mul((float3x3)unity_WorldToObject, i.worldTangent.xyz));

            // #if %SCREENPOSREQUIREKEY%
             d.screenPos = i.screenPos;
             d.screenUV = (i.screenPos.xy / i.screenPos.w);
            // #endif


            // #if %EXTRAV2F0REQUIREKEY%
             d.extraV2F0 = i.extraV2F0;
            // #endif

            // #if %EXTRAV2F1REQUIREKEY%
             d.extraV2F1 = i.extraV2F1;
            // #endif

            // #if %EXTRAV2F2REQUIREKEY%
            // d.extraV2F2 = i.extraV2F2;
            // #endif

            // #if %EXTRAV2F3REQUIREKEY%
            // d.extraV2F3 = i.extraV2F3;
            // #endif

            // #if %EXTRAV2F4REQUIREKEY%
            // d.extraV2F4 = i.extraV2F4;
            // #endif

            // #if %EXTRAV2F5REQUIREKEY%
            // d.extraV2F5 = i.extraV2F5;
            // #endif

            // #if %EXTRAV2F6REQUIREKEY%
            // d.extraV2F6 = i.extraV2F6;
            // #endif

            // #if %EXTRAV2F7REQUIREKEY%
            // d.extraV2F7 = i.extraV2F7;
            // #endif

            return d;
         }
         

         // vertex shader
         VertexToPixel Vert (VertexData v)
         {
           UNITY_SETUP_INSTANCE_ID(v);
           VertexToPixel o;
           UNITY_INITIALIZE_OUTPUT(VertexToPixel,o);
           UNITY_TRANSFER_INSTANCE_ID(v,o);
           UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

#if !_TESSELLATION_ON
           ChainModifyVertex(v, o, _Time);
#endif

           o.pos = UnityObjectToClipPos(v.vertex);
            o.texcoord0 = v.texcoord0;
           // o.texcoord1 = v.texcoord1;
           // o.texcoord2 = v.texcoord2;

           // #if %TEXCOORD3REQUIREKEY%
           // o.texcoord3 = v.texcoord3;
           // #endif

           // #if %VERTEXCOLORREQUIREKEY%
            o.vertexColor = v.vertexColor;
           // #endif

           // #if %SCREENPOSREQUIREKEY%
            o.screenPos = ComputeScreenPos(o.pos);
           // #endif

           o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
           o.worldNormal = UnityObjectToWorldNormal(v.normal);
           o.worldTangent.xyz = UnityObjectToWorldDir(v.tangent.xyz);
           fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
           o.worldTangent.w = tangentSign;

           #ifdef DYNAMICLIGHTMAP_ON
           o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
           #endif
           #ifdef LIGHTMAP_ON
           o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
           #endif

           // SH/ambient and vertex lights
           #ifndef LIGHTMAP_ON
             #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
               o.sh = 0;
               // Approximated illumination from non-important point lights
               #ifdef VERTEXLIGHT_ON
                 o.sh += Shade4PointLights (
                   unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
                   unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
                   unity_4LightAtten0, o.worldPos, o.worldNormal);
               #endif
               o.sh = ShadeSHPerVertex (o.worldNormal, o.sh);
             #endif
           #endif // !LIGHTMAP_ON

           UNITY_TRANSFER_LIGHTING(o,v.texcoord1.xy); // pass shadow and, possibly, light cookie coordinates to pixel shader
           #ifdef FOG_COMBINED_WITH_TSPACE
             UNITY_TRANSFER_FOG_COMBINED_WITH_TSPACE(o,o.pos); // pass fog coordinates to pixel shader
           #elif defined (FOG_COMBINED_WITH_WORLD_POS)
             UNITY_TRANSFER_FOG_COMBINED_WITH_WORLD_POS(o,o.pos); // pass fog coordinates to pixel shader
           #else
             UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader
           #endif

           return o;
         }

         

         // fragment shader
         fixed4 Frag (VertexToPixel IN
         #ifdef _DEPTHOFFSET_ON
              , out float outputDepth : SV_Depth
         #endif
         #if NEED_FACING
            , bool facing : SV_IsFrontFace
         #endif
         ) : SV_Target
         {
           UNITY_SETUP_INSTANCE_ID(IN);
           // prepare and unpack data
           #ifdef FOG_COMBINED_WITH_TSPACE
             UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
           #elif defined (FOG_COMBINED_WITH_WORLD_POS)
             UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
           #else
             UNITY_EXTRACT_FOG(IN);
           #endif

           ShaderData d = CreateShaderData(IN
              #if NEED_FACING
                 , facing
              #endif
           );
           Surface l = (Surface)0;


           #ifdef _DEPTHOFFSET_ON
              l.outputDepth = outputDepth;
           #endif

           

           l.Albedo = half3(0.5, 0.5, 0.5);
           l.Normal = float3(0,0,1);
           l.Occlusion = 1;
           l.Alpha = 1;

           ChainSurfaceFunction(l, d);

            

           #ifdef _DEPTHOFFSET_ON
              outputDepth = l.outputDepth;
           #endif


           #ifndef USING_DIRECTIONAL_LIGHT
             fixed3 lightDir = normalize(UnityWorldSpaceLightDir(d.worldSpacePosition));
           #else
             fixed3 lightDir = _WorldSpaceLightPos0.xyz;
           #endif
           float3 worldViewDir = normalize(UnityWorldSpaceViewDir(d.worldSpacePosition));

           // compute lighting & shadowing factor
           UNITY_LIGHT_ATTENUATION(atten, IN, d.worldSpacePosition)

           #if _USESPECULAR || _USESPECULARWORKFLOW || _SPECULARFROMMETALLIC
              #ifdef UNITY_COMPILER_HLSL
                 SurfaceOutputStandardSpecular o = (SurfaceOutputStandardSpecular)0;
              #else
                 SurfaceOutputStandardSpecular o;
              #endif
              o.Specular = l.Specular;
              o.Occlusion = l.Occlusion;
              o.Smoothness = l.Smoothness;
           #elif _BDRFLAMBERT || _BDRF3 || _SIMPLELIT
              #ifdef UNITY_COMPILER_HLSL
                 SurfaceOutput o = (SurfaceOutput)0;
              #else
                 SurfaceOutput o;
              #endif

              o.Specular = l.Specular;
              o.Gloss = l.Smoothness;
              _SpecColor.rgb = l.Specular; // fucking hell Unity, wtf..
           #else
              #ifdef UNITY_COMPILER_HLSL
                 SurfaceOutputStandard o = (SurfaceOutputStandard)0;
              #else
                 SurfaceOutputStandard o;
              #endif
              o.Smoothness = l.Smoothness;
              o.Metallic = l.Metallic;
              o.Occlusion = l.Occlusion;
           #endif

           o.Albedo = l.Albedo;
           o.Emission = l.Emission;
           o.Alpha = l.Alpha;
           #if _WORLDSPACENORMAL
              o.Normal = l.Normal;
           #else
              o.Normal = normalize(TangentToWorldSpace(d, l.Normal));
           #endif

            fixed4 c = 0;
            // Setup lighting environment
            UnityGI gi;
            UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
            gi.indirect.diffuse = 0;
            gi.indirect.specular = 0;
            gi.light.color = _LightColor0.rgb;
            gi.light.dir = lightDir;
            // Call GI (lightmaps/SH/reflections) lighting function
            UnityGIInput giInput;
            UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
            giInput.light = gi.light;
            giInput.worldPos = d.worldSpacePosition;
            giInput.worldViewDir = worldViewDir;
            giInput.atten = atten;
            #if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
               giInput.lightmapUV = IN.lmap;
            #else
               giInput.lightmapUV = 0.0;
            #endif
            #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
               giInput.ambient = IN.sh;
            #else
               giInput.ambient.rgb = 0.0;
            #endif
            giInput.probeHDR[0] = unity_SpecCube0_HDR;
            giInput.probeHDR[1] = unity_SpecCube1_HDR;
            #if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
               giInput.boxMin[0] = unity_SpecCube0_BoxMin; // .w holds lerp value for blending
            #endif
            #ifdef UNITY_SPECCUBE_BOX_PROJECTION
               giInput.boxMax[0] = unity_SpecCube0_BoxMax;
               giInput.probePosition[0] = unity_SpecCube0_ProbePosition;
               giInput.boxMax[1] = unity_SpecCube1_BoxMax;
               giInput.boxMin[1] = unity_SpecCube1_BoxMin;
               giInput.probePosition[1] = unity_SpecCube1_ProbePosition;
            #endif

            

            #if defined(_OVERRIDE_SHADOWMASK)
               float4 mulColor = saturate(dot(l.ShadowMask, unity_OcclusionMaskSelector));
               gi.light.color = mulColor;
               giInput.light.color = mulColor;
            #endif

            #if _UNLIT
              c.rgb = l.Albedo;
              c.a = l.Alpha;
            #elif _BDRF3 || _SIMPLELIT
               LightingBlinnPhong_GI(o, giInput, gi);
               #if defined(_OVERRIDE_BAKEDGI)
                  gi.indirect.diffuse = l.DiffuseGI;
                  gi.indirect.specular = l.SpecularGI;
               #endif
               c += LightingBlinnPhong (o, d.worldSpaceViewDir, gi);
            #elif _USESPECULAR || _USESPECULARWORKFLOW || _SPECULARFROMMETALLIC
               LightingStandardSpecular_GI(o, giInput, gi);
               #if defined(_OVERRIDE_BAKEDGI)
                  gi.indirect.diffuse = l.DiffuseGI;
                  gi.indirect.specular = l.SpecularGI;
               #endif
               c += LightingStandardSpecular (o, d.worldSpaceViewDir, gi);
            #else
               LightingStandard_GI(o, giInput, gi);
               #if defined(_OVERRIDE_BAKEDGI)
                  gi.indirect.diffuse = l.DiffuseGI;
                  gi.indirect.specular = l.SpecularGI;
               #endif
               c += LightingStandard (o, d.worldSpaceViewDir, gi);
            #endif

           c.rgb += o.Emission;

           ChainFinalColorForward(l, d, c);

           #if !DISABLEFOG
            UNITY_APPLY_FOG(_unity_fogCoord, c); // apply fog
           #endif
           

           return c;
         }

         ENDCG

      }


      
      

	   // ---- forward rendering additive lights pass:
	   Pass
      {
		   Name "FORWARD"
		   Tags { "LightMode" = "ForwardAdd" }
		   ZWrite Off Blend One One
         Blend SrcAlpha One
         	ZWrite On


         CGPROGRAM

            #pragma vertex Vert
   #pragma fragment Frag

         // compile directives
         #pragma target 3.0
         #pragma multi_compile_instancing
         #pragma multi_compile_fog
         #pragma skip_variants INSTANCING_ON
         #pragma multi_compile_fwdadd_fullshadows
         #include "HLSLSupport.cginc"
         #define UNITY_INSTANCED_LOD_FADE
         #define UNITY_INSTANCED_SH
         #define UNITY_INSTANCED_LIGHTMAPSTS
         #include "UnityShaderVariables.cginc"
         #include "UnityShaderUtilities.cginc"


         #include "UnityCG.cginc"
         #include "Lighting.cginc"
         #include "UnityPBSLighting.cginc"
         #include "AutoLight.cginc"

         

         #define _PASSFORWARD 1
         #define _PASSFORWARDADD 1

         
	#include "Flow.cginc"


	#pragma shader_feature_local _ _STOCHASTIC_ON
	#pragma shader_feature_local _FOAM_OFF _FOAM_ALPHA _FOAM_CUTOUT


	#pragma shader_feature_local _ _FACETED_ON


	#pragma shader_feature_local _ALPHA_OFF _ALPHA_VERTICAL _ALPHA_DEPTH _ALPHA_MARCH_FLUID _ALPHA_MARCH_FLUID_AND_DEPTH


    #pragma shader_feature_local DISABLEFOG    


   #define _STANDARD 1

   #define _ALPHABLEND_ON 1
// If your looking in here and thinking WTF, yeah, I know. These are taken from the SRPs, to allow us to use the same
// texturing library they use. However, since they are not included in the standard pipeline by default, there is no
// way to include them in and they have to be inlined, since someone could copy this shader onto another machine without
// Better Shaders installed. Unfortunate, but I'd rather do this and have a nice library for texture sampling instead
// of the patchy one Unity provides being inlined/emulated in HDRP/URP. Strangely, PSSL and XBoxOne libraries are not
// included in the standard SRP code, but they are in tons of Unity own projects on the web, so I grabbed them from there.

#if defined(SHADER_API_GAMECORE)

	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }

	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) textureName.CalculateLevelOfDetail(samplerName, coord2)

	// Texture abstraction

	#define TEXTURE2D(textureName)                Texture2D textureName
	#define TEXTURE2D_ARRAY(textureName)          Texture2DArray textureName
	#define TEXTURECUBE(textureName)              TextureCube textureName
	#define TEXTURECUBE_ARRAY(textureName)        TextureCubeArray textureName
	#define TEXTURE3D(textureName)                Texture3D textureName

	#define TEXTURE2D_FLOAT(textureName)          TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_FLOAT(textureName)    TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_FLOAT(textureName)        TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)  TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_FLOAT(textureName)          TEXTURE3D(textureName)

	#define TEXTURE2D_HALF(textureName)           TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_HALF(textureName)     TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_HALF(textureName)         TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_HALF(textureName)   TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_HALF(textureName)           TEXTURE3D(textureName)

	#define TEXTURE2D_SHADOW(textureName)         TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_SHADOW(textureName)   TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_SHADOW(textureName)       TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_SHADOW(textureName) TEXTURECUBE_ARRAY(textureName)

	#define RW_TEXTURE2D(type, textureName)       RWTexture2D<type> textureName
	#define RW_TEXTURE2D_ARRAY(type, textureName) RWTexture2DArray<type> textureName
	#define RW_TEXTURE3D(type, textureName)       RWTexture3D<type> textureName

	#define SAMPLER(samplerName)                  SamplerState samplerName
	#define SAMPLER_CMP(samplerName)              SamplerComparisonState samplerName
	#define ASSIGN_SAMPLER(samplerName, samplerValue) samplerName = samplerValue

	#define TEXTURE2D_PARAM(textureName, samplerName)                 TEXTURE2D(textureName),         SAMPLER(samplerName)
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)           TEXTURE2D_ARRAY(textureName),   SAMPLER(samplerName)
	#define TEXTURECUBE_PARAM(textureName, samplerName)               TEXTURECUBE(textureName),       SAMPLER(samplerName)
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)         TEXTURECUBE_ARRAY(textureName), SAMPLER(samplerName)
	#define TEXTURE3D_PARAM(textureName, samplerName)                 TEXTURE3D(textureName),         SAMPLER(samplerName)

	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)          TEXTURE2D(textureName),         SAMPLER_CMP(samplerName)
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)    TEXTURE2D_ARRAY(textureName),   SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)        TEXTURECUBE(textureName),       SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_ARRAY_SHADOW_PARAM(textureName, samplerName)  TEXTURECUBE_ARRAY(textureName), SAMPLER_CMP(samplerName)

	#define TEXTURE2D_ARGS(textureName, samplerName)                textureName, samplerName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)          textureName, samplerName
	#define TEXTURECUBE_ARGS(textureName, samplerName)              textureName, samplerName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)        textureName, samplerName
	#define TEXTURE3D_ARGS(textureName, samplerName)                textureName, samplerName

	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)         textureName, samplerName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)   textureName, samplerName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)       textureName, samplerName
	#define TEXTURECUBE_ARRAY_SHADOW_ARGS(textureName, samplerName) textureName, samplerName

	#define PLATFORM_SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               textureName.Sample(samplerName, coord2)
	#define PLATFORM_SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      textureName.SampleLevel(samplerName, coord2, lod)
	#define PLATFORM_SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    textureName.SampleBias(samplerName, coord2, bias)
	#define PLATFORM_SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)              textureName.SampleGrad(samplerName, coord2, dpdx, dpdy)
	#define PLATFORM_SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  textureName.Sample(samplerName, float3(coord2, index))
	#define PLATFORM_SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         textureName.SampleLevel(samplerName, float3(coord2, index), lod)
	#define PLATFORM_SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       textureName.SampleBias(samplerName, float3(coord2, index), bias)
	#define PLATFORM_SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) textureName.SampleGrad(samplerName, float3(coord2, index), dpdx, dpdy)
	#define PLATFORM_SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             textureName.Sample(samplerName, coord3)
	#define PLATFORM_SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    textureName.SampleLevel(samplerName, coord3, lod)
	#define PLATFORM_SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  textureName.SampleBias(samplerName, coord3, bias)
	#define PLATFORM_SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)                textureName.Sample(samplerName, float4(coord3, index))
	#define PLATFORM_SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)       textureName.SampleLevel(samplerName, float4(coord3, index), lod)
	#define PLATFORM_SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)     textureName.SampleBias(samplerName, float4(coord3, index), bias)
	#define PLATFORM_SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                               textureName.Sample(samplerName, coord3)
	#define PLATFORM_SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                      textureName.SampleLevel(samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               PLATFORM_SAMPLE_TEXTURE2D(textureName, samplerName, coord2)
	#define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      PLATFORM_SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)
	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    PLATFORM_SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)              PLATFORM_SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  PLATFORM_SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         PLATFORM_SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       PLATFORM_SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) PLATFORM_SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             PLATFORM_SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    PLATFORM_SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  PLATFORM_SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)                PLATFORM_SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)       PLATFORM_SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)     PLATFORM_SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)
	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                               PLATFORM_SAMPLE_TEXTURE3D(textureName, samplerName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                      PLATFORM_SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                    textureName.SampleCmpLevelZero(samplerName, (coord3).xy, (coord3).z)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)       textureName.SampleCmpLevelZero(samplerName, float3((coord3).xy, index), (coord3).z)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                  textureName.SampleCmpLevelZero(samplerName, (coord4).xyz, (coord4).w)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)     textureName.SampleCmpLevelZero(samplerName, float4((coord4).xyz, index), (coord4).w)

	#define SAMPLE_DEPTH_TEXTURE(textureName, samplerName, coord2)          SAMPLE_TEXTURE2D(textureName, samplerName, coord2).r
	#define SAMPLE_DEPTH_TEXTURE_LOD(textureName, samplerName, coord2, lod) SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod).r

	#define LOAD_TEXTURE2D(textureName, unCoord2)                                   textureName.Load(int3(unCoord2, 0))
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)                          textureName.Load(int3(unCoord2, lod))
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)                 textureName.Load(unCoord2, sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)                      textureName.Load(int4(unCoord2, index, 0))
	#define LOAD_TEXTURE2D_ARRAY_MSAA(textureName, unCoord2, index, sampleIndex)    textureName.Load(int3(unCoord2, index), sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod)             textureName.Load(int4(unCoord2, index, lod))
	#define LOAD_TEXTURE3D(textureName, unCoord3)                                   textureName.Load(int4(unCoord3, 0))
	#define LOAD_TEXTURE3D_LOD(textureName, unCoord3, lod)                          textureName.Load(int4(unCoord3, lod))

	#define PLATFORM_SUPPORT_GATHER
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                textureName.Gather(samplerName, coord2)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)   textureName.Gather(samplerName, float3(coord2, index))
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)              textureName.Gather(samplerName, coord3)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index) textureName.Gather(samplerName, float4(coord3, index))
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)            textureName.GatherRed(samplerName, coord2)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherGreen(samplerName, coord2)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)           textureName.GatherBlue(samplerName, coord2)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherAlpha(samplerName, coord2)


#elif defined(SHADER_API_XBOXONE)
	
	// Initialize arbitrary structure with zero values.
	// Do not exist on some platform, in this case we need to have a standard name that call a function that will initialize all parameters to 0
	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }

	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) textureName.CalculateLevelOfDetail(samplerName, coord2)

	// Texture abstraction

	#define TEXTURE2D(textureName)                Texture2D textureName
	#define TEXTURE2D_ARRAY(textureName)          Texture2DArray textureName
	#define TEXTURECUBE(textureName)              TextureCube textureName
	#define TEXTURECUBE_ARRAY(textureName)        TextureCubeArray textureName
	#define TEXTURE3D(textureName)                Texture3D textureName

	#define TEXTURE2D_FLOAT(textureName)          TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_FLOAT(textureName)    TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_FLOAT(textureName)        TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)  TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_FLOAT(textureName)          TEXTURE3D(textureName)

	#define TEXTURE2D_HALF(textureName)           TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_HALF(textureName)     TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_HALF(textureName)         TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_HALF(textureName)   TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_HALF(textureName)           TEXTURE3D(textureName)

	#define TEXTURE2D_SHADOW(textureName)         TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_SHADOW(textureName)   TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_SHADOW(textureName)       TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_SHADOW(textureName) TEXTURECUBE_ARRAY(textureName)

	#define RW_TEXTURE2D(type, textureName)       RWTexture2D<type> textureName
	#define RW_TEXTURE2D_ARRAY(type, textureName) RWTexture2DArray<type> textureName
	#define RW_TEXTURE3D(type, textureName)       RWTexture3D<type> textureName

	#define SAMPLER(samplerName)                  SamplerState samplerName
	#define SAMPLER_CMP(samplerName)              SamplerComparisonState samplerName

	#define TEXTURE2D_PARAM(textureName, samplerName)                 TEXTURE2D(textureName),         SAMPLER(samplerName)
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)           TEXTURE2D_ARRAY(textureName),   SAMPLER(samplerName)
	#define TEXTURECUBE_PARAM(textureName, samplerName)               TEXTURECUBE(textureName),       SAMPLER(samplerName)
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)         TEXTURECUBE_ARRAY(textureName), SAMPLER(samplerName)
	#define TEXTURE3D_PARAM(textureName, samplerName)                 TEXTURE3D(textureName),         SAMPLER(samplerName)

	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)          TEXTURE2D(textureName),         SAMPLER_CMP(samplerName)
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)    TEXTURE2D_ARRAY(textureName),   SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)        TEXTURECUBE(textureName),       SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_ARRAY_SHADOW_PARAM(textureName, samplerName)  TEXTURECUBE_ARRAY(textureName), SAMPLER_CMP(samplerName)

	#define TEXTURE2D_ARGS(textureName, samplerName)                textureName, samplerName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)          textureName, samplerName
	#define TEXTURECUBE_ARGS(textureName, samplerName)              textureName, samplerName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)        textureName, samplerName
	#define TEXTURE3D_ARGS(textureName, samplerName)                textureName, samplerName

	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)         textureName, samplerName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)   textureName, samplerName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)       textureName, samplerName
	#define TEXTURECUBE_ARRAY_SHADOW_ARGS(textureName, samplerName) textureName, samplerName

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               textureName.Sample(samplerName, coord2)
	#define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      textureName.SampleLevel(samplerName, coord2, lod)
	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    textureName.SampleBias(samplerName, coord2, bias)
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)              textureName.SampleGrad(samplerName, coord2, dpdx, dpdy)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  textureName.Sample(samplerName, float3(coord2, index))
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         textureName.SampleLevel(samplerName, float3(coord2, index), lod)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       textureName.SampleBias(samplerName, float3(coord2, index), bias)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) textureName.SampleGrad(samplerName, float3(coord2, index), dpdx, dpdy)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    textureName.SampleLevel(samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  textureName.SampleBias(samplerName, coord3, bias)
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)                textureName.Sample(samplerName, float4(coord3, index))
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)       textureName.SampleLevel(samplerName, float4(coord3, index), lod)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)     textureName.SampleBias(samplerName, float4(coord3, index), bias)
	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                               textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                      textureName.SampleLevel(samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                    textureName.SampleCmpLevelZero(samplerName, (coord3).xy, (coord3).z)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)       textureName.SampleCmpLevelZero(samplerName, float3((coord3).xy, index), (coord3).z)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                  textureName.SampleCmpLevelZero(samplerName, (coord4).xyz, (coord4).w)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)     textureName.SampleCmpLevelZero(samplerName, float4((coord4).xyz, index), (coord4).w)

	#define LOAD_TEXTURE2D(textureName, unCoord2)                                   textureName.Load(int3(unCoord2, 0))
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)                          textureName.Load(int3(unCoord2, lod))
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)                 textureName.Load(unCoord2, sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)                      textureName.Load(int4(unCoord2, index, 0))
	#define LOAD_TEXTURE2D_ARRAY_MSAA(textureName, unCoord2, index, sampleIndex)    textureName.Load(int3(unCoord2, index), sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod)             textureName.Load(int4(unCoord2, index, lod))
	#define LOAD_TEXTURE3D(textureName, unCoord3)                                   textureName.Load(int4(unCoord3, 0))
	#define LOAD_TEXTURE3D_LOD(textureName, unCoord3, lod)                          textureName.Load(int4(unCoord3, lod))

	#define PLATFORM_SUPPORT_GATHER
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                textureName.Gather(samplerName, coord2)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)   textureName.Gather(samplerName, float3(coord2, index))
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)              textureName.Gather(samplerName, coord3)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index) textureName.Gather(samplerName, float4(coord3, index))
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)            textureName.GatherRed(samplerName, coord2)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherGreen(samplerName, coord2)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)           textureName.GatherBlue(samplerName, coord2)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherAlpha(samplerName, coord2)


#elif defined(SHADER_API_PSSL)

	// Initialize arbitrary structure with zero values.
	// Do not exist on some platform, in this case we need to have a standard name that call a function that will initialize all parameters to 0
	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }

	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) textureName.GetLOD(samplerName, coord2)

	// Texture abstraction

	#define TEXTURE2D(textureName)                Texture2D textureName
	#define TEXTURE2D_ARRAY(textureName)          Texture2DArray textureName
	#define TEXTURECUBE(textureName)              TextureCube textureName
	#define TEXTURECUBE_ARRAY(textureName)        TextureCubeArray textureName
	#define TEXTURE3D(textureName)                Texture3D textureName

	#define TEXTURE2D_FLOAT(textureName)          TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_FLOAT(textureName)    TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_FLOAT(textureName)        TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)  TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_FLOAT(textureName)          TEXTURE3D(textureName)

	#define TEXTURE2D_HALF(textureName)           TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_HALF(textureName)     TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_HALF(textureName)         TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_HALF(textureName)   TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_HALF(textureName)           TEXTURE3D(textureName)

	#define TEXTURE2D_SHADOW(textureName)         TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_SHADOW(textureName)   TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_SHADOW(textureName)       TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_SHADOW(textureName) TEXTURECUBE_ARRAY(textureName)

	#define RW_TEXTURE2D(type, textureName)       RW_Texture2D<type> textureName
	#define RW_TEXTURE2D_ARRAY(type, textureName) RW_Texture2D_Array<type> textureName
	#define RW_TEXTURE3D(type, textureName)       RW_Texture3D<type> textureName

	#define SAMPLER(samplerName)                  SamplerState samplerName
	#define SAMPLER_CMP(samplerName)              SamplerComparisonState samplerName

	#define TEXTURE2D_PARAM(textureName, samplerName)                 TEXTURE2D(textureName),         SAMPLER(samplerName)
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)           TEXTURE2D_ARRAY(textureName),   SAMPLER(samplerName)
	#define TEXTURECUBE_PARAM(textureName, samplerName)               TEXTURECUBE(textureName),       SAMPLER(samplerName)
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)         TEXTURECUBE_ARRAY(textureName), SAMPLER(samplerName)
	#define TEXTURE3D_PARAM(textureName, samplerName)                 TEXTURE3D(textureName),         SAMPLER(samplerName)

	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)          TEXTURE2D(textureName),         SAMPLER_CMP(samplerName)
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)    TEXTURE2D_ARRAY(textureName),   SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)        TEXTURECUBE(textureName),       SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_ARRAY_SHADOW_PARAM(textureName, samplerName)  TEXTURECUBE_ARRAY(textureName), SAMPLER_CMP(samplerName)

	#define TEXTURE2D_ARGS(textureName, samplerName)                textureName, samplerName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)          textureName, samplerName
	#define TEXTURECUBE_ARGS(textureName, samplerName)              textureName, samplerName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)        textureName, samplerName
	#define TEXTURE3D_ARGS(textureName, samplerName)                textureName, samplerName

	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)         textureName, samplerName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)   textureName, samplerName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)       textureName, samplerName
	#define TEXTURECUBE_ARRAY_SHADOW_ARGS(textureName, samplerName) textureName, samplerName

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               textureName.Sample(samplerName, coord2)
	#define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      textureName.SampleLevel(samplerName, coord2, lod)
	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    textureName.SampleBias(samplerName, coord2, bias)
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)              textureName.SampleGrad(samplerName, coord2, dpdx, dpdy)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  textureName.Sample(samplerName, float3(coord2, index))
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         textureName.SampleLevel(samplerName, float3(coord2, index), lod)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       textureName.SampleBias(samplerName, float3(coord2, index), bias)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) textureName.SampleGrad(samplerName, float3(coord2, index), dpdx, dpdy)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    textureName.SampleLevel(samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  textureName.SampleBias(samplerName, coord3, bias)
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)                textureName.Sample(samplerName, float4(coord3, index))
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)       textureName.SampleLevel(samplerName, float4(coord3, index), lod)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)     textureName.SampleBias(samplerName, float4(coord3, index), bias)
	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                               textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                      textureName.SampleLevel(samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                    textureName.SampleCmpLevelZero(samplerName, (coord3).xy, (coord3).z)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)       textureName.SampleCmpLevelZero(samplerName, float3((coord3).xy, index), (coord3).z)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                  textureName.SampleCmpLevelZero(samplerName, (coord4).xyz, (coord4).w)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)     textureName.SampleCmpLevelZero(samplerName, float4((coord4).xyz, index), (coord4).w)

	#define LOAD_TEXTURE2D(textureName, unCoord2)                                   textureName.Load(int3(unCoord2, 0))
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)                          textureName.Load(int3(unCoord2, lod))
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)                 textureName.Load(unCoord2, sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)                      textureName.Load(int4(unCoord2, index, 0))
	#define LOAD_TEXTURE2D_ARRAY_MSAA(textureName, unCoord2, index, sampleIndex)    textureName.Load(int3(unCoord2, index), sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod)             textureName.Load(int4(unCoord2, index, lod))
	#define LOAD_TEXTURE3D(textureName, unCoord3)                                   textureName.Load(int4(unCoord3, 0))
	#define LOAD_TEXTURE3D_LOD(textureName, unCoord3, lod)                          textureName.Load(int4(unCoord3, lod))

	#define PLATFORM_SUPPORT_GATHER
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                textureName.Gather(samplerName, coord2)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)   textureName.Gather(samplerName, float3(coord2, index))
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)              textureName.Gather(samplerName, coord3)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index) textureName.Gather(samplerName, float4(coord3, index))
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)            textureName.GatherRed(samplerName, coord2)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherGreen(samplerName, coord2)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)           textureName.GatherBlue(samplerName, coord2)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherAlpha(samplerName, coord2)



#elif defined(SHADER_API_D3D11)

	// Initialize arbitrary structure with zero values.
	// Do not exist on some platform, in this case we need to have a standard name that call a function that will initialize all parameters to 0
	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }

	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) textureName.CalculateLevelOfDetail(samplerName, coord2)

	// Texture abstraction

	#define TEXTURE2D(textureName)                Texture2D textureName
	#define TEXTURE2D_ARRAY(textureName)          Texture2DArray textureName
	#define TEXTURECUBE(textureName)              TextureCube textureName
	#define TEXTURECUBE_ARRAY(textureName)        TextureCubeArray textureName
	#define TEXTURE3D(textureName)                Texture3D textureName

	#define TEXTURE2D_FLOAT(textureName)          TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_FLOAT(textureName)    TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_FLOAT(textureName)        TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)  TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_FLOAT(textureName)          TEXTURE3D(textureName)

	#define TEXTURE2D_HALF(textureName)           TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_HALF(textureName)     TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_HALF(textureName)         TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_HALF(textureName)   TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_HALF(textureName)           TEXTURE3D(textureName)

	#define TEXTURE2D_SHADOW(textureName)         TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_SHADOW(textureName)   TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_SHADOW(textureName)       TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_SHADOW(textureName) TEXTURECUBE_ARRAY(textureName)

	#define RW_TEXTURE2D(type, textureName)       RWTexture2D<type> textureName
	#define RW_TEXTURE2D_ARRAY(type, textureName) RWTexture2DArray<type> textureName
	#define RW_TEXTURE3D(type, textureName)       RWTexture3D<type> textureName

	#define SAMPLER(samplerName)                  SamplerState samplerName
	#define SAMPLER_CMP(samplerName)              SamplerComparisonState samplerName

	#define TEXTURE2D_PARAM(textureName, samplerName)                 TEXTURE2D(textureName),         SAMPLER(samplerName)
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)           TEXTURE2D_ARRAY(textureName),   SAMPLER(samplerName)
	#define TEXTURECUBE_PARAM(textureName, samplerName)               TEXTURECUBE(textureName),       SAMPLER(samplerName)
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)         TEXTURECUBE_ARRAY(textureName), SAMPLER(samplerName)
	#define TEXTURE3D_PARAM(textureName, samplerName)                 TEXTURE3D(textureName),         SAMPLER(samplerName)

	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)          TEXTURE2D(textureName),         SAMPLER_CMP(samplerName)
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)    TEXTURE2D_ARRAY(textureName),   SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)        TEXTURECUBE(textureName),       SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_ARRAY_SHADOW_PARAM(textureName, samplerName)  TEXTURECUBE_ARRAY(textureName), SAMPLER_CMP(samplerName)

	#define TEXTURE2D_ARGS(textureName, samplerName)                textureName, samplerName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)          textureName, samplerName
	#define TEXTURECUBE_ARGS(textureName, samplerName)              textureName, samplerName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)        textureName, samplerName
	#define TEXTURE3D_ARGS(textureName, samplerName)                textureName, samplerName

	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)         textureName, samplerName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)   textureName, samplerName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)       textureName, samplerName
	#define TEXTURECUBE_ARRAY_SHADOW_ARGS(textureName, samplerName) textureName, samplerName

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               textureName.Sample(samplerName, coord2)
	#define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      textureName.SampleLevel(samplerName, coord2, lod)
	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    textureName.SampleBias(samplerName, coord2, bias)
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)              textureName.SampleGrad(samplerName, coord2, dpdx, dpdy)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  textureName.Sample(samplerName, float3(coord2, index))
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         textureName.SampleLevel(samplerName, float3(coord2, index), lod)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       textureName.SampleBias(samplerName, float3(coord2, index), bias)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) textureName.SampleGrad(samplerName, float3(coord2, index), dpdx, dpdy)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    textureName.SampleLevel(samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  textureName.SampleBias(samplerName, coord3, bias)
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)                textureName.Sample(samplerName, float4(coord3, index))
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)       textureName.SampleLevel(samplerName, float4(coord3, index), lod)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)     textureName.SampleBias(samplerName, float4(coord3, index), bias)
	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                               textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                      textureName.SampleLevel(samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                    textureName.SampleCmpLevelZero(samplerName, (coord3).xy, (coord3).z)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)       textureName.SampleCmpLevelZero(samplerName, float3((coord3).xy, index), (coord3).z)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                  textureName.SampleCmpLevelZero(samplerName, (coord4).xyz, (coord4).w)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)     textureName.SampleCmpLevelZero(samplerName, float4((coord4).xyz, index), (coord4).w)

	#define LOAD_TEXTURE2D(textureName, unCoord2)                                   textureName.Load(int3(unCoord2, 0))
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)                          textureName.Load(int3(unCoord2, lod))
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)                 textureName.Load(unCoord2, sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)                      textureName.Load(int4(unCoord2, index, 0))
	#define LOAD_TEXTURE2D_ARRAY_MSAA(textureName, unCoord2, index, sampleIndex)    textureName.Load(int3(unCoord2, index), sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod)             textureName.Load(int4(unCoord2, index, lod))
	#define LOAD_TEXTURE3D(textureName, unCoord3)                                   textureName.Load(int4(unCoord3, 0))
	#define LOAD_TEXTURE3D_LOD(textureName, unCoord3, lod)                          textureName.Load(int4(unCoord3, lod))

	#define PLATFORM_SUPPORT_GATHER
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                textureName.Gather(samplerName, coord2)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)   textureName.Gather(samplerName, float3(coord2, index))
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)              textureName.Gather(samplerName, coord3)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index) textureName.Gather(samplerName, float4(coord3, index))
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)            textureName.GatherRed(samplerName, coord2)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherGreen(samplerName, coord2)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)           textureName.GatherBlue(samplerName, coord2)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherAlpha(samplerName, coord2)

#elif defined(SHADER_API_METAL)

	// Initialize arbitrary structure with zero values.
	// Do not exist on some platform, in this case we need to have a standard name that call a function that will initialize all parameters to 0
	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }

	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) textureName.CalculateLevelOfDetail(samplerName, coord2)

	// Texture abstraction

	#define TEXTURE2D(textureName)                Texture2D textureName
	#define TEXTURE2D_ARRAY(textureName)          Texture2DArray textureName
	#define TEXTURECUBE(textureName)              TextureCube textureName
	#define TEXTURECUBE_ARRAY(textureName)        TextureCubeArray textureName
	#define TEXTURE3D(textureName)                Texture3D textureName

	#define TEXTURE2D_FLOAT(textureName)          Texture2D_float textureName
	#define TEXTURE2D_ARRAY_FLOAT(textureName)    Texture2DArray textureName    // no support to _float on Array, it's being added
	#define TEXTURECUBE_FLOAT(textureName)        TextureCube_float textureName
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)  TextureCubeArray textureName  // no support to _float on Array, it's being added
	#define TEXTURE3D_FLOAT(textureName)          Texture3D_float textureName

	#define TEXTURE2D_HALF(textureName)           Texture2D_half textureName
	#define TEXTURE2D_ARRAY_HALF(textureName)     Texture2DArray textureName    // no support to _float on Array, it's being added
	#define TEXTURECUBE_HALF(textureName)         TextureCube_half textureName
	#define TEXTURECUBE_ARRAY_HALF(textureName)   TextureCubeArray textureName  // no support to _float on Array, it's being added
	#define TEXTURE3D_HALF(textureName)           Texture3D_half textureName

	#define TEXTURE2D_SHADOW(textureName)         TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_SHADOW(textureName)   TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_SHADOW(textureName)       TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_SHADOW(textureName) TEXTURECUBE_ARRAY(textureName)

	#define RW_TEXTURE2D(type, textureName)       RWTexture2D<type> textureName
	#define RW_TEXTURE2D_ARRAY(type, textureName) RWTexture2DArray<type> textureName
	#define RW_TEXTURE3D(type, textureName)       RWTexture3D<type> textureName

	#define SAMPLER(samplerName)                  SamplerState samplerName
	#define SAMPLER_CMP(samplerName)              SamplerComparisonState samplerName

	#define TEXTURE2D_PARAM(textureName, samplerName)                 TEXTURE2D(textureName),         SAMPLER(samplerName)
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)           TEXTURE2D_ARRAY(textureName),   SAMPLER(samplerName)
	#define TEXTURECUBE_PARAM(textureName, samplerName)               TEXTURECUBE(textureName),       SAMPLER(samplerName)
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)         TEXTURECUBE_ARRAY(textureName), SAMPLER(samplerName)
	#define TEXTURE3D_PARAM(textureName, samplerName)                 TEXTURE3D(textureName),         SAMPLER(samplerName)

	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)          TEXTURE2D(textureName),         SAMPLER_CMP(samplerName)
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)    TEXTURE2D_ARRAY(textureName),   SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)        TEXTURECUBE(textureName),       SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_ARRAY_SHADOW_PARAM(textureName, samplerName)  TEXTURECUBE_ARRAY(textureName), SAMPLER_CMP(samplerName)

	#define TEXTURE2D_ARGS(textureName, samplerName)                textureName, samplerName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)          textureName, samplerName
	#define TEXTURECUBE_ARGS(textureName, samplerName)              textureName, samplerName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)        textureName, samplerName
	#define TEXTURE3D_ARGS(textureName, samplerName)                textureName, samplerName

	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)         textureName, samplerName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)   textureName, samplerName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)       textureName, samplerName
	#define TEXTURECUBE_ARRAY_SHADOW_ARGS(textureName, samplerName) textureName, samplerName

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               textureName.Sample(samplerName, coord2)
	#define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      textureName.SampleLevel(samplerName, coord2, lod)
	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    textureName.SampleBias(samplerName, coord2, bias)
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)              textureName.SampleGrad(samplerName, coord2, dpdx, dpdy)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  textureName.Sample(samplerName, float3(coord2, index))
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         textureName.SampleLevel(samplerName, float3(coord2, index), lod)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       textureName.SampleBias(samplerName, float3(coord2, index), bias)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) textureName.SampleGrad(samplerName, float3(coord2, index), dpdx, dpdy)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    textureName.SampleLevel(samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  textureName.SampleBias(samplerName, coord3, bias)
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)                textureName.Sample(samplerName, float4(coord3, index))
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)       textureName.SampleLevel(samplerName, float4(coord3, index), lod)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)     textureName.SampleBias(samplerName, float4(coord3, index), bias)
	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                               textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                      textureName.SampleLevel(samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                    textureName.SampleCmpLevelZero(samplerName, (coord3).xy, (coord3).z)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)       textureName.SampleCmpLevelZero(samplerName, float3((coord3).xy, index), (coord3).z)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                  textureName.SampleCmpLevelZero(samplerName, (coord4).xyz, (coord4).w)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)     textureName.SampleCmpLevelZero(samplerName, float4((coord4).xyz, index), (coord4).w)

	#define LOAD_TEXTURE2D(textureName, unCoord2)                                   textureName.Load(int3(unCoord2, 0))
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)                          textureName.Load(int3(unCoord2, lod))
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)                 textureName.Load(unCoord2, sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)                      textureName.Load(int4(unCoord2, index, 0))
	#define LOAD_TEXTURE2D_ARRAY_MSAA(textureName, unCoord2, index, sampleIndex)    textureName.Load(int3(unCoord2, index), sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod)             textureName.Load(int4(unCoord2, index, lod))
	#define LOAD_TEXTURE3D(textureName, unCoord3)                                   textureName.Load(int4(unCoord3, 0))
	#define LOAD_TEXTURE3D_LOD(textureName, unCoord3, lod)                          textureName.Load(int4(unCoord3, lod))

	#define PLATFORM_SUPPORT_GATHER
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                textureName.Gather(samplerName, coord2)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)   textureName.Gather(samplerName, float3(coord2, index))
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)              textureName.Gather(samplerName, coord3)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index) textureName.Gather(samplerName, float4(coord3, index))
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)            textureName.GatherRed(samplerName, coord2)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherGreen(samplerName, coord2)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)           textureName.GatherBlue(samplerName, coord2)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherAlpha(samplerName, coord2)

#elif defined(SHADER_API_VULKAN)
// This file assume SHADER_API_VULKAN is defined
	// TODO: This is a straight copy from D3D11.hlsl. Go through all this stuff and adjust where needed.


	// Initialize arbitrary structure with zero values.
	// Do not exist on some platform, in this case we need to have a standard name that call a function that will initialize all parameters to 0
	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }

	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) textureName.CalculateLevelOfDetail(samplerName, coord2)

	// Texture abstraction

	#define TEXTURE2D(textureName)                Texture2D textureName
	#define TEXTURE2D_ARRAY(textureName)          Texture2DArray textureName
	#define TEXTURECUBE(textureName)              TextureCube textureName
	#define TEXTURECUBE_ARRAY(textureName)        TextureCubeArray textureName
	#define TEXTURE3D(textureName)                Texture3D textureName

	#define TEXTURE2D_FLOAT(textureName)          Texture2D_float textureName
	#define TEXTURE2D_ARRAY_FLOAT(textureName)    Texture2DArray textureName    // no support to _float on Array, it's being added
	#define TEXTURECUBE_FLOAT(textureName)        TextureCube_float textureName
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)  TextureCubeArray textureName  // no support to _float on Array, it's being added
	#define TEXTURE3D_FLOAT(textureName)          Texture3D_float textureName

	#define TEXTURE2D_HALF(textureName)           Texture2D_half textureName
	#define TEXTURE2D_ARRAY_HALF(textureName)     Texture2DArray textureName    // no support to _float on Array, it's being added
	#define TEXTURECUBE_HALF(textureName)         TextureCube_half textureName
	#define TEXTURECUBE_ARRAY_HALF(textureName)   TextureCubeArray textureName  // no support to _float on Array, it's being added
	#define TEXTURE3D_HALF(textureName)           Texture3D_half textureName

	#define TEXTURE2D_SHADOW(textureName)         TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_SHADOW(textureName)   TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_SHADOW(textureName)       TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_SHADOW(textureName) TEXTURECUBE_ARRAY(textureName)

	#define RW_TEXTURE2D(type, textureName)       RWTexture2D<type> textureName
	#define RW_TEXTURE2D_ARRAY(type, textureName) RWTexture2DArray<type> textureName
	#define RW_TEXTURE3D(type, textureName)       RWTexture3D<type> textureName

	#define SAMPLER(samplerName)                  SamplerState samplerName
	#define SAMPLER_CMP(samplerName)              SamplerComparisonState samplerName

	#define TEXTURE2D_PARAM(textureName, samplerName)                 TEXTURE2D(textureName),         SAMPLER(samplerName)
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)           TEXTURE2D_ARRAY(textureName),   SAMPLER(samplerName)
	#define TEXTURECUBE_PARAM(textureName, samplerName)               TEXTURECUBE(textureName),       SAMPLER(samplerName)
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)         TEXTURECUBE_ARRAY(textureName), SAMPLER(samplerName)
	#define TEXTURE3D_PARAM(textureName, samplerName)                 TEXTURE3D(textureName),         SAMPLER(samplerName)

	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)          TEXTURE2D(textureName),         SAMPLER_CMP(samplerName)
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)    TEXTURE2D_ARRAY(textureName),   SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)        TEXTURECUBE(textureName),       SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_ARRAY_SHADOW_PARAM(textureName, samplerName)  TEXTURECUBE_ARRAY(textureName), SAMPLER_CMP(samplerName)

	#define TEXTURE2D_ARGS(textureName, samplerName)                textureName, samplerName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)          textureName, samplerName
	#define TEXTURECUBE_ARGS(textureName, samplerName)              textureName, samplerName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)        textureName, samplerName
	#define TEXTURE3D_ARGS(textureName, samplerName)                textureName, samplerName

	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)         textureName, samplerName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)   textureName, samplerName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)       textureName, samplerName
	#define TEXTURECUBE_ARRAY_SHADOW_ARGS(textureName, samplerName) textureName, samplerName

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               textureName.Sample(samplerName, coord2)
	#define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      textureName.SampleLevel(samplerName, coord2, lod)
	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    textureName.SampleBias(samplerName, coord2, bias)
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)              textureName.SampleGrad(samplerName, coord2, dpdx, dpdy)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  textureName.Sample(samplerName, float3(coord2, index))
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         textureName.SampleLevel(samplerName, float3(coord2, index), lod)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       textureName.SampleBias(samplerName, float3(coord2, index), bias)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) textureName.SampleGrad(samplerName, float3(coord2, index), dpdx, dpdy)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    textureName.SampleLevel(samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  textureName.SampleBias(samplerName, coord3, bias)
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)                textureName.Sample(samplerName, float4(coord3, index))
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)       textureName.SampleLevel(samplerName, float4(coord3, index), lod)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)     textureName.SampleBias(samplerName, float4(coord3, index), bias)
	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                               textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                      textureName.SampleLevel(samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                    textureName.SampleCmpLevelZero(samplerName, (coord3).xy, (coord3).z)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)       textureName.SampleCmpLevelZero(samplerName, float3((coord3).xy, index), (coord3).z)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                  textureName.SampleCmpLevelZero(samplerName, (coord4).xyz, (coord4).w)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)     textureName.SampleCmpLevelZero(samplerName, float4((coord4).xyz, index), (coord4).w)

	#define LOAD_TEXTURE2D(textureName, unCoord2)                                   textureName.Load(int3(unCoord2, 0))
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)                          textureName.Load(int3(unCoord2, lod))
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)                 textureName.Load(unCoord2, sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)                      textureName.Load(int4(unCoord2, index, 0))
	#define LOAD_TEXTURE2D_ARRAY_MSAA(textureName, unCoord2, index, sampleIndex)    textureName.Load(int3(unCoord2, index), sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod)             textureName.Load(int4(unCoord2, index, lod))
	#define LOAD_TEXTURE3D(textureName, unCoord3)                                   textureName.Load(int4(unCoord3, 0))
	#define LOAD_TEXTURE3D_LOD(textureName, unCoord3, lod)                          textureName.Load(int4(unCoord3, lod))

	#define PLATFORM_SUPPORT_GATHER
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                textureName.Gather(samplerName, coord2)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)   textureName.Gather(samplerName, float3(coord2, index))
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)              textureName.Gather(samplerName, coord3)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index) textureName.Gather(samplerName, float4(coord3, index))
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)            textureName.GatherRed(samplerName, coord2)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherGreen(samplerName, coord2)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)           textureName.GatherBlue(samplerName, coord2)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherAlpha(samplerName, coord2)

#elif defined(SHADER_API_SWITCH)
	// This file assume SHADER_API_SWITCH is defined

	// Initialize arbitrary structure with zero values.
	// Do not exist on some platform, in this case we need to have a standard name that call a function that will initialize all parameters to 0
	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }

	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) textureName.CalculateLevelOfDetail(samplerName, coord2)

	// Texture abstraction

	#define TEXTURE2D(textureName)                Texture2D textureName
	#define TEXTURE2D_ARRAY(textureName)          Texture2DArray textureName
	#define TEXTURECUBE(textureName)              TextureCube textureName
	#define TEXTURECUBE_ARRAY(textureName)        TextureCubeArray textureName
	#define TEXTURE3D(textureName)                Texture3D textureName

	#define TEXTURE2D_FLOAT(textureName)          Texture2D_float textureName
	#define TEXTURE2D_ARRAY_FLOAT(textureName)    Texture2DArray textureName    // no support to _float on Array, it's being added
	#define TEXTURECUBE_FLOAT(textureName)        TextureCube_float textureName
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)  TextureCubeArray textureName  // no support to _float on Array, it's being added
	#define TEXTURE3D_FLOAT(textureName)          Texture3D_float textureName

	#define TEXTURE2D_HALF(textureName)           Texture2D_half textureName
	#define TEXTURE2D_ARRAY_HALF(textureName)     Texture2DArray textureName    // no support to _float on Array, it's being added
	#define TEXTURECUBE_HALF(textureName)         TextureCube_half textureName
	#define TEXTURECUBE_ARRAY_HALF(textureName)   TextureCubeArray textureName  // no support to _float on Array, it's being added
	#define TEXTURE3D_HALF(textureName)           Texture3D_half textureName

	#define TEXTURE2D_SHADOW(textureName)         TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_SHADOW(textureName)   TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_SHADOW(textureName)       TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_SHADOW(textureName) TEXTURECUBE_ARRAY(textureName)

	#define RW_TEXTURE2D(type, textureName)       RWTexture2D<type> textureName
	#define RW_TEXTURE2D_ARRAY(type, textureName) RWTexture2DArray<type> textureName
	#define RW_TEXTURE3D(type, textureName)       RWTexture3D<type> textureName

	#define SAMPLER(samplerName)                  SamplerState samplerName
	#define SAMPLER_CMP(samplerName)              SamplerComparisonState samplerName

	#define TEXTURE2D_PARAM(textureName, samplerName)                 TEXTURE2D(textureName),         SAMPLER(samplerName)
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)           TEXTURE2D_ARRAY(textureName),   SAMPLER(samplerName)
	#define TEXTURECUBE_PARAM(textureName, samplerName)               TEXTURECUBE(textureName),       SAMPLER(samplerName)
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)         TEXTURECUBE_ARRAY(textureName), SAMPLER(samplerName)
	#define TEXTURE3D_PARAM(textureName, samplerName)                 TEXTURE3D(textureName),         SAMPLER(samplerName)

	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)          TEXTURE2D(textureName),         SAMPLER_CMP(samplerName)
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)    TEXTURE2D_ARRAY(textureName),   SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)        TEXTURECUBE(textureName),       SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_ARRAY_SHADOW_PARAM(textureName, samplerName)  TEXTURECUBE_ARRAY(textureName), SAMPLER_CMP(samplerName)

	#define TEXTURE2D_ARGS(textureName, samplerName)                textureName, samplerName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)          textureName, samplerName
	#define TEXTURECUBE_ARGS(textureName, samplerName)              textureName, samplerName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)        textureName, samplerName
	#define TEXTURE3D_ARGS(textureName, samplerName)                textureName, samplerName

	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)         textureName, samplerName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)   textureName, samplerName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)       textureName, samplerName
	#define TEXTURECUBE_ARRAY_SHADOW_ARGS(textureName, samplerName) textureName, samplerName

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               textureName.Sample(samplerName, coord2)
	#define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      textureName.SampleLevel(samplerName, coord2, lod)
	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    textureName.SampleBias(samplerName, coord2, bias)
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)              textureName.SampleGrad(samplerName, coord2, dpdx, dpdy)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  textureName.Sample(samplerName, float3(coord2, index))
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         textureName.SampleLevel(samplerName, float3(coord2, index), lod)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       textureName.SampleBias(samplerName, float3(coord2, index), bias)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) textureName.SampleGrad(samplerName, float3(coord2, index), dpdx, dpdy)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    textureName.SampleLevel(samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  textureName.SampleBias(samplerName, coord3, bias)
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)                textureName.Sample(samplerName, float4(coord3, index))
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)       textureName.SampleLevel(samplerName, float4(coord3, index), lod)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)     textureName.SampleBias(samplerName, float4(coord3, index), bias)
	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                               textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                      textureName.SampleLevel(samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                    textureName.SampleCmpLevelZero(samplerName, (coord3).xy, (coord3).z)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)       textureName.SampleCmpLevelZero(samplerName, float3((coord3).xy, index), (coord3).z)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                  textureName.SampleCmpLevelZero(samplerName, (coord4).xyz, (coord4).w)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)     textureName.SampleCmpLevelZero(samplerName, float4((coord4).xyz, index), (coord4).w)


	#define LOAD_TEXTURE2D(textureName, unCoord2)                       textureName.Load(int3(unCoord2, 0))
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)              textureName.Load(int3(unCoord2, lod))
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)     textureName.Load(unCoord2, sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)          textureName.Load(int4(unCoord2, index, 0))
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod) textureName.Load(int4(unCoord2, index, lod))
	#define LOAD_TEXTURE3D(textureName, unCoord3)                       textureName.Load(int4(unCoord3, 0))
	#define LOAD_TEXTURE3D_LOD(textureName, unCoord3, lod)              textureName.Load(int4(unCoord3, lod))

	#define PLATFORM_SUPPORT_GATHER
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                textureName.Gather(samplerName, coord2)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)   textureName.Gather(samplerName, float3(coord2, index))
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)              textureName.Gather(samplerName, coord3)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index) textureName.Gather(samplerName, float4(coord3, index))
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)            textureName.GatherRed(samplerName, coord2)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherGreen(samplerName, coord2)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)           textureName.GatherBlue(samplerName, coord2)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherAlpha(samplerName, coord2)

#elif defined(SHADER_API_GLCORE)

	// OpenGL 4.1 SM 5.0 https://docs.unity3d.com/Manual/SL-ShaderCompileTargets.html
	#if (SHADER_TARGET >= 46)
	#define OPENGL4_1_SM5 1
	#else
	#define OPENGL4_1_SM5 0
	#endif

	// Initialize arbitrary structure with zero values.
	// Do not exist on some platform, in this case we need to have a standard name that call a function that will initialize all parameters to 0
	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }

	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) textureName.CalculateLevelOfDetail(samplerName, coord2)

	// Texture abstraction

	#define TEXTURE2D(textureName)                  Texture2D textureName
	#define TEXTURE2D_ARRAY(textureName)            Texture2DArray textureName
	#define TEXTURECUBE(textureName)                TextureCube textureName
	#define TEXTURECUBE_ARRAY(textureName)          TextureCubeArray textureName
	#define TEXTURE3D(textureName)                  Texture3D textureName

	#define TEXTURE2D_FLOAT(textureName)            TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_FLOAT(textureName)      TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_FLOAT(textureName)          TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)    TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_FLOAT(textureName)            TEXTURE3D(textureName)

	#define TEXTURE2D_HALF(textureName)             TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_HALF(textureName)       TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_HALF(textureName)           TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_HALF(textureName)     TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_HALF(textureName)             TEXTURE3D(textureName)

	#define TEXTURE2D_SHADOW(textureName)           TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_SHADOW(textureName)     TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_SHADOW(textureName)         TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_SHADOW(textureName)   TEXTURECUBE_ARRAY(textureName)

	#define RW_TEXTURE2D(type, textureName)         RWTexture2D<type> textureName
	#define RW_TEXTURE2D_ARRAY(type, textureName)   RWTexture2DArray<type> textureName
	#define RW_TEXTURE3D(type, textureName)         RWTexture3D<type> textureName

	#define SAMPLER(samplerName)                    SamplerState samplerName
	#define SAMPLER_CMP(samplerName)                SamplerComparisonState samplerName

	#define TEXTURE2D_PARAM(textureName, samplerName)                 TEXTURE2D(textureName),         SAMPLER(samplerName)
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)           TEXTURE2D_ARRAY(textureName),   SAMPLER(samplerName)
	#define TEXTURECUBE_PARAM(textureName, samplerName)               TEXTURECUBE(textureName),       SAMPLER(samplerName)
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)         TEXTURECUBE_ARRAY(textureName), SAMPLER(samplerName)
	#define TEXTURE3D_PARAM(textureName, samplerName)                 TEXTURE3D(textureName),         SAMPLER(samplerName)

	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)          TEXTURE2D(textureName),         SAMPLER_CMP(samplerName)
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)    TEXTURE2D_ARRAY(textureName),   SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)        TEXTURECUBE(textureName),       SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_ARRAY_SHADOW_PARAM(textureName, samplerName)  TEXTURECUBE_ARRAY(textureName), SAMPLER_CMP(samplerName)

	#define TEXTURE2D_ARGS(textureName, samplerName)                textureName, samplerName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)          textureName, samplerName
	#define TEXTURECUBE_ARGS(textureName, samplerName)              textureName, samplerName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)        textureName, samplerName
	#define TEXTURE3D_ARGS(textureName, samplerName)                textureName, samplerName

	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)         textureName, samplerName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)   textureName, samplerName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)       textureName, samplerName
	#define TEXTURECUBE_ARRAY_SHADOW_ARGS(textureName, samplerName) textureName, samplerName

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               textureName.Sample(samplerName, coord2)
	#define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      textureName.SampleLevel(samplerName, coord2, lod)
	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    textureName.SampleBias(samplerName, coord2, bias)
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, ddx, ddy)                textureName.SampleGrad(samplerName, coord2, ddx, ddy)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  textureName.Sample(samplerName, float3(coord2, index))
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         textureName.SampleLevel(samplerName, float3(coord2, index), lod)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       textureName.SampleBias(samplerName, float3(coord2, index), bias)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) textureName.SampleGrad(samplerName, float3(coord2, index), dpdx, dpdy)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    textureName.SampleLevel(samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  textureName.SampleBias(samplerName, coord3, bias)
	#ifdef UNITY_NO_CUBEMAP_ARRAY
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)           ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY)
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)  ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY_LOD)
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, bias) ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY_LOD)
	#else
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)           textureName.Sample(samplerName, float4(coord3, index))
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)  textureName.SampleLevel(samplerName, float4(coord3, index), lod)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)textureName.SampleBias(samplerName, float4(coord3, index), bias)
	#endif
	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                          textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                 textureName.SampleLevel(samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                   textureName.SampleCmpLevelZero(samplerName, (coord3).xy, (coord3).z)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)      textureName.SampleCmpLevelZero(samplerName, float3((coord3).xy, index), (coord3).z)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                 textureName.SampleCmpLevelZero(samplerName, (coord4).xyz, (coord4).w)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)    textureName.SampleCmpLevelZero(samplerName, float4((coord4).xyz, index), (coord4).w)

	#define LOAD_TEXTURE2D(textureName, unCoord2)                                   textureName.Load(int3(unCoord2, 0))
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)                          textureName.Load(int3(unCoord2, lod))
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)                 textureName.Load(unCoord2, sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)                      textureName.Load(int4(unCoord2, index, 0))
	#define LOAD_TEXTURE2D_ARRAY_MSAA(textureName, unCoord2, index, sampleIndex)    textureName.Load(int3(unCoord2, index), sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod)             textureName.Load(int4(unCoord2, index, lod))

	#if OPENGL4_1_SM5
	#define PLATFORM_SUPPORT_GATHER
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                  textureName.Gather(samplerName, coord2)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)     textureName.Gather(samplerName, float3(coord2, index))
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)                textureName.Gather(samplerName, coord3)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)   textureName.Gather(samplerName, float4(coord3, index))
	#else
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                  ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURE2D)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)     ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURE2D_ARRAY)
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)                ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURECUBE)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)   ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURECUBE_ARRAY)
	#endif


	#elif defined(SHADER_API_GLES3)

	// GLES 3.1 + AEP shader feature https://docs.unity3d.com/Manual/SL-ShaderCompileTargets.html
	#if (SHADER_TARGET >= 40)
	#define GLES3_1_AEP 1
	#else
	#define GLES3_1_AEP 0
	#endif

	// Initialize arbitrary structure with zero values.
	// Do not exist on some platform, in this case we need to have a standard name that call a function that will initialize all parameters to 0
	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }

	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) textureName.CalculateLevelOfDetail(samplerName, coord2)

	// Texture abstraction

	#define TEXTURE2D(textureName)                  Texture2D textureName
	#define TEXTURE2D_ARRAY(textureName)            Texture2DArray textureName
	#define TEXTURECUBE(textureName)                TextureCube textureName
	#define TEXTURECUBE_ARRAY(textureName)          TextureCubeArray textureName
	#define TEXTURE3D(textureName)                  Texture3D textureName

	#define TEXTURE2D_FLOAT(textureName)            Texture2D_float textureName
	#define TEXTURE2D_ARRAY_FLOAT(textureName)      Texture2DArray textureName    // no support to _float on Array, it's being added
	#define TEXTURECUBE_FLOAT(textureName)          TextureCube_float textureName
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)    TextureCubeArray textureName  // no support to _float on Array, it's being added
	#define TEXTURE3D_FLOAT(textureName)            Texture3D_float textureName

	#define TEXTURE2D_HALF(textureName)             Texture2D_half textureName
	#define TEXTURE2D_ARRAY_HALF(textureName)       Texture2DArray textureName    // no support to _float on Array, it's being added
	#define TEXTURECUBE_HALF(textureName)           TextureCube_half textureName
	#define TEXTURECUBE_ARRAY_HALF(textureName)     TextureCubeArray textureName  // no support to _float on Array, it's being added
	#define TEXTURE3D_HALF(textureName)             Texture3D_half textureName

	#define TEXTURE2D_SHADOW(textureName)           TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_SHADOW(textureName)     TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_SHADOW(textureName)         TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_SHADOW(textureName)   TEXTURECUBE_ARRAY(textureName)

	#if GLES3_1_AEP
	#define RW_TEXTURE2D(type, textureName)         RWTexture2D<type> textureName
	#define RW_TEXTURE2D_ARRAY(type, textureName)   RWTexture2DArray<type> textureName
	#define RW_TEXTURE3D(type, textureName)         RWTexture3D<type> textureName
	#else
	#define RW_TEXTURE2D(type, textureName)         ERROR_ON_UNSUPPORTED_FUNCTION(RWTexture2D)
	#define RW_TEXTURE2D_ARRAY(type, textureName)   ERROR_ON_UNSUPPORTED_FUNCTION(RWTexture2DArray)
	#define RW_TEXTURE3D(type, textureName)         ERROR_ON_UNSUPPORTED_FUNCTION(RWTexture3D)
	#endif

	#define SAMPLER(samplerName)                    SamplerState samplerName
	#define SAMPLER_CMP(samplerName)                SamplerComparisonState samplerName

	#define TEXTURE2D_PARAM(textureName, samplerName)                 TEXTURE2D(textureName),         SAMPLER(samplerName)
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)           TEXTURE2D_ARRAY(textureName),   SAMPLER(samplerName)
	#define TEXTURECUBE_PARAM(textureName, samplerName)               TEXTURECUBE(textureName),       SAMPLER(samplerName)
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)         TEXTURECUBE_ARRAY(textureName), SAMPLER(samplerName)
	#define TEXTURE3D_PARAM(textureName, samplerName)                 TEXTURE3D(textureName),         SAMPLER(samplerName)

	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)          TEXTURE2D(textureName),         SAMPLER_CMP(samplerName)
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)    TEXTURE2D_ARRAY(textureName),   SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)        TEXTURECUBE(textureName),       SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_ARRAY_SHADOW_PARAM(textureName, samplerName)  TEXTURECUBE_ARRAY(textureName), SAMPLER_CMP(samplerName)

	#define TEXTURE2D_ARGS(textureName, samplerName)                textureName, samplerName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)          textureName, samplerName
	#define TEXTURECUBE_ARGS(textureName, samplerName)              textureName, samplerName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)        textureName, samplerName
	#define TEXTURE3D_ARGS(textureName, samplerName)                textureName, samplerName

	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)         textureName, samplerName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)   textureName, samplerName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)       textureName, samplerName
	#define TEXTURECUBE_ARRAY_SHADOW_ARGS(textureName, samplerName) textureName, samplerName

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               textureName.Sample(samplerName, coord2)
	#define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      textureName.SampleLevel(samplerName, coord2, lod)
	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    textureName.SampleBias(samplerName, coord2, bias)
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, ddx, ddy)                textureName.SampleGrad(samplerName, coord2, ddx, ddy)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  textureName.Sample(samplerName, float3(coord2, index))
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         textureName.SampleLevel(samplerName, float3(coord2, index), lod)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       textureName.SampleBias(samplerName, float3(coord2, index), bias)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) textureName.SampleGrad(samplerName, float3(coord2, index), dpdx, dpdy)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    textureName.SampleLevel(samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  textureName.SampleBias(samplerName, coord3, bias)

	#ifdef UNITY_NO_CUBEMAP_ARRAY
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)           ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY)
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)  ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY_LOD)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY_BIAS)
	#else
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)           textureName.Sample(samplerName, float4(coord3, index))
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)  textureName.SampleLevel(samplerName, float4(coord3, index), lod)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)textureName.SampleBias(samplerName, float4(coord3, index), bias)
	#endif

	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                          textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                 textureName.SampleLevel(samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                   textureName.SampleCmpLevelZero(samplerName, (coord3).xy, (coord3).z)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)      textureName.SampleCmpLevelZero(samplerName, float3((coord3).xy, index), (coord3).z)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                 textureName.SampleCmpLevelZero(samplerName, (coord4).xyz, (coord4).w)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)    textureName.SampleCmpLevelZero(samplerName, float4((coord4).xyz, index), (coord4).w)


	#define LOAD_TEXTURE2D(textureName, unCoord2)                                       textureName.Load(int3(unCoord2, 0))
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)                              textureName.Load(int3(unCoord2, lod))
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)                     textureName.Load(unCoord2, sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)                          textureName.Load(int4(unCoord2, index, 0))
	#define LOAD_TEXTURE2D_ARRAY_MSAA(textureName, unCoord2, index, sampleIndex)        textureName.Load(int3(unCoord2, index), sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod)                 textureName.Load(int4(unCoord2, index, lod))
	#define LOAD_TEXTURE3D(textureName, unCoord3)                                       textureName.Load(int4(unCoord3, 0))
	#define LOAD_TEXTURE3D_LOD(textureName, unCoord3, lod)                              textureName.Load(int4(unCoord3, lod))

	#if GLES3_1_AEP
	#define PLATFORM_SUPPORT_GATHER
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                  textureName.Gather(samplerName, coord2)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)     textureName.Gather(samplerName, float3(coord2, index))
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)                textureName.Gather(samplerName, coord3)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)   textureName.Gather(samplerName, float4(coord3, index))
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)              textureName.GatherRed(samplerName, coord2)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)            textureName.GatherGreen(samplerName, coord2)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)             textureName.GatherBlue(samplerName, coord2)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)            textureName.GatherAlpha(samplerName, coord2)
	#else
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                  ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURE2D)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)     ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURE2D_ARRAY)
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)                ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURECUBE)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)   ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURECUBE_ARRAY)
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)              ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_RED_TEXTURE2D)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)            ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_GREEN_TEXTURE2D)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)             ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_BLUE_TEXTURE2D)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)            ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_ALPHA_TEXTURE2D)
	#endif


#elif defined(SHADER_API_GLES)


	#define uint int

	#define rcp(x) 1.0 / (x)
	#define ddx_fine ddx
	#define ddy_fine ddy
	#define asfloat
	#define asuint(x) asint(x)
	#define f32tof16
	#define f16tof32

	#define ERROR_ON_UNSUPPORTED_FUNCTION(funcName) #error #funcName is not supported on GLES 2.0

	// Initialize arbitrary structure with zero values.
	// Do not exist on some platform, in this case we need to have a standard name that call a function that will initialize all parameters to 0
	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }


	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) #error calculate Level of Detail not supported in GLES2

	// Texture abstraction

	#define TEXTURE2D(textureName)                          sampler2D textureName
	#define TEXTURE2D_ARRAY(textureName)                    samplerCUBE textureName // No support to texture2DArray
	#define TEXTURECUBE(textureName)                        samplerCUBE textureName
	#define TEXTURECUBE_ARRAY(textureName)                  samplerCUBE textureName // No supoport to textureCubeArray and can't emulate with texture2DArray
	#define TEXTURE3D(textureName)                          sampler3D textureName

	#define TEXTURE2D_FLOAT(textureName)                    sampler2D_float textureName
	#define TEXTURE2D_ARRAY_FLOAT(textureName)              TEXTURECUBE_FLOAT(textureName) // No support to texture2DArray
	#define TEXTURECUBE_FLOAT(textureName)                  samplerCUBE_float textureName
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)            TEXTURECUBE_FLOAT(textureName) // No support to textureCubeArray
	#define TEXTURE3D_FLOAT(textureName)                    sampler3D_float textureName

	#define TEXTURE2D_HALF(textureName)                     sampler2D_half textureName
	#define TEXTURE2D_ARRAY_HALF(textureName)               TEXTURECUBE_HALF(textureName) // No support to texture2DArray
	#define TEXTURECUBE_HALF(textureName)                   samplerCUBE_half textureName
	#define TEXTURECUBE_ARRAY_HALF(textureName)             TEXTURECUBE_HALF(textureName) // No support to textureCubeArray
	#define TEXTURE3D_HALF(textureName)                     sampler3D_half textureName

	#define TEXTURE2D_SHADOW(textureName)                   SHADOW2D_TEXTURE_AND_SAMPLER textureName
	#define TEXTURE2D_ARRAY_SHADOW(textureName)             TEXTURECUBE_SHADOW(textureName) // No support to texture array
	#define TEXTURECUBE_SHADOW(textureName)                 SHADOWCUBE_TEXTURE_AND_SAMPLER textureName
	#define TEXTURECUBE_ARRAY_SHADOW(textureName)           TEXTURECUBE_SHADOW(textureName) // No support to texture array

	#define RW_TEXTURE2D(type, textureNam)                  ERROR_ON_UNSUPPORTED_FUNCTION(RWTexture2D)
	#define RW_TEXTURE2D_ARRAY(type, textureName)           ERROR_ON_UNSUPPORTED_FUNCTION(RWTexture2DArray)
	#define RW_TEXTURE3D(type, textureNam)                  ERROR_ON_UNSUPPORTED_FUNCTION(RWTexture3D)

	#define SAMPLER(samplerName)
	#define SAMPLER_CMP(samplerName)

	#define TEXTURE2D_PARAM(textureName, samplerName)                sampler2D textureName
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)          samplerCUBE textureName
	#define TEXTURECUBE_PARAM(textureName, samplerName)              samplerCUBE textureName
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)        samplerCUBE textureName
	#define TEXTURE3D_PARAM(textureName, samplerName)                sampler3D textureName
	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)         SHADOW2D_TEXTURE_AND_SAMPLER textureName
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)   SHADOWCUBE_TEXTURE_AND_SAMPLER textureName
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)       SHADOWCUBE_TEXTURE_AND_SAMPLER textureName

	#define TEXTURE2D_ARGS(textureName, samplerName)               textureName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)         textureName
	#define TEXTURECUBE_ARGS(textureName, samplerName)             textureName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)       textureName
	#define TEXTURE3D_ARGS(textureName, samplerName)               textureName
	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)        textureName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)  textureName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)      textureName

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2) tex2D(textureName, coord2)

	#if (SHADER_TARGET >= 30)
	    #define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod) tex2Dlod(textureName, float4(coord2, 0, lod))
	#else
	    // No lod support. Very poor approximation with bias.
	    #define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod) SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, lod)
	#endif

	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                       tex2Dbias(textureName, float4(coord2, 0, bias))
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, ddx, ddy)                   SAMPLE_TEXTURE2D(textureName, samplerName, coord2)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                     ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURE2D_ARRAY)
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)            ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURE2D_ARRAY_LOD)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)          ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURE2D_ARRAY_BIAS)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy)    ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURE2D_ARRAY_GRAD)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                                texCUBE(textureName, coord3)
	// No lod support. Very poor approximation with bias.
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                       SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                     texCUBEbias(textureName, float4(coord3, bias))
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)                   ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY)
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)          ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY_LOD)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)        ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY_BIAS)
	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                                  tex3D(textureName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                         ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURE3D_LOD)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                           SHADOW2D_SAMPLE(textureName, samplerName, coord3)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)              ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURE2D_ARRAY_SHADOW)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                         SHADOWCUBE_SAMPLE(textureName, samplerName, coord4)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)            ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY_SHADOW)


	// Not supported. Can't define as error because shader library is calling these functions.
	#define LOAD_TEXTURE2D(textureName, unCoord2)                                               half4(0, 0, 0, 0)
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)                                      half4(0, 0, 0, 0)
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)                             half4(0, 0, 0, 0)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)                                  half4(0, 0, 0, 0)
	#define LOAD_TEXTURE2D_ARRAY_MSAA(textureName, unCoord2, index, sampleIndex)                half4(0, 0, 0, 0)
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod)                         half4(0, 0, 0, 0)
	#define LOAD_TEXTURE3D(textureName, unCoord3)                                               ERROR_ON_UNSUPPORTED_FUNCTION(LOAD_TEXTURE3D)
	#define LOAD_TEXTURE3D_LOD(textureName, unCoord3, lod)                                      ERROR_ON_UNSUPPORTED_FUNCTION(LOAD_TEXTURE3D_LOD)

	// Gather not supported. Fallback to regular texture sampling.
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                  ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURE2D)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)     ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURE2D_ARRAY)
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)                ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURECUBE)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)   ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURECUBE_ARRAY)
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)              ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_RED_TEXTURE2D)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)            ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_GREEN_TEXTURE2D)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)             ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_BLUE_TEXTURE2D)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)            ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_ALPHA_TEXTURE2D)

#else
#error unsupported shader api
#endif




// default flow control attributes
#ifndef UNITY_BRANCH
#   define UNITY_BRANCH
#endif
#ifndef UNITY_FLATTEN
#   define UNITY_FLATTEN
#endif
#ifndef UNITY_UNROLL
#   define UNITY_UNROLL
#endif
#ifndef UNITY_UNROLLX
#   define UNITY_UNROLLX(_x)
#endif
#ifndef UNITY_LOOP
#   define UNITY_LOOP
#endif



#define _GRABPASSUSED 1
#define REQUIRE_OPAQUE_TEXTURE


         // data across stages, stripped like the above.
         struct VertexToPixel
         {
            UNITY_POSITION(pos);       // must be named pos because Unity does stupid macro stuff
            float3 worldPos : TEXCOORD0;
            float3 worldNormal : TEXCOORD1;
            float4 worldTangent : TEXCOORD2;
             float4 texcoord0 : TEXCOORD3;
            // float4 texcoord1 : TEXCOORD4;
            // float4 texcoord2 : TEXCOORD5;

            // #if %TEXCOORD3REQUIREKEY%
            // float4 texcoord3 : TEXCOORD6;
            // #endif
            
            // #if %SCREENPOSREQUIREKEY%
             float4 screenPos : TEXCOORD7;
            // #endif

            UNITY_LIGHTING_COORDS(8,9)
            UNITY_FOG_COORDS(10)

            
            // #if %VERTEXCOLORREQUIREKEY%
             float4 vertexColor : COLOR;
            // #endif

            // #if %EXTRAV2F0REQUIREKEY%
             float4 extraV2F0 : TEXCOORD11;
            // #endif

            // #if %EXTRAV2F1REQUIREKEY%
             float4 extraV2F1 : TEXCOORD12;
            // #endif

            // #if %EXTRAV2F2REQUIREKEY%
            // float4 extraV2F2 : TEXCOORD13;
            // #endif

            // #if %EXTRAV2F3REQUIREKEY%
            // float4 extraV2F3 : TEXCOORD14;
            // #endif

            // #if %EXTRAV2F4REQUIREKEY%
            // float4 extraV2F4 : TEXCOORD15;
            // #endif

            // #if %EXTRAV2F5REQUIREKEY%
            // float4 extraV2F5 : TEXCOORD16;
            // #endif

            // #if %EXTRAV2F6REQUIREKEY%
            // float4 extraV2F6 : TEXCOORD17;
            // #endif

            // #if %EXTRAV2F7REQUIREKEY%
            // float4 extraV2F7 : TEXCOORD18;
            // #endif

            UNITY_VERTEX_INPUT_INSTANCE_ID
            UNITY_VERTEX_OUTPUT_STEREO

         };

         
            
            // data describing the user output of a pixel
            struct Surface
            {
               half3 Albedo;
               half Height;
               half3 Normal;
               half Smoothness;
               half3 Emission;
               half Metallic;
               half3 Specular;
               half Occlusion;
               half SpecularPower; // for simple lighting
               half Alpha;
               float outputDepth; // if written, SV_Depth semantic is used. ShaderData.clipPos.z is unused value
               // HDRP Only
               half SpecularOcclusion;
               half SubsurfaceMask;
               half Thickness;
               half CoatMask;
               half CoatSmoothness;
               half Anisotropy;
               half IridescenceMask;
               half IridescenceThickness;
               int DiffusionProfileHash;
               float SpecularAAThreshold;
               float SpecularAAScreenSpaceVariance;
               // requires _OVERRIDE_BAKEDGI to be defined, but is mapped in all pipelines
               float3 DiffuseGI;
               float3 BackDiffuseGI;
               float3 SpecularGI;
               // requires _OVERRIDE_SHADOWMASK to be defines
               float4 ShadowMask;
            };

            // Data the user declares in blackboard blocks
            struct Blackboard
            {
                
	float  groundHeight;
	float  surfaceHeight;
	float3 surfaceNormal;

	Fluid fluid;


	float foam;


                float blackboardDummyData;
            };

            // data the user might need, this will grow to be big. But easy to strip
            struct ShaderData
            {
               float4 clipPos; // SV_POSITION
               float3 localSpacePosition;
               float3 localSpaceNormal;
               float3 localSpaceTangent;
        
               float3 worldSpacePosition;
               float3 worldSpaceNormal;
               float3 worldSpaceTangent;
               float tangentSign;

               float3 worldSpaceViewDir;
               float3 tangentSpaceViewDir;

               float4 texcoord0;
               float4 texcoord1;
               float4 texcoord2;
               float4 texcoord3;

               float2 screenUV;
               float4 screenPos;

               float4 vertexColor;
               bool isFrontFace;

               float4 extraV2F0;
               float4 extraV2F1;
               float4 extraV2F2;
               float4 extraV2F3;
               float4 extraV2F4;
               float4 extraV2F5;
               float4 extraV2F6;
               float4 extraV2F7;

               float3x3 TBNMatrix;
               Blackboard blackboard;
            };

            struct VertexData
            {
               #if SHADER_TARGET > 30
               // uint vertexID : SV_VertexID;
               #endif
               float4 vertex : POSITION;
               float3 normal : NORMAL;
               float4 tangent : TANGENT;
               float4 texcoord0 : TEXCOORD0;

               // optimize out mesh coords when not in use by user or lighting system
               #if _URP && (_USINGTEXCOORD1 || _PASSMETA || _PASSFORWARD || _PASSGBUFFER)
                  float4 texcoord1 : TEXCOORD1;
               #endif

               #if _URP && (_USINGTEXCOORD2 || _PASSMETA || ((_PASSFORWARD || _PASSGBUFFER) && defined(DYNAMICLIGHTMAP_ON)))
                  float4 texcoord2 : TEXCOORD2;
               #endif

               #if _STANDARD && (_USINGTEXCOORD1 || (_PASSMETA || ((_PASSFORWARD || _PASSGBUFFER || _PASSFORWARDADD) && LIGHTMAP_ON)))
                  float4 texcoord1 : TEXCOORD1;
               #endif
               #if _STANDARD && (_USINGTEXCOORD2 || (_PASSMETA || ((_PASSFORWARD || _PASSGBUFFER) && DYNAMICLIGHTMAP_ON)))
                  float4 texcoord2 : TEXCOORD2;
               #endif


               #if _HDRP
                  float4 texcoord1 : TEXCOORD1;
                  float4 texcoord2 : TEXCOORD2;
               #endif

               // #if %TEXCOORD3REQUIREKEY%
               // float4 texcoord3 : TEXCOORD3;
               // #endif

               // #if %VERTEXCOLORREQUIREKEY%
                float4 vertexColor : COLOR;
               // #endif

               #if _HDRP && (_PASSMOTIONVECTOR || ((_PASSFORWARD || _PASSUNLIT) && defined(_WRITE_TRANSPARENT_MOTION_VECTOR)))
                  float3 previousPositionOS : TEXCOORD4; // Contain previous transform position (in case of skinning for example)
                  #if defined (_ADD_PRECOMPUTED_VELOCITY)
                     float3 precomputedVelocity    : TEXCOORD5; // Add Precomputed Velocity (Alembic computes velocities on runtime side).
                  #endif
               #endif

               UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct TessVertex 
            {
               float4 vertex : INTERNALTESSPOS;
               float3 normal : NORMAL;
               float4 tangent : TANGENT;
               float4 texcoord0 : TEXCOORD0;
               float4 texcoord1 : TEXCOORD1;
               float4 texcoord2 : TEXCOORD2;

               // #if %TEXCOORD3REQUIREKEY%
               // float4 texcoord3 : TEXCOORD3;
               // #endif

               // #if %VERTEXCOLORREQUIREKEY%
                float4 vertexColor : COLOR;
               // #endif

               // #if %EXTRAV2F0REQUIREKEY%
                float4 extraV2F0 : TEXCOORD5;
               // #endif

               // #if %EXTRAV2F1REQUIREKEY%
                float4 extraV2F1 : TEXCOORD6;
               // #endif

               // #if %EXTRAV2F2REQUIREKEY%
               // float4 extraV2F2 : TEXCOORD7;
               // #endif

               // #if %EXTRAV2F3REQUIREKEY%
               // float4 extraV2F3 : TEXCOORD8;
               // #endif

               // #if %EXTRAV2F4REQUIREKEY%
               // float4 extraV2F4 : TEXCOORD9;
               // #endif

               // #if %EXTRAV2F5REQUIREKEY%
               // float4 extraV2F5 : TEXCOORD10;
               // #endif

               // #if %EXTRAV2F6REQUIREKEY%
               // float4 extraV2F6 : TEXCOORD11;
               // #endif

               // #if %EXTRAV2F7REQUIREKEY%
               // float4 extraV2F7 : TEXCOORD12;
               // #endif

               #if _HDRP && (_PASSMOTIONVECTOR || ((_PASSFORWARD || _PASSUNLIT) && defined(_WRITE_TRANSPARENT_MOTION_VECTOR)))
                  float3 previousPositionOS : TEXCOORD13; // Contain previous transform position (in case of skinning for example)
                  #if defined (_ADD_PRECOMPUTED_VELOCITY)
                     float3 precomputedVelocity : TEXCOORD14;
                  #endif
               #endif

               UNITY_VERTEX_INPUT_INSTANCE_ID
               UNITY_VERTEX_OUTPUT_STEREO
            };

            struct ExtraV2F
            {
               float4 extraV2F0;
               float4 extraV2F1;
               float4 extraV2F2;
               float4 extraV2F3;
               float4 extraV2F4;
               float4 extraV2F5;
               float4 extraV2F6;
               float4 extraV2F7;
               Blackboard blackboard;
               float4 time;
            };


            float3 WorldToTangentSpace(ShaderData d, float3 normal)
            {
               return mul(d.TBNMatrix, normal);
            }

            float3 TangentToWorldSpace(ShaderData d, float3 normal)
            {
               return mul(normal, d.TBNMatrix);
            }

            // in this case, make standard more like SRPs, because we can't fix
            // unity_WorldToObject in HDRP, since it already does macro-fu there

            #if _STANDARD
               float3 TransformWorldToObject(float3 p) { return mul(unity_WorldToObject, float4(p, 1)); };
               float3 TransformObjectToWorld(float3 p) { return mul(unity_ObjectToWorld, float4(p, 1)); };
               float4 TransformWorldToObject(float4 p) { return mul(unity_WorldToObject, p); };
               float4 TransformObjectToWorld(float4 p) { return mul(unity_ObjectToWorld, p); };
               float4x4 GetWorldToObjectMatrix() { return unity_WorldToObject; }
               float4x4 GetObjectToWorldMatrix() { return unity_ObjectToWorld; }
               #if (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (SHADER_TARGET_SURFACE_ANALYSIS && !SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))
                 #define UNITY_SAMPLE_TEX2D_LOD(tex,coord, lod) tex.SampleLevel (sampler##tex,coord, lod)
                 #define UNITY_SAMPLE_TEX2D_SAMPLER_LOD(tex,samplertex,coord, lod) tex.SampleLevel (sampler##samplertex,coord, lod)
              #else
                 #define UNITY_SAMPLE_TEX2D_LOD(tex,coord,lod) tex2D (tex,coord,0,lod)
                 #define UNITY_SAMPLE_TEX2D_SAMPLER_LOD(tex,samplertex,coord,lod) tex2D (tex,coord,0,lod)
              #endif

               #undef UNITY_MATRIX_I_M

               #define UNITY_MATRIX_I_M   unity_WorldToObject


            #endif

            float3 GetCameraWorldPosition()
            {
               #if _HDRP
                  return GetCameraRelativePositionWS(_WorldSpaceCameraPos);
               #else
                  return _WorldSpaceCameraPos;
               #endif
            }

            #if _GRABPASSUSED
               #if _STANDARD
                  TEXTURE2D(_Grab);
                  SAMPLER(sampler__Grab);
               #endif

               half3 GetSceneColor(float2 uv)
               {
                  #if _STANDARD
                     return SAMPLE_TEXTURE2D(_Grab, sampler__Grab, uv).rgb;
                  #else
                     return SHADERGRAPH_SAMPLE_SCENE_COLOR(uv);
                  #endif
               }
            #endif


      
            #if _STANDARD
               UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
               float GetSceneDepth(float2 uv) { return SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv); }
               float GetLinear01Depth(float2 uv) { return Linear01Depth(GetSceneDepth(uv)); }
               float GetLinearEyeDepth(float2 uv) { return LinearEyeDepth(GetSceneDepth(uv)); } 
            #else
               float GetSceneDepth(float2 uv) { return SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv); }
               float GetLinear01Depth(float2 uv) { return Linear01Depth(GetSceneDepth(uv), _ZBufferParams); }
               float GetLinearEyeDepth(float2 uv) { return LinearEyeDepth(GetSceneDepth(uv), _ZBufferParams); } 
            #endif

            float3 GetWorldPositionFromDepthBuffer(float2 uv, float3 worldSpaceViewDir)
            {
               float eye = GetLinearEyeDepth(uv);
               float3 camView = mul((float3x3)UNITY_MATRIX_M, transpose(mul(UNITY_MATRIX_I_M, UNITY_MATRIX_I_V)) [2].xyz);

               float dt = dot(worldSpaceViewDir, camView);
               float3 div = worldSpaceViewDir/dt;
               float3 wpos = (eye * div) + GetCameraWorldPosition();
               return wpos;
            }

            #if _HDRP
            float3 ObjectToWorldSpacePosition(float3 pos)
            {
               return GetAbsolutePositionWS(TransformObjectToWorld(pos));
            }
            #else
            float3 ObjectToWorldSpacePosition(float3 pos)
            {
               return TransformObjectToWorld(pos);
            }
            #endif

            #if _STANDARD
               UNITY_DECLARE_SCREENSPACE_TEXTURE(_CameraDepthNormalsTexture);
               float3 GetSceneNormal(float2 uv, float3 worldSpaceViewDir)
               {
                  float4 depthNorms = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_CameraDepthNormalsTexture, uv);
                  float3 norms = DecodeViewNormalStereo(depthNorms);
                  norms = mul((float3x3)UNITY_MATRIX_V, norms) * 0.5 + 0.5;
                  return norms;
               }
            #elif _HDRP
               float3 GetSceneNormal(float2 uv, float3 worldSpaceViewDir)
               {
                  NormalData nd;
                  DecodeFromNormalBuffer(_ScreenSize.xy * uv, nd);
                  return nd.normalWS;
               }
            #elif _URP
               #if (SHADER_LIBRARY_VERSION_MAJOR >= 10)
                  #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareNormalsTexture.hlsl"
               #endif

               float3 GetSceneNormal(float2 uv, float3 worldSpaceViewDir)
               {
                  #if (SHADER_LIBRARY_VERSION_MAJOR >= 10)
                     return SampleSceneNormals(uv);
                  #else
                     float3 wpos = GetWorldPositionFromDepthBuffer(uv, worldSpaceViewDir);
                     return normalize(-cross(ddx(wpos), ddy(wpos))) * 0.5 + 0.5;
                  #endif

                }
             #endif

             #if _HDRP

               half3 UnpackNormalmapRGorAG(half4 packednormal)
               {
                     // This do the trick
                  packednormal.x *= packednormal.w;

                  half3 normal;
                  normal.xy = packednormal.xy * 2 - 1;
                  normal.z = sqrt(1 - saturate(dot(normal.xy, normal.xy)));
                  return normal;
               }
               half3 UnpackNormal(half4 packednormal)
               {
                  #if defined(UNITY_NO_DXT5nm)
                     return packednormal.xyz * 2 - 1;
                  #else
                     return UnpackNormalmapRGorAG(packednormal);
                  #endif
               }
               #endif
               #if _HDRP || _URP

               half3 UnpackScaleNormal(half4 packednormal, half scale)
               {
                 #ifndef UNITY_NO_DXT5nm
                   // Unpack normal as DXT5nm (1, y, 1, x) or BC5 (x, y, 0, 1)
                   // Note neutral texture like "bump" is (0, 0, 1, 1) to work with both plain RGB normal and DXT5nm/BC5
                   packednormal.x *= packednormal.w;
                 #endif
                   half3 normal;
                   normal.xy = (packednormal.xy * 2 - 1) * scale;
                   normal.z = sqrt(1 - saturate(dot(normal.xy, normal.xy)));
                   return normal;
               }	

             #endif


            void GetSun(out float3 lightDir, out float3 color)
            {
               lightDir = float3(0.5, 0.5, 0);
               color = 1;
               #if _HDRP
                  if (_DirectionalLightCount > 0)
                  {
                     DirectionalLightData light = _DirectionalLightDatas[0];
                     lightDir = -light.forward.xyz;
                     color = light.color;
                  }
               #elif _STANDARD
			         lightDir = normalize(_WorldSpaceLightPos0.xyz);
                  color = _LightColor0.rgb;
               #elif _URP
	               Light light = GetMainLight();
	               lightDir = light.direction;
	               color = light.color;
               #endif
            }


            
         
	float    _FlowDensity;
	float2   _FlowSeparationXZ;
	float    _FlowSimulationHeight;
	float    _FlowCameraHeight;
	float2   _FlowCountXZ;
	float4   _FlowCoordU000;
	float4   _FlowCoord0V00;
	float    _FlowSpeed;
	float4x4 _FlowMatrix;

	float _Sink;


	float _WaveStrengthMin;
	float _WaveStrengthMax;
	float _WaveStrengthScale;

	float _Tiling;
	float _AnimationSpeed;
	float _FoamBrightness;


	half _FlatShadingBlend;


	float _RangeMax;
	float _AlphaStep;
	int _AlphaMaxSteps;
	float _AlphaDepthScale;





         

         

         
	TEXTURE2D(_FlowDataA);
	SAMPLER(sampler_FlowDataA);
	TEXTURE2D(_FlowDataB);
	SAMPLER(sampler_FlowDataB);
	TEXTURE2D(_FlowDataC);
	SAMPLER(sampler_FlowDataC);
	TEXTURE2D(_FlowDataD);
	SAMPLER(sampler_FlowDataD);
	TEXTURE2D(_FlowDataE);
	SAMPLER(sampler_FlowDataE);
	TEXTURE2D(_FlowDataF);
	SAMPLER(sampler_FlowDataF);

	float4 SGT_O2W(float4 v)
	{
		v = mul(UNITY_MATRIX_M, v);
		#if _HDRP
			v.xyz = GetAbsolutePositionWS(v.xyz);
		#endif
		return v;
	}

	float4 SGT_W2O(float4 v)
	{
		#if _HDRP
			v.xyz = GetCameraRelativePositionWS(v.xyz);
		#endif
		return mul(UNITY_MATRIX_I_M, v);
	}

	float4 SGT_O2V(float4 v)
	{
		#if _STANDARD
			return float4(UnityObjectToViewPos(v.xyz), 1.0f);
		#else
			return float4(TransformWorldToView(TransformObjectToWorld(v.xyz)), 1.0f);
		#endif
	}

	float GetFluidHeight(float2 uv)
	{
		float groundHeight = SAMPLE_TEXTURE2D_LOD(_FlowDataA, sampler_FlowDataA, uv, 0).r;
		float fluidDepth   = SAMPLE_TEXTURE2D_LOD(_FlowDataC, sampler_FlowDataC, uv, 0).r;

		return groundHeight + fluidDepth;
	}

	float2 GetHeightAndDepth(float2 uv)
	{
		float groundHeight = SAMPLE_TEXTURE2D_LOD(_FlowDataA, sampler_FlowDataA, uv, 0).r;
		float fluidDepth   = SAMPLE_TEXTURE2D_LOD(_FlowDataC, sampler_FlowDataC, uv, 0).r;

		return float2(groundHeight, fluidDepth);
	}

	Column GetColumn(float2 uv)
	{
		return DecodeColumn(SAMPLE_TEXTURE2D_LOD(_FlowDataA, sampler_FlowDataA, uv, 0), SAMPLE_TEXTURE2D_LOD(_FlowDataB, sampler_FlowDataB, uv, 0));
	}

	Fluid GetColumnFluid(float2 uv)
	{
		float4 c = SAMPLE_TEXTURE2D_LOD(_FlowDataC, sampler_FlowDataC, uv, 0);
		float4 d = SAMPLE_TEXTURE2D_LOD(_FlowDataD, sampler_FlowDataD, uv, 0);
		float4 e = SAMPLE_TEXTURE2D_LOD(_FlowDataE, sampler_FlowDataE, uv, 0);
		float4 f = SAMPLE_TEXTURE2D_LOD(_FlowDataF, sampler_FlowDataF, uv, 0);
		return DecodeFluid(c, d, e, f);
	}

	bool InsideFluid(float3 wpos)
	{
		float2 columnPixel = mul(_FlowMatrix, float4(wpos, 1.0f)).xy;
		float2 columnCoord = CoordFromPixel(columnPixel, _FlowCountXZ);
		float2 columnHAD   = GetHeightAndDepth(columnCoord);

		return min(columnCoord.x, columnCoord.y) >= 0.0 && max(columnCoord.x, columnCoord.y) <= 1.0f && wpos.y > columnHAD.x && wpos.y < (columnHAD.x + columnHAD.y);
	}

	bool UnderFluid(float3 wpos)
	{
		float2 columnPixel = mul(_FlowMatrix, float4(wpos, 1.0f)).xy;
		float2 columnCoord = CoordFromPixel(columnPixel, _FlowCountXZ);
		float2 columnHAD   = GetHeightAndDepth(columnCoord);

		return min(columnCoord.x, columnCoord.y) >= 0.0 && max(columnCoord.x, columnCoord.y) <= 1.0f && wpos.y < (columnHAD.x + columnHAD.y);
	}

	float RayMarchInside(float3 wpos, float3 wdir, float step, int maxs, float maxd)
	{
		float epsi = step * 0.01f;
		float dist = 0.0f;

		for (int i = 0; i < maxs && step > epsi; i++)
		{
			dist += step;

			float3 pos = wpos + wdir * dist;

			if (InsideFluid(pos) == false)
			{
				dist -= step;
				step *= 0.5f;
			}

			if (dist > maxd)
			{
				return maxd;
			}
		}

		return dist;
	}

	float RayMarchUnder(float3 wpos, float3 wdir, float step, int maxs, float maxd)
	{
		float epsi = step * 0.01f;
		float dist = 0.0f;

		for (int i = 0; i < maxs && step > epsi; i++)
		{
			dist += step;

			float3 pos = wpos + wdir * dist;

			if (UnderFluid(pos) == false)
			{
				dist -= step;
				step *= 0.5f;
			}

			if (dist > maxd)
			{
				return maxd;
			}
		}

		return dist;
	}

	void Ext_ModifyVertex0 (inout VertexData v, inout ExtraV2F e)
	{
		float4 wpos        = SGT_O2W(v.vertex);
		float2 columnPixel = mul(_FlowMatrix, float4(wpos.xyz, 1.0f)).xy;
		float2 columnCoord = SnapCoordFromPixel(round(columnPixel), _FlowCountXZ);

		Column column0 = GetColumn(columnCoord);
		Column columnL = GetColumn(columnCoord - _FlowCoordU000.xy);
		Column columnR = GetColumn(columnCoord + _FlowCoordU000.xy);
		Column columnB = GetColumn(columnCoord - _FlowCoord0V00.xy);
		Column columnT = GetColumn(columnCoord + _FlowCoord0V00.xy);

		Fluid fluid0 = GetColumnFluid(columnCoord);
		Fluid fluidL = GetColumnFluid(columnCoord - _FlowCoordU000.xy);
		Fluid fluidR = GetColumnFluid(columnCoord + _FlowCoordU000.xy);
		Fluid fluidB = GetColumnFluid(columnCoord - _FlowCoord0V00.xy);
		Fluid fluidT = GetColumnFluid(columnCoord + _FlowCoord0V00.xy);

		float ww = fluidL.Depth + fluidR.Depth + fluidB.Depth + fluidT.Depth + 0.001f;
		float wL = fluidL.Depth / ww;
		float wR = fluidR.Depth / ww;
		float wB = fluidB.Depth / ww;
		float wT = fluidT.Depth / ww;
		float w0 = saturate(fluid0.Depth * 10);

		float hL = columnL.GroundHeight + fluidL.Depth;
		float hR = columnR.GroundHeight + fluidR.Depth;
		float hB = columnB.GroundHeight + fluidB.Depth;
		float hT = columnT.GroundHeight + fluidT.Depth;
		float hh = hL * wL + hR * wR + hB * wB + hT * wT;
		float h0 = column0.GroundHeight + fluid0.Depth;

		hh = lerp(hh, h0 - _Sink, saturate(0.01f / ww)); // Prevent skirts going down too far

		Fluid fluid = fluid0;

		fluid.Depth = lerp(fluidL.Depth * wL + fluidR.Depth * wR + fluidB.Depth * wB + fluidT.Depth * wT, fluid.Depth, w0);
		fluid.RGBA  = lerp(fluidL.RGBA  * wL + fluidR.RGBA  * wR + fluidB.RGBA  * wB + fluidT.RGBA  * wT, fluid.RGBA , w0);
		fluid.ESMV  = lerp(fluidL.ESMV  * wL + fluidR.ESMV  * wR + fluidB.ESMV  * wB + fluidT.ESMV  * wT, fluid.ESMV , w0);
		fluid.F123  = lerp(fluidL.F123  * wL + fluidR.F123  * wR + fluidB.F123  * wB + fluidT.F123  * wT, fluid.F123 , w0);

		e.blackboard.groundHeight  = column0.GroundHeight;
		e.blackboard.surfaceHeight = lerp(hh, h0, w0);
		e.blackboard.surfaceNormal = normalize(float3((hL - hR) / _FlowSeparationXZ.x, 2.0f, (hB - hT) / _FlowSeparationXZ.y));
		e.blackboard.fluid         = fluid;
	}


	TEXTURE2D(_NoiseMap);
	SAMPLER(sampler_NoiseMap);

	TEXTURE2D(_NormalFoamMap);
	SAMPLER(sampler_NormalFoamMap);

	void Ext_ModifyVertex3 (inout VertexData v, inout ExtraV2F e)
	{
		v.vertex.y = lerp(e.blackboard.groundHeight, e.blackboard.surfaceHeight, v.texcoord0.w) - _FlowSimulationHeight;

		v.normal = lerp(e.blackboard.surfaceNormal, v.normal, v.texcoord0.z);

		v.vertexColor = e.blackboard.fluid.RGBA;

		e.extraV2F0.xyz = SGT_O2V(v.vertex).xyz;
		e.extraV2F0.w   = e.blackboard.fluid.Depth;

		e.extraV2F1.xyz = e.blackboard.fluid.ESMV.xyz;
		e.extraV2F1.w = e.blackboard.fluid.F123.x;
	}

	float3 FlowUVW(float2 uv, float2 flowVector, float2 jump, float tiling, float time, float phaseOffset)
	{
		float progress = frac(time + phaseOffset);
		float3 uvw;
		uvw.xy = uv - flowVector * (progress - 0.5f);
		uvw.xy *= tiling;
		uvw.xy += phaseOffset;
		uvw.xy += (time - progress) * jump;
		uvw.z = 1 - abs(1 - 2 * progress);
		return uvw;
	}

	float3 CombineNormals(float3 n1, float3 n2)
	{
		return normalize(half3(n1.xy + n2.xy, n1.z*n2.z));
	}

	float3 UnpackNormalAndScale(float2 xy, float scale)
	{
		xy = xy * 2.0f - 1.0f; xy *= scale; return float3(xy, sqrt(1.0 - saturate(dot(xy, xy))));
	}

	float4 SampleStochastic(float2 uv, float noise)
	{
		float cur_height = uv.y + noise;
		float this_index = floor(cur_height);
		float next_index = this_index + 1.0f;

		float2 uvA     = uv + sin(float2(1.0f, 2.0f) * this_index);
		float2 uvB     = uv + sin(float2(1.0f, 2.0f) * next_index);
		float2 gradX   = ddx(uv);
		float2 gradY   = ddy(uv);

		float4 sampleA = SAMPLE_TEXTURE2D_GRAD(_NormalFoamMap, sampler_NormalFoamMap, uvA, gradX, gradY);
		float4 sampleB = SAMPLE_TEXTURE2D_GRAD(_NormalFoamMap, sampler_NormalFoamMap, uvB, gradX, gradY);

		return lerp(sampleA, sampleB, cur_height - this_index);
	}

	void Ext_SurfaceFunction3 (inout Surface o, inout ShaderData d)
	{
		d.blackboard.fluid.RGBA     = d.vertexColor;
		d.blackboard.fluid.Depth    = d.extraV2F0.w;
		d.blackboard.fluid.ESMV.xyz = d.extraV2F1.xyz;
		d.blackboard.fluid.F123.x   = d.extraV2F1.w;

		if (d.blackboard.fluid.Depth < 0.01f)
		{
			discard;
		}

		float2 uv          = d.worldSpacePosition.xz;
		float2 columnPixel = mul(_FlowMatrix, float4(d.worldSpacePosition, 1.0f)).xy;
		float2 columnCoord = CoordFromPixel(columnPixel, _FlowCountXZ);
		Column column      = GetColumn(columnCoord);

		float  time = _Time.y * _AnimationSpeed;
		float2 jump = float2(0.13f, 0.17f);
		float2 fvec = (column.Outflow.yw - column.Outflow.xz) * _FlowSeparationXZ * _FlowSpeed;
		float  fmag = log10(1.0f + length(fvec)) * 0.1f;

		float3 flowA = FlowUVW(uv, fvec / _AnimationSpeed, jump, _Tiling, time, 0.0f);
		float3 flowB = FlowUVW(uv, fvec / _AnimationSpeed, jump, _Tiling, time, 0.5f);

		#if _STOCHASTIC_ON
			float  noise = SAMPLE_TEXTURE2D(_NoiseMap, sampler_NoiseMap, uv * 0.0025f).a * 4.0f;
			float4 nfmA  = SampleStochastic(flowA, noise);
			float4 nfmB  = SampleStochastic(flowB, noise);
		#else
			float4 nfmA = SAMPLE_TEXTURE2D(_NormalFoamMap, sampler_NormalFoamMap, flowA.xy);
			float4 nfmB = SAMPLE_TEXTURE2D(_NormalFoamMap, sampler_NormalFoamMap, flowB.xy);
		#endif

		// Water normals
		float  normalStr    = lerp(_WaveStrengthMin, _WaveStrengthMax, saturate(_WaveStrengthScale * fmag));
		float3 waterNormalA = UnpackNormalAndScale(nfmA.xy, flowA.z * normalStr);
		float3 waterNormalB = UnpackNormalAndScale(nfmB.xy, flowB.z * normalStr);
		float3 waterNormals = CombineNormals(waterNormalA, waterNormalB);

		o.Normal = lerp(waterNormals, o.Normal, d.texcoord0.z);
		o.Albedo = d.blackboard.fluid.RGBA.xyz;

		#if _FOAM_OFF
			d.blackboard.foam = 0.0f;
		#else
			d.blackboard.foam = d.blackboard.fluid.F123.x * (1.0f - d.texcoord0.z);

			#if _FOAM_ALPHA
				float3 foamAlbedo = (nfmA.w * flowA.z + nfmB.w * flowB.z) * _FoamBrightness;
			#elif _FOAM_CUTOUT
				float3 foamAlbedo = _FoamBrightness;
				float  foamRamp   = nfmA.w * flowA.z + nfmB.w * flowB.z;
				d.blackboard.foam = saturate((d.blackboard.foam - foamRamp) * 10.0f);
			#endif

			float3 foamNormal = float3(0.0f, 0.0f, 1.0f);

			o.Albedo = lerp(o.Albedo, foamAlbedo, d.blackboard.foam);
			o.Normal = lerp(o.Normal, foamNormal, d.blackboard.foam);
		#endif

		o.Smoothness = d.blackboard.fluid.ESMV.y;
		o.Metallic   = d.blackboard.fluid.ESMV.z;
	}


	void Ext_SurfaceFunction4 (inout Surface o, inout ShaderData d)
	{
	#if _FACETED_ON
		// lets just affect the TBN data, so we flat shade the original polygons, not the normal map
		float3 dx = ddx(d.worldSpacePosition);
		float3 dy = ddy(d.worldSpacePosition);
		float3 worldNormal = normalize(cross(dy, dx));
		worldNormal = lerp(d.worldSpaceNormal, worldNormal, _FlatShadingBlend);
		d.worldSpaceNormal = worldNormal;
		d.TBNMatrix[2] = worldNormal;
	#endif
	}


	void Ext_SurfaceFunction5 (inout Surface o, ShaderData d)
	{
		#if _ALPHA_OFF
		#else
			float3 position  = d.worldSpacePosition;
			float3 step      = d.worldSpacePosition - _WorldSpaceCameraPos;
			float2 bentScrUV = d.screenUV + o.Normal.xy * 0.05f * log(1.0f + d.blackboard.fluid.Depth * 1.0f);
			float  distMax   = max(_RangeMax * 0.001f, _RangeMax * (1.0f - d.blackboard.fluid.RGBA.w));
			float  distRange = distMax;
			float  vertDist  = length(d.extraV2F0.xyz);
			float  camtDist  = GetLinearEyeDepth(bentScrUV) * length(d.extraV2F0.xyz / d.extraV2F0.z);

			if (camtDist < vertDist)
			{
				camtDist = GetLinearEyeDepth(d.screenUV) * length(d.extraV2F0.xyz / d.extraV2F0.z);
			}

			float diffDist = max(0.0f, camtDist - vertDist);

			// The depth buffer becomes unusable at certain ranges, so fade it out
			diffDist += max(0.0f, camtDist * _AlphaDepthScale - _RangeMax);
			distRange = min(distRange, diffDist);

			#if _ALPHA_VERTICAL
				float dist = d.blackboard.fluid.Depth;
			#elif _ALPHA_DEPTH
				float dist = diffDist;
			#elif _ALPHA_MARCH_FLUID
				float dist = RayMarchInside(position, normalize(step), _AlphaStep, _AlphaMaxSteps, distMax);
			#elif _ALPHA_MARCH_FLUID_AND_DEPTH
				float dist = RayMarchInside(position, normalize(step), _AlphaStep, _AlphaMaxSteps, distRange);
			#endif

			// Set opacity based on distance through fluid relative to the maximum distance, and make sure high opacity fluids become solid
			float opacity = saturate(dist / distMax + d.blackboard.foam + pow(d.blackboard.fluid.RGBA.w, 10.0f));

			o.Albedo    = lerp(0.0f, o.Albedo, opacity);
			o.Emission  = lerp(GetSceneColor(bentScrUV), o.Emission, opacity);
			o.Emission += o.Albedo * d.blackboard.fluid.ESMV.x * opacity;
		#endif
	}





        
            void ChainSurfaceFunction(inout Surface l, inout ShaderData d)
            {
                 // Ext_SurfaceFunction0(l, d);
                 // Ext_SurfaceFunction1(l, d);
                 // Ext_SurfaceFunction2(l, d);
                  Ext_SurfaceFunction3(l, d);
                  Ext_SurfaceFunction4(l, d);
                  Ext_SurfaceFunction5(l, d);
                 // Ext_SurfaceFunction6(l, d);
                 // Ext_SurfaceFunction7(l, d);
                 // Ext_SurfaceFunction8(l, d);
                 // Ext_SurfaceFunction9(l, d);
		           // Ext_SurfaceFunction10(l, d);
                 // Ext_SurfaceFunction11(l, d);
                 // Ext_SurfaceFunction12(l, d);
                 // Ext_SurfaceFunction13(l, d);
                 // Ext_SurfaceFunction14(l, d);
                 // Ext_SurfaceFunction15(l, d);
                 // Ext_SurfaceFunction16(l, d);
                 // Ext_SurfaceFunction17(l, d);
                 // Ext_SurfaceFunction18(l, d);
		           // Ext_SurfaceFunction19(l, d);
                 // Ext_SurfaceFunction20(l, d);
                 // Ext_SurfaceFunction21(l, d);
                 // Ext_SurfaceFunction22(l, d);
                 // Ext_SurfaceFunction23(l, d);
                 // Ext_SurfaceFunction24(l, d);
                 // Ext_SurfaceFunction25(l, d);
                 // Ext_SurfaceFunction26(l, d);
                 // Ext_SurfaceFunction27(l, d);
                 // Ext_SurfaceFunction28(l, d);
		           // Ext_SurfaceFunction29(l, d);
            }

            void ChainModifyVertex(inout VertexData v, inout VertexToPixel v2p, float4 time)
            {
                 ExtraV2F d;
                 
                 ZERO_INITIALIZE(ExtraV2F, d);
                 ZERO_INITIALIZE(Blackboard, d.blackboard);
                 // due to motion vectors in HDRP, we need to use the last
                 // time in certain spots. So if you are going to use _Time to adjust vertices,
                 // you need to use this time or motion vectors will break. 
                 d.time = time;

                   Ext_ModifyVertex0(v, d);
                 // Ext_ModifyVertex1(v, d);
                 // Ext_ModifyVertex2(v, d);
                  Ext_ModifyVertex3(v, d);
                 // Ext_ModifyVertex4(v, d);
                 // Ext_ModifyVertex5(v, d);
                 // Ext_ModifyVertex6(v, d);
                 // Ext_ModifyVertex7(v, d);
                 // Ext_ModifyVertex8(v, d);
                 // Ext_ModifyVertex9(v, d);
                 // Ext_ModifyVertex10(v, d);
                 // Ext_ModifyVertex11(v, d);
                 // Ext_ModifyVertex12(v, d);
                 // Ext_ModifyVertex13(v, d);
                 // Ext_ModifyVertex14(v, d);
                 // Ext_ModifyVertex15(v, d);
                 // Ext_ModifyVertex16(v, d);
                 // Ext_ModifyVertex17(v, d);
                 // Ext_ModifyVertex18(v, d);
                 // Ext_ModifyVertex19(v, d);
                 // Ext_ModifyVertex20(v, d);
                 // Ext_ModifyVertex21(v, d);
                 // Ext_ModifyVertex22(v, d);
                 // Ext_ModifyVertex23(v, d);
                 // Ext_ModifyVertex24(v, d);
                 // Ext_ModifyVertex25(v, d);
                 // Ext_ModifyVertex26(v, d);
                 // Ext_ModifyVertex27(v, d);
                 // Ext_ModifyVertex28(v, d);
                 // Ext_ModifyVertex29(v, d);


                 // #if %EXTRAV2F0REQUIREKEY%
                  v2p.extraV2F0 = d.extraV2F0;
                 // #endif

                 // #if %EXTRAV2F1REQUIREKEY%
                  v2p.extraV2F1 = d.extraV2F1;
                 // #endif

                 // #if %EXTRAV2F2REQUIREKEY%
                 // v2p.extraV2F2 = d.extraV2F2;
                 // #endif

                 // #if %EXTRAV2F3REQUIREKEY%
                 // v2p.extraV2F3 = d.extraV2F3;
                 // #endif

                 // #if %EXTRAV2F4REQUIREKEY%
                 // v2p.extraV2F4 = d.extraV2F4;
                 // #endif

                 // #if %EXTRAV2F5REQUIREKEY%
                 // v2p.extraV2F5 = d.extraV2F5;
                 // #endif

                 // #if %EXTRAV2F6REQUIREKEY%
                 // v2p.extraV2F6 = d.extraV2F6;
                 // #endif

                 // #if %EXTRAV2F7REQUIREKEY%
                 // v2p.extraV2F7 = d.extraV2F7;
                 // #endif
            }

            void ChainModifyTessellatedVertex(inout VertexData v, inout VertexToPixel v2p)
            {
               ExtraV2F d;
               ZERO_INITIALIZE(ExtraV2F, d);
               ZERO_INITIALIZE(Blackboard, d.blackboard);

               // #if %EXTRAV2F0REQUIREKEY%
                d.extraV2F0 = v2p.extraV2F0;
               // #endif

               // #if %EXTRAV2F1REQUIREKEY%
                d.extraV2F1 = v2p.extraV2F1;
               // #endif

               // #if %EXTRAV2F2REQUIREKEY%
               // d.extraV2F2 = v2p.extraV2F2;
               // #endif

               // #if %EXTRAV2F3REQUIREKEY%
               // d.extraV2F3 = v2p.extraV2F3;
               // #endif

               // #if %EXTRAV2F4REQUIREKEY%
               // d.extraV2F4 = v2p.extraV2F4;
               // #endif

               // #if %EXTRAV2F5REQUIREKEY%
               // d.extraV2F5 = v2p.extraV2F5;
               // #endif

               // #if %EXTRAV2F6REQUIREKEY%
               // d.extraV2F6 = v2p.extraV2F6;
               // #endif

               // #if %EXTRAV2F7REQUIREKEY%
               // d.extraV2F7 = v2p.extraV2F7;
               // #endif


               // Ext_ModifyTessellatedVertex0(v, d);
               // Ext_ModifyTessellatedVertex1(v, d);
               // Ext_ModifyTessellatedVertex2(v, d);
               // Ext_ModifyTessellatedVertex3(v, d);
               // Ext_ModifyTessellatedVertex4(v, d);
               // Ext_ModifyTessellatedVertex5(v, d);
               // Ext_ModifyTessellatedVertex6(v, d);
               // Ext_ModifyTessellatedVertex7(v, d);
               // Ext_ModifyTessellatedVertex8(v, d);
               // Ext_ModifyTessellatedVertex9(v, d);
               // Ext_ModifyTessellatedVertex10(v, d);
               // Ext_ModifyTessellatedVertex11(v, d);
               // Ext_ModifyTessellatedVertex12(v, d);
               // Ext_ModifyTessellatedVertex13(v, d);
               // Ext_ModifyTessellatedVertex14(v, d);
               // Ext_ModifyTessellatedVertex15(v, d);
               // Ext_ModifyTessellatedVertex16(v, d);
               // Ext_ModifyTessellatedVertex17(v, d);
               // Ext_ModifyTessellatedVertex18(v, d);
               // Ext_ModifyTessellatedVertex19(v, d);
               // Ext_ModifyTessellatedVertex20(v, d);
               // Ext_ModifyTessellatedVertex21(v, d);
               // Ext_ModifyTessellatedVertex22(v, d);
               // Ext_ModifyTessellatedVertex23(v, d);
               // Ext_ModifyTessellatedVertex24(v, d);
               // Ext_ModifyTessellatedVertex25(v, d);
               // Ext_ModifyTessellatedVertex26(v, d);
               // Ext_ModifyTessellatedVertex27(v, d);
               // Ext_ModifyTessellatedVertex28(v, d);
               // Ext_ModifyTessellatedVertex29(v, d);

               // #if %EXTRAV2F0REQUIREKEY%
                v2p.extraV2F0 = d.extraV2F0;
               // #endif

               // #if %EXTRAV2F1REQUIREKEY%
                v2p.extraV2F1 = d.extraV2F1;
               // #endif

               // #if %EXTRAV2F2REQUIREKEY%
               // v2p.extraV2F2 = d.extraV2F2;
               // #endif

               // #if %EXTRAV2F3REQUIREKEY%
               // v2p.extraV2F3 = d.extraV2F3;
               // #endif

               // #if %EXTRAV2F4REQUIREKEY%
               // v2p.extraV2F4 = d.extraV2F4;
               // #endif

               // #if %EXTRAV2F5REQUIREKEY%
               // v2p.extraV2F5 = d.extraV2F5;
               // #endif

               // #if %EXTRAV2F6REQUIREKEY%
               // v2p.extraV2F6 = d.extraV2F6;
               // #endif

               // #if %EXTRAV2F7REQUIREKEY%
               // v2p.extraV2F7 = d.extraV2F7;
               // #endif
            }

            void ChainFinalColorForward(inout Surface l, inout ShaderData d, inout half4 color)
            {
               //   Ext_FinalColorForward0(l, d, color);
               //   Ext_FinalColorForward1(l, d, color);
               //   Ext_FinalColorForward2(l, d, color);
               //   Ext_FinalColorForward3(l, d, color);
               //   Ext_FinalColorForward4(l, d, color);
               //   Ext_FinalColorForward5(l, d, color);
               //   Ext_FinalColorForward6(l, d, color);
               //   Ext_FinalColorForward7(l, d, color);
               //   Ext_FinalColorForward8(l, d, color);
               //   Ext_FinalColorForward9(l, d, color);
               //  Ext_FinalColorForward10(l, d, color);
               //  Ext_FinalColorForward11(l, d, color);
               //  Ext_FinalColorForward12(l, d, color);
               //  Ext_FinalColorForward13(l, d, color);
               //  Ext_FinalColorForward14(l, d, color);
               //  Ext_FinalColorForward15(l, d, color);
               //  Ext_FinalColorForward16(l, d, color);
               //  Ext_FinalColorForward17(l, d, color);
               //  Ext_FinalColorForward18(l, d, color);
               //  Ext_FinalColorForward19(l, d, color);
               //  Ext_FinalColorForward20(l, d, color);
               //  Ext_FinalColorForward21(l, d, color);
               //  Ext_FinalColorForward22(l, d, color);
               //  Ext_FinalColorForward23(l, d, color);
               //  Ext_FinalColorForward24(l, d, color);
               //  Ext_FinalColorForward25(l, d, color);
               //  Ext_FinalColorForward26(l, d, color);
               //  Ext_FinalColorForward27(l, d, color);
               //  Ext_FinalColorForward28(l, d, color);
               //  Ext_FinalColorForward29(l, d, color);
            }

            void ChainFinalGBufferStandard(inout Surface s, inout ShaderData d, inout half4 GBuffer0, inout half4 GBuffer1, inout half4 GBuffer2, inout half4 outEmission, inout half4 outShadowMask)
            {
               //   Ext_FinalGBufferStandard0(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //   Ext_FinalGBufferStandard1(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //   Ext_FinalGBufferStandard2(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //   Ext_FinalGBufferStandard3(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //   Ext_FinalGBufferStandard4(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //   Ext_FinalGBufferStandard5(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //   Ext_FinalGBufferStandard6(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //   Ext_FinalGBufferStandard7(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //   Ext_FinalGBufferStandard8(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //   Ext_FinalGBufferStandard9(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard10(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard11(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard12(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard13(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard14(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard15(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard16(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard17(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard18(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard19(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard20(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard21(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard22(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard23(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard24(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard25(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard26(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard27(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard28(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard29(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
            }


         
         

         ShaderData CreateShaderData(VertexToPixel i
                  #if NEED_FACING
                     , bool facing
                  #endif
         )
         {
            ShaderData d = (ShaderData)0;
            d.clipPos = i.pos;
            d.worldSpacePosition = i.worldPos;

            d.worldSpaceNormal = normalize(i.worldNormal);
            d.worldSpaceTangent = normalize(i.worldTangent.xyz);
            d.tangentSign = i.worldTangent.w;
            float3 bitangent = cross(i.worldTangent.xyz, i.worldNormal) * d.tangentSign * -1;
            

            d.TBNMatrix = float3x3(d.worldSpaceTangent, bitangent, d.worldSpaceNormal);
            d.worldSpaceViewDir = normalize(_WorldSpaceCameraPos - i.worldPos);

            d.tangentSpaceViewDir = mul(d.TBNMatrix, d.worldSpaceViewDir);
             d.texcoord0 = i.texcoord0;
            // d.texcoord1 = i.texcoord1;
            // d.texcoord2 = i.texcoord2;

            // #if %TEXCOORD3REQUIREKEY%
            // d.texcoord3 = i.texcoord3;
            // #endif

            // d.isFrontFace = facing;
            // #if %VERTEXCOLORREQUIREKEY%
             d.vertexColor = i.vertexColor;
            // #endif

            // these rarely get used, so we back transform them. Usually will be stripped.
            #if _HDRP
                // d.localSpacePosition = mul(unity_WorldToObject, float4(GetCameraRelativePositionWS(i.worldPos), 1)).xyz;
            #else
                // d.localSpacePosition = mul(unity_WorldToObject, float4(i.worldPos, 1)).xyz;
            #endif
            // d.localSpaceNormal = normalize(mul((float3x3)unity_WorldToObject, i.worldNormal));
            // d.localSpaceTangent = normalize(mul((float3x3)unity_WorldToObject, i.worldTangent.xyz));

            // #if %SCREENPOSREQUIREKEY%
             d.screenPos = i.screenPos;
             d.screenUV = (i.screenPos.xy / i.screenPos.w);
            // #endif


            // #if %EXTRAV2F0REQUIREKEY%
             d.extraV2F0 = i.extraV2F0;
            // #endif

            // #if %EXTRAV2F1REQUIREKEY%
             d.extraV2F1 = i.extraV2F1;
            // #endif

            // #if %EXTRAV2F2REQUIREKEY%
            // d.extraV2F2 = i.extraV2F2;
            // #endif

            // #if %EXTRAV2F3REQUIREKEY%
            // d.extraV2F3 = i.extraV2F3;
            // #endif

            // #if %EXTRAV2F4REQUIREKEY%
            // d.extraV2F4 = i.extraV2F4;
            // #endif

            // #if %EXTRAV2F5REQUIREKEY%
            // d.extraV2F5 = i.extraV2F5;
            // #endif

            // #if %EXTRAV2F6REQUIREKEY%
            // d.extraV2F6 = i.extraV2F6;
            // #endif

            // #if %EXTRAV2F7REQUIREKEY%
            // d.extraV2F7 = i.extraV2F7;
            // #endif

            return d;
         }
         

         // vertex shader
         VertexToPixel Vert (VertexData v)
         {
           UNITY_SETUP_INSTANCE_ID(v);
           VertexToPixel o;
           UNITY_INITIALIZE_OUTPUT(VertexToPixel,o);
           UNITY_TRANSFER_INSTANCE_ID(v,o);
           UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

#if !_TESSELLATION_ON
           ChainModifyVertex(v, o, _Time);
#endif

           o.pos = UnityObjectToClipPos(v.vertex);
            o.texcoord0 = v.texcoord0;
           // o.texcoord1 = v.texcoord1;
           // o.texcoord2 = v.texcoord2;

           // #if %TEXCOORD3REQUIREKEY%
           // o.texcoord3 = v.texcoord3;
           // #endif

           // #if %VERTEXCOLORREQUIREKEY%
            o.vertexColor = v.vertexColor;
           // #endif

           // #if %SCREENPOSREQUIREKEY%
            o.screenPos = ComputeScreenPos(o.pos);
           // #endif

           o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
           o.worldNormal = UnityObjectToWorldNormal(v.normal);
           o.worldTangent.xyz = UnityObjectToWorldDir(v.tangent.xyz);
           fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
           o.worldTangent.w = tangentSign;

           UNITY_TRANSFER_LIGHTING(o, v.texcoord1.xy); // pass shadow and, possibly, light cookie coordinates to pixel shader
           UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader

           return o;
         }

         

         // fragment shader
         fixed4 Frag (VertexToPixel IN
         #ifdef _DEPTHOFFSET_ON
              , out float outputDepth : SV_Depth
         #endif
         #if NEED_FACING
            , bool facing : SV_IsFrontFace
         #endif
         ) : SV_Target
         {
           UNITY_SETUP_INSTANCE_ID(IN);
           // prepare and unpack data

           #ifdef FOG_COMBINED_WITH_TSPACE
             UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
           #elif defined (FOG_COMBINED_WITH_WORLD_POS)
             UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
           #else
             UNITY_EXTRACT_FOG(IN);
           #endif



           ShaderData d = CreateShaderData(IN
              #if NEED_FACING
                 , facing
              #endif
           );
           Surface l = (Surface)0;


           #ifdef _DEPTHOFFSET_ON
              l.outputDepth = outputDepth;
           #endif

           l.Albedo = half3(0.5, 0.5, 0.5);
           l.Normal = float3(0,0,1);
           l.Occlusion = 1;
           l.Alpha = 1;

           ChainSurfaceFunction(l, d);

           #ifdef _DEPTHOFFSET_ON
              outputDepth = l.outputDepth;
           #endif


           #ifndef USING_DIRECTIONAL_LIGHT
             fixed3 lightDir = normalize(UnityWorldSpaceLightDir(d.worldSpacePosition));
           #else
             fixed3 lightDir = _WorldSpaceLightPos0.xyz;
           #endif
           float3 worldViewDir = normalize(UnityWorldSpaceViewDir(d.worldSpacePosition));

           #if _USESPECULAR || _USESPECULARWORKFLOW || _SPECULARFROMMETALLIC
              #ifdef UNITY_COMPILER_HLSL
                 SurfaceOutputStandardSpecular o = (SurfaceOutputStandardSpecular)0;
              #else
                 SurfaceOutputStandardSpecular o;
              #endif
              o.Specular = l.Specular;
              o.Occlusion = l.Occlusion;
              o.Smoothness = l.Smoothness;
           #elif _BDRFLAMBERT || _BDRF3 || _SIMPLELIT
              #ifdef UNITY_COMPILER_HLSL
                 SurfaceOutput o = (SurfaceOutput)0;
              #else
                 SurfaceOutput o;
              #endif

              o.Specular = l.SpecularPower;
              o.Gloss = l.Smoothness;
              _SpecColor.rgb = l.Specular; // fucking hell Unity, wtf..
           #else
              #ifdef UNITY_COMPILER_HLSL
                 SurfaceOutputStandard o = (SurfaceOutputStandard)0;
              #else
                 SurfaceOutputStandard o;
              #endif
              o.Smoothness = l.Smoothness;
              o.Metallic = l.Metallic;
              o.Occlusion = l.Occlusion;
           #endif

   
           o.Albedo = l.Albedo;
           o.Emission = l.Emission;
           o.Alpha = l.Alpha;

           #if _WORLDSPACENORMAL
              o.Normal = l.Normal;
           #else
              o.Normal = normalize(TangentToWorldSpace(d, l.Normal));
           #endif



           UNITY_LIGHT_ATTENUATION(atten, IN, d.worldSpacePosition)
           half4 c = 0;

           // Setup lighting environment
           UnityGI gi;
           UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
           gi.indirect.diffuse = 0;
           gi.indirect.specular = 0;
           gi.light.color = _LightColor0.rgb;
           gi.light.dir = lightDir;
           gi.light.color *= atten;

           #if defined(_OVERRIDE_SHADOWMASK)
               float4 mulColor = saturate(dot(l.ShadowMask, unity_OcclusionMaskSelector));
               gi.light.color = mulColor;
            #endif

           #if _USESPECULAR
              c += LightingStandardSpecular (o, worldViewDir, gi);
           #elif _BDRF3 || _SIMPLELIT
              c += LightingBlinnPhong (o, d.worldSpaceViewDir, gi);
           #else
              c += LightingStandard (o, worldViewDir, gi);
           #endif
           

           ChainFinalColorForward(l, d, c);

           #if !DISABLEFOG
            UNITY_APPLY_FOG(_unity_fogCoord, c); // apply fog
           #endif
           #if !_ALPHABLEND_ON
              UNITY_OPAQUE_ALPHA(c.a);
           #endif
           
           return c;
         }

         ENDCG

      }

      
      
	   // ---- meta information extraction pass:
	   Pass
      {
		   Name "Meta"
		   Tags { "LightMode" = "Meta" }
		   Cull Off

         	ZWrite On


         CGPROGRAM

            #pragma vertex Vert
   #pragma fragment Frag

         // compile directives
         #pragma target 3.0
         #pragma multi_compile_instancing
         #pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
         #pragma shader_feature EDITOR_VISUALIZATION

         #include "HLSLSupport.cginc"
         #define UNITY_INSTANCED_LOD_FADE
         #define UNITY_INSTANCED_SH
         #define UNITY_INSTANCED_LIGHTMAPSTS
         #include "UnityShaderVariables.cginc"
         #include "UnityShaderUtilities.cginc"

         #include "UnityCG.cginc"
         #include "Lighting.cginc"
         #include "UnityPBSLighting.cginc"
         #include "UnityMetaPass.cginc"

         #define _PASSMETA 1

         
	#include "Flow.cginc"


	#pragma shader_feature_local _ _STOCHASTIC_ON
	#pragma shader_feature_local _FOAM_OFF _FOAM_ALPHA _FOAM_CUTOUT


	#pragma shader_feature_local _ _FACETED_ON


	#pragma shader_feature_local _ALPHA_OFF _ALPHA_VERTICAL _ALPHA_DEPTH _ALPHA_MARCH_FLUID _ALPHA_MARCH_FLUID_AND_DEPTH


    #pragma shader_feature_local DISABLEFOG    


   #define _STANDARD 1

   #define _ALPHABLEND_ON 1
// If your looking in here and thinking WTF, yeah, I know. These are taken from the SRPs, to allow us to use the same
// texturing library they use. However, since they are not included in the standard pipeline by default, there is no
// way to include them in and they have to be inlined, since someone could copy this shader onto another machine without
// Better Shaders installed. Unfortunate, but I'd rather do this and have a nice library for texture sampling instead
// of the patchy one Unity provides being inlined/emulated in HDRP/URP. Strangely, PSSL and XBoxOne libraries are not
// included in the standard SRP code, but they are in tons of Unity own projects on the web, so I grabbed them from there.

#if defined(SHADER_API_GAMECORE)

	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }

	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) textureName.CalculateLevelOfDetail(samplerName, coord2)

	// Texture abstraction

	#define TEXTURE2D(textureName)                Texture2D textureName
	#define TEXTURE2D_ARRAY(textureName)          Texture2DArray textureName
	#define TEXTURECUBE(textureName)              TextureCube textureName
	#define TEXTURECUBE_ARRAY(textureName)        TextureCubeArray textureName
	#define TEXTURE3D(textureName)                Texture3D textureName

	#define TEXTURE2D_FLOAT(textureName)          TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_FLOAT(textureName)    TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_FLOAT(textureName)        TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)  TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_FLOAT(textureName)          TEXTURE3D(textureName)

	#define TEXTURE2D_HALF(textureName)           TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_HALF(textureName)     TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_HALF(textureName)         TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_HALF(textureName)   TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_HALF(textureName)           TEXTURE3D(textureName)

	#define TEXTURE2D_SHADOW(textureName)         TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_SHADOW(textureName)   TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_SHADOW(textureName)       TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_SHADOW(textureName) TEXTURECUBE_ARRAY(textureName)

	#define RW_TEXTURE2D(type, textureName)       RWTexture2D<type> textureName
	#define RW_TEXTURE2D_ARRAY(type, textureName) RWTexture2DArray<type> textureName
	#define RW_TEXTURE3D(type, textureName)       RWTexture3D<type> textureName

	#define SAMPLER(samplerName)                  SamplerState samplerName
	#define SAMPLER_CMP(samplerName)              SamplerComparisonState samplerName
	#define ASSIGN_SAMPLER(samplerName, samplerValue) samplerName = samplerValue

	#define TEXTURE2D_PARAM(textureName, samplerName)                 TEXTURE2D(textureName),         SAMPLER(samplerName)
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)           TEXTURE2D_ARRAY(textureName),   SAMPLER(samplerName)
	#define TEXTURECUBE_PARAM(textureName, samplerName)               TEXTURECUBE(textureName),       SAMPLER(samplerName)
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)         TEXTURECUBE_ARRAY(textureName), SAMPLER(samplerName)
	#define TEXTURE3D_PARAM(textureName, samplerName)                 TEXTURE3D(textureName),         SAMPLER(samplerName)

	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)          TEXTURE2D(textureName),         SAMPLER_CMP(samplerName)
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)    TEXTURE2D_ARRAY(textureName),   SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)        TEXTURECUBE(textureName),       SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_ARRAY_SHADOW_PARAM(textureName, samplerName)  TEXTURECUBE_ARRAY(textureName), SAMPLER_CMP(samplerName)

	#define TEXTURE2D_ARGS(textureName, samplerName)                textureName, samplerName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)          textureName, samplerName
	#define TEXTURECUBE_ARGS(textureName, samplerName)              textureName, samplerName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)        textureName, samplerName
	#define TEXTURE3D_ARGS(textureName, samplerName)                textureName, samplerName

	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)         textureName, samplerName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)   textureName, samplerName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)       textureName, samplerName
	#define TEXTURECUBE_ARRAY_SHADOW_ARGS(textureName, samplerName) textureName, samplerName

	#define PLATFORM_SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               textureName.Sample(samplerName, coord2)
	#define PLATFORM_SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      textureName.SampleLevel(samplerName, coord2, lod)
	#define PLATFORM_SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    textureName.SampleBias(samplerName, coord2, bias)
	#define PLATFORM_SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)              textureName.SampleGrad(samplerName, coord2, dpdx, dpdy)
	#define PLATFORM_SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  textureName.Sample(samplerName, float3(coord2, index))
	#define PLATFORM_SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         textureName.SampleLevel(samplerName, float3(coord2, index), lod)
	#define PLATFORM_SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       textureName.SampleBias(samplerName, float3(coord2, index), bias)
	#define PLATFORM_SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) textureName.SampleGrad(samplerName, float3(coord2, index), dpdx, dpdy)
	#define PLATFORM_SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             textureName.Sample(samplerName, coord3)
	#define PLATFORM_SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    textureName.SampleLevel(samplerName, coord3, lod)
	#define PLATFORM_SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  textureName.SampleBias(samplerName, coord3, bias)
	#define PLATFORM_SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)                textureName.Sample(samplerName, float4(coord3, index))
	#define PLATFORM_SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)       textureName.SampleLevel(samplerName, float4(coord3, index), lod)
	#define PLATFORM_SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)     textureName.SampleBias(samplerName, float4(coord3, index), bias)
	#define PLATFORM_SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                               textureName.Sample(samplerName, coord3)
	#define PLATFORM_SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                      textureName.SampleLevel(samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               PLATFORM_SAMPLE_TEXTURE2D(textureName, samplerName, coord2)
	#define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      PLATFORM_SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)
	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    PLATFORM_SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)              PLATFORM_SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  PLATFORM_SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         PLATFORM_SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       PLATFORM_SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) PLATFORM_SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             PLATFORM_SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    PLATFORM_SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  PLATFORM_SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)                PLATFORM_SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)       PLATFORM_SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)     PLATFORM_SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)
	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                               PLATFORM_SAMPLE_TEXTURE3D(textureName, samplerName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                      PLATFORM_SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                    textureName.SampleCmpLevelZero(samplerName, (coord3).xy, (coord3).z)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)       textureName.SampleCmpLevelZero(samplerName, float3((coord3).xy, index), (coord3).z)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                  textureName.SampleCmpLevelZero(samplerName, (coord4).xyz, (coord4).w)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)     textureName.SampleCmpLevelZero(samplerName, float4((coord4).xyz, index), (coord4).w)

	#define SAMPLE_DEPTH_TEXTURE(textureName, samplerName, coord2)          SAMPLE_TEXTURE2D(textureName, samplerName, coord2).r
	#define SAMPLE_DEPTH_TEXTURE_LOD(textureName, samplerName, coord2, lod) SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod).r

	#define LOAD_TEXTURE2D(textureName, unCoord2)                                   textureName.Load(int3(unCoord2, 0))
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)                          textureName.Load(int3(unCoord2, lod))
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)                 textureName.Load(unCoord2, sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)                      textureName.Load(int4(unCoord2, index, 0))
	#define LOAD_TEXTURE2D_ARRAY_MSAA(textureName, unCoord2, index, sampleIndex)    textureName.Load(int3(unCoord2, index), sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod)             textureName.Load(int4(unCoord2, index, lod))
	#define LOAD_TEXTURE3D(textureName, unCoord3)                                   textureName.Load(int4(unCoord3, 0))
	#define LOAD_TEXTURE3D_LOD(textureName, unCoord3, lod)                          textureName.Load(int4(unCoord3, lod))

	#define PLATFORM_SUPPORT_GATHER
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                textureName.Gather(samplerName, coord2)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)   textureName.Gather(samplerName, float3(coord2, index))
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)              textureName.Gather(samplerName, coord3)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index) textureName.Gather(samplerName, float4(coord3, index))
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)            textureName.GatherRed(samplerName, coord2)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherGreen(samplerName, coord2)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)           textureName.GatherBlue(samplerName, coord2)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherAlpha(samplerName, coord2)


#elif defined(SHADER_API_XBOXONE)
	
	// Initialize arbitrary structure with zero values.
	// Do not exist on some platform, in this case we need to have a standard name that call a function that will initialize all parameters to 0
	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }

	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) textureName.CalculateLevelOfDetail(samplerName, coord2)

	// Texture abstraction

	#define TEXTURE2D(textureName)                Texture2D textureName
	#define TEXTURE2D_ARRAY(textureName)          Texture2DArray textureName
	#define TEXTURECUBE(textureName)              TextureCube textureName
	#define TEXTURECUBE_ARRAY(textureName)        TextureCubeArray textureName
	#define TEXTURE3D(textureName)                Texture3D textureName

	#define TEXTURE2D_FLOAT(textureName)          TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_FLOAT(textureName)    TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_FLOAT(textureName)        TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)  TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_FLOAT(textureName)          TEXTURE3D(textureName)

	#define TEXTURE2D_HALF(textureName)           TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_HALF(textureName)     TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_HALF(textureName)         TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_HALF(textureName)   TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_HALF(textureName)           TEXTURE3D(textureName)

	#define TEXTURE2D_SHADOW(textureName)         TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_SHADOW(textureName)   TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_SHADOW(textureName)       TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_SHADOW(textureName) TEXTURECUBE_ARRAY(textureName)

	#define RW_TEXTURE2D(type, textureName)       RWTexture2D<type> textureName
	#define RW_TEXTURE2D_ARRAY(type, textureName) RWTexture2DArray<type> textureName
	#define RW_TEXTURE3D(type, textureName)       RWTexture3D<type> textureName

	#define SAMPLER(samplerName)                  SamplerState samplerName
	#define SAMPLER_CMP(samplerName)              SamplerComparisonState samplerName

	#define TEXTURE2D_PARAM(textureName, samplerName)                 TEXTURE2D(textureName),         SAMPLER(samplerName)
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)           TEXTURE2D_ARRAY(textureName),   SAMPLER(samplerName)
	#define TEXTURECUBE_PARAM(textureName, samplerName)               TEXTURECUBE(textureName),       SAMPLER(samplerName)
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)         TEXTURECUBE_ARRAY(textureName), SAMPLER(samplerName)
	#define TEXTURE3D_PARAM(textureName, samplerName)                 TEXTURE3D(textureName),         SAMPLER(samplerName)

	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)          TEXTURE2D(textureName),         SAMPLER_CMP(samplerName)
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)    TEXTURE2D_ARRAY(textureName),   SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)        TEXTURECUBE(textureName),       SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_ARRAY_SHADOW_PARAM(textureName, samplerName)  TEXTURECUBE_ARRAY(textureName), SAMPLER_CMP(samplerName)

	#define TEXTURE2D_ARGS(textureName, samplerName)                textureName, samplerName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)          textureName, samplerName
	#define TEXTURECUBE_ARGS(textureName, samplerName)              textureName, samplerName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)        textureName, samplerName
	#define TEXTURE3D_ARGS(textureName, samplerName)                textureName, samplerName

	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)         textureName, samplerName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)   textureName, samplerName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)       textureName, samplerName
	#define TEXTURECUBE_ARRAY_SHADOW_ARGS(textureName, samplerName) textureName, samplerName

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               textureName.Sample(samplerName, coord2)
	#define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      textureName.SampleLevel(samplerName, coord2, lod)
	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    textureName.SampleBias(samplerName, coord2, bias)
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)              textureName.SampleGrad(samplerName, coord2, dpdx, dpdy)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  textureName.Sample(samplerName, float3(coord2, index))
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         textureName.SampleLevel(samplerName, float3(coord2, index), lod)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       textureName.SampleBias(samplerName, float3(coord2, index), bias)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) textureName.SampleGrad(samplerName, float3(coord2, index), dpdx, dpdy)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    textureName.SampleLevel(samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  textureName.SampleBias(samplerName, coord3, bias)
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)                textureName.Sample(samplerName, float4(coord3, index))
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)       textureName.SampleLevel(samplerName, float4(coord3, index), lod)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)     textureName.SampleBias(samplerName, float4(coord3, index), bias)
	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                               textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                      textureName.SampleLevel(samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                    textureName.SampleCmpLevelZero(samplerName, (coord3).xy, (coord3).z)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)       textureName.SampleCmpLevelZero(samplerName, float3((coord3).xy, index), (coord3).z)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                  textureName.SampleCmpLevelZero(samplerName, (coord4).xyz, (coord4).w)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)     textureName.SampleCmpLevelZero(samplerName, float4((coord4).xyz, index), (coord4).w)

	#define LOAD_TEXTURE2D(textureName, unCoord2)                                   textureName.Load(int3(unCoord2, 0))
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)                          textureName.Load(int3(unCoord2, lod))
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)                 textureName.Load(unCoord2, sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)                      textureName.Load(int4(unCoord2, index, 0))
	#define LOAD_TEXTURE2D_ARRAY_MSAA(textureName, unCoord2, index, sampleIndex)    textureName.Load(int3(unCoord2, index), sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod)             textureName.Load(int4(unCoord2, index, lod))
	#define LOAD_TEXTURE3D(textureName, unCoord3)                                   textureName.Load(int4(unCoord3, 0))
	#define LOAD_TEXTURE3D_LOD(textureName, unCoord3, lod)                          textureName.Load(int4(unCoord3, lod))

	#define PLATFORM_SUPPORT_GATHER
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                textureName.Gather(samplerName, coord2)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)   textureName.Gather(samplerName, float3(coord2, index))
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)              textureName.Gather(samplerName, coord3)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index) textureName.Gather(samplerName, float4(coord3, index))
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)            textureName.GatherRed(samplerName, coord2)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherGreen(samplerName, coord2)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)           textureName.GatherBlue(samplerName, coord2)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherAlpha(samplerName, coord2)


#elif defined(SHADER_API_PSSL)

	// Initialize arbitrary structure with zero values.
	// Do not exist on some platform, in this case we need to have a standard name that call a function that will initialize all parameters to 0
	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }

	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) textureName.GetLOD(samplerName, coord2)

	// Texture abstraction

	#define TEXTURE2D(textureName)                Texture2D textureName
	#define TEXTURE2D_ARRAY(textureName)          Texture2DArray textureName
	#define TEXTURECUBE(textureName)              TextureCube textureName
	#define TEXTURECUBE_ARRAY(textureName)        TextureCubeArray textureName
	#define TEXTURE3D(textureName)                Texture3D textureName

	#define TEXTURE2D_FLOAT(textureName)          TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_FLOAT(textureName)    TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_FLOAT(textureName)        TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)  TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_FLOAT(textureName)          TEXTURE3D(textureName)

	#define TEXTURE2D_HALF(textureName)           TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_HALF(textureName)     TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_HALF(textureName)         TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_HALF(textureName)   TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_HALF(textureName)           TEXTURE3D(textureName)

	#define TEXTURE2D_SHADOW(textureName)         TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_SHADOW(textureName)   TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_SHADOW(textureName)       TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_SHADOW(textureName) TEXTURECUBE_ARRAY(textureName)

	#define RW_TEXTURE2D(type, textureName)       RW_Texture2D<type> textureName
	#define RW_TEXTURE2D_ARRAY(type, textureName) RW_Texture2D_Array<type> textureName
	#define RW_TEXTURE3D(type, textureName)       RW_Texture3D<type> textureName

	#define SAMPLER(samplerName)                  SamplerState samplerName
	#define SAMPLER_CMP(samplerName)              SamplerComparisonState samplerName

	#define TEXTURE2D_PARAM(textureName, samplerName)                 TEXTURE2D(textureName),         SAMPLER(samplerName)
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)           TEXTURE2D_ARRAY(textureName),   SAMPLER(samplerName)
	#define TEXTURECUBE_PARAM(textureName, samplerName)               TEXTURECUBE(textureName),       SAMPLER(samplerName)
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)         TEXTURECUBE_ARRAY(textureName), SAMPLER(samplerName)
	#define TEXTURE3D_PARAM(textureName, samplerName)                 TEXTURE3D(textureName),         SAMPLER(samplerName)

	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)          TEXTURE2D(textureName),         SAMPLER_CMP(samplerName)
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)    TEXTURE2D_ARRAY(textureName),   SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)        TEXTURECUBE(textureName),       SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_ARRAY_SHADOW_PARAM(textureName, samplerName)  TEXTURECUBE_ARRAY(textureName), SAMPLER_CMP(samplerName)

	#define TEXTURE2D_ARGS(textureName, samplerName)                textureName, samplerName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)          textureName, samplerName
	#define TEXTURECUBE_ARGS(textureName, samplerName)              textureName, samplerName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)        textureName, samplerName
	#define TEXTURE3D_ARGS(textureName, samplerName)                textureName, samplerName

	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)         textureName, samplerName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)   textureName, samplerName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)       textureName, samplerName
	#define TEXTURECUBE_ARRAY_SHADOW_ARGS(textureName, samplerName) textureName, samplerName

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               textureName.Sample(samplerName, coord2)
	#define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      textureName.SampleLevel(samplerName, coord2, lod)
	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    textureName.SampleBias(samplerName, coord2, bias)
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)              textureName.SampleGrad(samplerName, coord2, dpdx, dpdy)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  textureName.Sample(samplerName, float3(coord2, index))
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         textureName.SampleLevel(samplerName, float3(coord2, index), lod)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       textureName.SampleBias(samplerName, float3(coord2, index), bias)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) textureName.SampleGrad(samplerName, float3(coord2, index), dpdx, dpdy)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    textureName.SampleLevel(samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  textureName.SampleBias(samplerName, coord3, bias)
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)                textureName.Sample(samplerName, float4(coord3, index))
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)       textureName.SampleLevel(samplerName, float4(coord3, index), lod)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)     textureName.SampleBias(samplerName, float4(coord3, index), bias)
	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                               textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                      textureName.SampleLevel(samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                    textureName.SampleCmpLevelZero(samplerName, (coord3).xy, (coord3).z)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)       textureName.SampleCmpLevelZero(samplerName, float3((coord3).xy, index), (coord3).z)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                  textureName.SampleCmpLevelZero(samplerName, (coord4).xyz, (coord4).w)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)     textureName.SampleCmpLevelZero(samplerName, float4((coord4).xyz, index), (coord4).w)

	#define LOAD_TEXTURE2D(textureName, unCoord2)                                   textureName.Load(int3(unCoord2, 0))
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)                          textureName.Load(int3(unCoord2, lod))
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)                 textureName.Load(unCoord2, sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)                      textureName.Load(int4(unCoord2, index, 0))
	#define LOAD_TEXTURE2D_ARRAY_MSAA(textureName, unCoord2, index, sampleIndex)    textureName.Load(int3(unCoord2, index), sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod)             textureName.Load(int4(unCoord2, index, lod))
	#define LOAD_TEXTURE3D(textureName, unCoord3)                                   textureName.Load(int4(unCoord3, 0))
	#define LOAD_TEXTURE3D_LOD(textureName, unCoord3, lod)                          textureName.Load(int4(unCoord3, lod))

	#define PLATFORM_SUPPORT_GATHER
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                textureName.Gather(samplerName, coord2)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)   textureName.Gather(samplerName, float3(coord2, index))
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)              textureName.Gather(samplerName, coord3)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index) textureName.Gather(samplerName, float4(coord3, index))
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)            textureName.GatherRed(samplerName, coord2)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherGreen(samplerName, coord2)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)           textureName.GatherBlue(samplerName, coord2)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherAlpha(samplerName, coord2)



#elif defined(SHADER_API_D3D11)

	// Initialize arbitrary structure with zero values.
	// Do not exist on some platform, in this case we need to have a standard name that call a function that will initialize all parameters to 0
	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }

	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) textureName.CalculateLevelOfDetail(samplerName, coord2)

	// Texture abstraction

	#define TEXTURE2D(textureName)                Texture2D textureName
	#define TEXTURE2D_ARRAY(textureName)          Texture2DArray textureName
	#define TEXTURECUBE(textureName)              TextureCube textureName
	#define TEXTURECUBE_ARRAY(textureName)        TextureCubeArray textureName
	#define TEXTURE3D(textureName)                Texture3D textureName

	#define TEXTURE2D_FLOAT(textureName)          TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_FLOAT(textureName)    TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_FLOAT(textureName)        TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)  TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_FLOAT(textureName)          TEXTURE3D(textureName)

	#define TEXTURE2D_HALF(textureName)           TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_HALF(textureName)     TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_HALF(textureName)         TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_HALF(textureName)   TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_HALF(textureName)           TEXTURE3D(textureName)

	#define TEXTURE2D_SHADOW(textureName)         TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_SHADOW(textureName)   TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_SHADOW(textureName)       TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_SHADOW(textureName) TEXTURECUBE_ARRAY(textureName)

	#define RW_TEXTURE2D(type, textureName)       RWTexture2D<type> textureName
	#define RW_TEXTURE2D_ARRAY(type, textureName) RWTexture2DArray<type> textureName
	#define RW_TEXTURE3D(type, textureName)       RWTexture3D<type> textureName

	#define SAMPLER(samplerName)                  SamplerState samplerName
	#define SAMPLER_CMP(samplerName)              SamplerComparisonState samplerName

	#define TEXTURE2D_PARAM(textureName, samplerName)                 TEXTURE2D(textureName),         SAMPLER(samplerName)
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)           TEXTURE2D_ARRAY(textureName),   SAMPLER(samplerName)
	#define TEXTURECUBE_PARAM(textureName, samplerName)               TEXTURECUBE(textureName),       SAMPLER(samplerName)
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)         TEXTURECUBE_ARRAY(textureName), SAMPLER(samplerName)
	#define TEXTURE3D_PARAM(textureName, samplerName)                 TEXTURE3D(textureName),         SAMPLER(samplerName)

	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)          TEXTURE2D(textureName),         SAMPLER_CMP(samplerName)
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)    TEXTURE2D_ARRAY(textureName),   SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)        TEXTURECUBE(textureName),       SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_ARRAY_SHADOW_PARAM(textureName, samplerName)  TEXTURECUBE_ARRAY(textureName), SAMPLER_CMP(samplerName)

	#define TEXTURE2D_ARGS(textureName, samplerName)                textureName, samplerName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)          textureName, samplerName
	#define TEXTURECUBE_ARGS(textureName, samplerName)              textureName, samplerName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)        textureName, samplerName
	#define TEXTURE3D_ARGS(textureName, samplerName)                textureName, samplerName

	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)         textureName, samplerName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)   textureName, samplerName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)       textureName, samplerName
	#define TEXTURECUBE_ARRAY_SHADOW_ARGS(textureName, samplerName) textureName, samplerName

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               textureName.Sample(samplerName, coord2)
	#define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      textureName.SampleLevel(samplerName, coord2, lod)
	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    textureName.SampleBias(samplerName, coord2, bias)
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)              textureName.SampleGrad(samplerName, coord2, dpdx, dpdy)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  textureName.Sample(samplerName, float3(coord2, index))
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         textureName.SampleLevel(samplerName, float3(coord2, index), lod)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       textureName.SampleBias(samplerName, float3(coord2, index), bias)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) textureName.SampleGrad(samplerName, float3(coord2, index), dpdx, dpdy)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    textureName.SampleLevel(samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  textureName.SampleBias(samplerName, coord3, bias)
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)                textureName.Sample(samplerName, float4(coord3, index))
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)       textureName.SampleLevel(samplerName, float4(coord3, index), lod)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)     textureName.SampleBias(samplerName, float4(coord3, index), bias)
	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                               textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                      textureName.SampleLevel(samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                    textureName.SampleCmpLevelZero(samplerName, (coord3).xy, (coord3).z)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)       textureName.SampleCmpLevelZero(samplerName, float3((coord3).xy, index), (coord3).z)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                  textureName.SampleCmpLevelZero(samplerName, (coord4).xyz, (coord4).w)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)     textureName.SampleCmpLevelZero(samplerName, float4((coord4).xyz, index), (coord4).w)

	#define LOAD_TEXTURE2D(textureName, unCoord2)                                   textureName.Load(int3(unCoord2, 0))
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)                          textureName.Load(int3(unCoord2, lod))
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)                 textureName.Load(unCoord2, sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)                      textureName.Load(int4(unCoord2, index, 0))
	#define LOAD_TEXTURE2D_ARRAY_MSAA(textureName, unCoord2, index, sampleIndex)    textureName.Load(int3(unCoord2, index), sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod)             textureName.Load(int4(unCoord2, index, lod))
	#define LOAD_TEXTURE3D(textureName, unCoord3)                                   textureName.Load(int4(unCoord3, 0))
	#define LOAD_TEXTURE3D_LOD(textureName, unCoord3, lod)                          textureName.Load(int4(unCoord3, lod))

	#define PLATFORM_SUPPORT_GATHER
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                textureName.Gather(samplerName, coord2)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)   textureName.Gather(samplerName, float3(coord2, index))
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)              textureName.Gather(samplerName, coord3)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index) textureName.Gather(samplerName, float4(coord3, index))
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)            textureName.GatherRed(samplerName, coord2)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherGreen(samplerName, coord2)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)           textureName.GatherBlue(samplerName, coord2)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherAlpha(samplerName, coord2)

#elif defined(SHADER_API_METAL)

	// Initialize arbitrary structure with zero values.
	// Do not exist on some platform, in this case we need to have a standard name that call a function that will initialize all parameters to 0
	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }

	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) textureName.CalculateLevelOfDetail(samplerName, coord2)

	// Texture abstraction

	#define TEXTURE2D(textureName)                Texture2D textureName
	#define TEXTURE2D_ARRAY(textureName)          Texture2DArray textureName
	#define TEXTURECUBE(textureName)              TextureCube textureName
	#define TEXTURECUBE_ARRAY(textureName)        TextureCubeArray textureName
	#define TEXTURE3D(textureName)                Texture3D textureName

	#define TEXTURE2D_FLOAT(textureName)          Texture2D_float textureName
	#define TEXTURE2D_ARRAY_FLOAT(textureName)    Texture2DArray textureName    // no support to _float on Array, it's being added
	#define TEXTURECUBE_FLOAT(textureName)        TextureCube_float textureName
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)  TextureCubeArray textureName  // no support to _float on Array, it's being added
	#define TEXTURE3D_FLOAT(textureName)          Texture3D_float textureName

	#define TEXTURE2D_HALF(textureName)           Texture2D_half textureName
	#define TEXTURE2D_ARRAY_HALF(textureName)     Texture2DArray textureName    // no support to _float on Array, it's being added
	#define TEXTURECUBE_HALF(textureName)         TextureCube_half textureName
	#define TEXTURECUBE_ARRAY_HALF(textureName)   TextureCubeArray textureName  // no support to _float on Array, it's being added
	#define TEXTURE3D_HALF(textureName)           Texture3D_half textureName

	#define TEXTURE2D_SHADOW(textureName)         TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_SHADOW(textureName)   TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_SHADOW(textureName)       TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_SHADOW(textureName) TEXTURECUBE_ARRAY(textureName)

	#define RW_TEXTURE2D(type, textureName)       RWTexture2D<type> textureName
	#define RW_TEXTURE2D_ARRAY(type, textureName) RWTexture2DArray<type> textureName
	#define RW_TEXTURE3D(type, textureName)       RWTexture3D<type> textureName

	#define SAMPLER(samplerName)                  SamplerState samplerName
	#define SAMPLER_CMP(samplerName)              SamplerComparisonState samplerName

	#define TEXTURE2D_PARAM(textureName, samplerName)                 TEXTURE2D(textureName),         SAMPLER(samplerName)
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)           TEXTURE2D_ARRAY(textureName),   SAMPLER(samplerName)
	#define TEXTURECUBE_PARAM(textureName, samplerName)               TEXTURECUBE(textureName),       SAMPLER(samplerName)
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)         TEXTURECUBE_ARRAY(textureName), SAMPLER(samplerName)
	#define TEXTURE3D_PARAM(textureName, samplerName)                 TEXTURE3D(textureName),         SAMPLER(samplerName)

	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)          TEXTURE2D(textureName),         SAMPLER_CMP(samplerName)
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)    TEXTURE2D_ARRAY(textureName),   SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)        TEXTURECUBE(textureName),       SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_ARRAY_SHADOW_PARAM(textureName, samplerName)  TEXTURECUBE_ARRAY(textureName), SAMPLER_CMP(samplerName)

	#define TEXTURE2D_ARGS(textureName, samplerName)                textureName, samplerName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)          textureName, samplerName
	#define TEXTURECUBE_ARGS(textureName, samplerName)              textureName, samplerName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)        textureName, samplerName
	#define TEXTURE3D_ARGS(textureName, samplerName)                textureName, samplerName

	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)         textureName, samplerName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)   textureName, samplerName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)       textureName, samplerName
	#define TEXTURECUBE_ARRAY_SHADOW_ARGS(textureName, samplerName) textureName, samplerName

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               textureName.Sample(samplerName, coord2)
	#define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      textureName.SampleLevel(samplerName, coord2, lod)
	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    textureName.SampleBias(samplerName, coord2, bias)
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)              textureName.SampleGrad(samplerName, coord2, dpdx, dpdy)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  textureName.Sample(samplerName, float3(coord2, index))
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         textureName.SampleLevel(samplerName, float3(coord2, index), lod)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       textureName.SampleBias(samplerName, float3(coord2, index), bias)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) textureName.SampleGrad(samplerName, float3(coord2, index), dpdx, dpdy)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    textureName.SampleLevel(samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  textureName.SampleBias(samplerName, coord3, bias)
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)                textureName.Sample(samplerName, float4(coord3, index))
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)       textureName.SampleLevel(samplerName, float4(coord3, index), lod)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)     textureName.SampleBias(samplerName, float4(coord3, index), bias)
	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                               textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                      textureName.SampleLevel(samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                    textureName.SampleCmpLevelZero(samplerName, (coord3).xy, (coord3).z)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)       textureName.SampleCmpLevelZero(samplerName, float3((coord3).xy, index), (coord3).z)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                  textureName.SampleCmpLevelZero(samplerName, (coord4).xyz, (coord4).w)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)     textureName.SampleCmpLevelZero(samplerName, float4((coord4).xyz, index), (coord4).w)

	#define LOAD_TEXTURE2D(textureName, unCoord2)                                   textureName.Load(int3(unCoord2, 0))
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)                          textureName.Load(int3(unCoord2, lod))
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)                 textureName.Load(unCoord2, sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)                      textureName.Load(int4(unCoord2, index, 0))
	#define LOAD_TEXTURE2D_ARRAY_MSAA(textureName, unCoord2, index, sampleIndex)    textureName.Load(int3(unCoord2, index), sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod)             textureName.Load(int4(unCoord2, index, lod))
	#define LOAD_TEXTURE3D(textureName, unCoord3)                                   textureName.Load(int4(unCoord3, 0))
	#define LOAD_TEXTURE3D_LOD(textureName, unCoord3, lod)                          textureName.Load(int4(unCoord3, lod))

	#define PLATFORM_SUPPORT_GATHER
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                textureName.Gather(samplerName, coord2)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)   textureName.Gather(samplerName, float3(coord2, index))
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)              textureName.Gather(samplerName, coord3)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index) textureName.Gather(samplerName, float4(coord3, index))
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)            textureName.GatherRed(samplerName, coord2)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherGreen(samplerName, coord2)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)           textureName.GatherBlue(samplerName, coord2)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherAlpha(samplerName, coord2)

#elif defined(SHADER_API_VULKAN)
// This file assume SHADER_API_VULKAN is defined
	// TODO: This is a straight copy from D3D11.hlsl. Go through all this stuff and adjust where needed.


	// Initialize arbitrary structure with zero values.
	// Do not exist on some platform, in this case we need to have a standard name that call a function that will initialize all parameters to 0
	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }

	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) textureName.CalculateLevelOfDetail(samplerName, coord2)

	// Texture abstraction

	#define TEXTURE2D(textureName)                Texture2D textureName
	#define TEXTURE2D_ARRAY(textureName)          Texture2DArray textureName
	#define TEXTURECUBE(textureName)              TextureCube textureName
	#define TEXTURECUBE_ARRAY(textureName)        TextureCubeArray textureName
	#define TEXTURE3D(textureName)                Texture3D textureName

	#define TEXTURE2D_FLOAT(textureName)          Texture2D_float textureName
	#define TEXTURE2D_ARRAY_FLOAT(textureName)    Texture2DArray textureName    // no support to _float on Array, it's being added
	#define TEXTURECUBE_FLOAT(textureName)        TextureCube_float textureName
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)  TextureCubeArray textureName  // no support to _float on Array, it's being added
	#define TEXTURE3D_FLOAT(textureName)          Texture3D_float textureName

	#define TEXTURE2D_HALF(textureName)           Texture2D_half textureName
	#define TEXTURE2D_ARRAY_HALF(textureName)     Texture2DArray textureName    // no support to _float on Array, it's being added
	#define TEXTURECUBE_HALF(textureName)         TextureCube_half textureName
	#define TEXTURECUBE_ARRAY_HALF(textureName)   TextureCubeArray textureName  // no support to _float on Array, it's being added
	#define TEXTURE3D_HALF(textureName)           Texture3D_half textureName

	#define TEXTURE2D_SHADOW(textureName)         TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_SHADOW(textureName)   TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_SHADOW(textureName)       TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_SHADOW(textureName) TEXTURECUBE_ARRAY(textureName)

	#define RW_TEXTURE2D(type, textureName)       RWTexture2D<type> textureName
	#define RW_TEXTURE2D_ARRAY(type, textureName) RWTexture2DArray<type> textureName
	#define RW_TEXTURE3D(type, textureName)       RWTexture3D<type> textureName

	#define SAMPLER(samplerName)                  SamplerState samplerName
	#define SAMPLER_CMP(samplerName)              SamplerComparisonState samplerName

	#define TEXTURE2D_PARAM(textureName, samplerName)                 TEXTURE2D(textureName),         SAMPLER(samplerName)
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)           TEXTURE2D_ARRAY(textureName),   SAMPLER(samplerName)
	#define TEXTURECUBE_PARAM(textureName, samplerName)               TEXTURECUBE(textureName),       SAMPLER(samplerName)
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)         TEXTURECUBE_ARRAY(textureName), SAMPLER(samplerName)
	#define TEXTURE3D_PARAM(textureName, samplerName)                 TEXTURE3D(textureName),         SAMPLER(samplerName)

	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)          TEXTURE2D(textureName),         SAMPLER_CMP(samplerName)
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)    TEXTURE2D_ARRAY(textureName),   SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)        TEXTURECUBE(textureName),       SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_ARRAY_SHADOW_PARAM(textureName, samplerName)  TEXTURECUBE_ARRAY(textureName), SAMPLER_CMP(samplerName)

	#define TEXTURE2D_ARGS(textureName, samplerName)                textureName, samplerName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)          textureName, samplerName
	#define TEXTURECUBE_ARGS(textureName, samplerName)              textureName, samplerName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)        textureName, samplerName
	#define TEXTURE3D_ARGS(textureName, samplerName)                textureName, samplerName

	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)         textureName, samplerName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)   textureName, samplerName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)       textureName, samplerName
	#define TEXTURECUBE_ARRAY_SHADOW_ARGS(textureName, samplerName) textureName, samplerName

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               textureName.Sample(samplerName, coord2)
	#define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      textureName.SampleLevel(samplerName, coord2, lod)
	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    textureName.SampleBias(samplerName, coord2, bias)
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)              textureName.SampleGrad(samplerName, coord2, dpdx, dpdy)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  textureName.Sample(samplerName, float3(coord2, index))
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         textureName.SampleLevel(samplerName, float3(coord2, index), lod)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       textureName.SampleBias(samplerName, float3(coord2, index), bias)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) textureName.SampleGrad(samplerName, float3(coord2, index), dpdx, dpdy)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    textureName.SampleLevel(samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  textureName.SampleBias(samplerName, coord3, bias)
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)                textureName.Sample(samplerName, float4(coord3, index))
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)       textureName.SampleLevel(samplerName, float4(coord3, index), lod)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)     textureName.SampleBias(samplerName, float4(coord3, index), bias)
	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                               textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                      textureName.SampleLevel(samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                    textureName.SampleCmpLevelZero(samplerName, (coord3).xy, (coord3).z)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)       textureName.SampleCmpLevelZero(samplerName, float3((coord3).xy, index), (coord3).z)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                  textureName.SampleCmpLevelZero(samplerName, (coord4).xyz, (coord4).w)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)     textureName.SampleCmpLevelZero(samplerName, float4((coord4).xyz, index), (coord4).w)

	#define LOAD_TEXTURE2D(textureName, unCoord2)                                   textureName.Load(int3(unCoord2, 0))
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)                          textureName.Load(int3(unCoord2, lod))
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)                 textureName.Load(unCoord2, sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)                      textureName.Load(int4(unCoord2, index, 0))
	#define LOAD_TEXTURE2D_ARRAY_MSAA(textureName, unCoord2, index, sampleIndex)    textureName.Load(int3(unCoord2, index), sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod)             textureName.Load(int4(unCoord2, index, lod))
	#define LOAD_TEXTURE3D(textureName, unCoord3)                                   textureName.Load(int4(unCoord3, 0))
	#define LOAD_TEXTURE3D_LOD(textureName, unCoord3, lod)                          textureName.Load(int4(unCoord3, lod))

	#define PLATFORM_SUPPORT_GATHER
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                textureName.Gather(samplerName, coord2)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)   textureName.Gather(samplerName, float3(coord2, index))
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)              textureName.Gather(samplerName, coord3)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index) textureName.Gather(samplerName, float4(coord3, index))
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)            textureName.GatherRed(samplerName, coord2)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherGreen(samplerName, coord2)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)           textureName.GatherBlue(samplerName, coord2)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherAlpha(samplerName, coord2)

#elif defined(SHADER_API_SWITCH)
	// This file assume SHADER_API_SWITCH is defined

	// Initialize arbitrary structure with zero values.
	// Do not exist on some platform, in this case we need to have a standard name that call a function that will initialize all parameters to 0
	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }

	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) textureName.CalculateLevelOfDetail(samplerName, coord2)

	// Texture abstraction

	#define TEXTURE2D(textureName)                Texture2D textureName
	#define TEXTURE2D_ARRAY(textureName)          Texture2DArray textureName
	#define TEXTURECUBE(textureName)              TextureCube textureName
	#define TEXTURECUBE_ARRAY(textureName)        TextureCubeArray textureName
	#define TEXTURE3D(textureName)                Texture3D textureName

	#define TEXTURE2D_FLOAT(textureName)          Texture2D_float textureName
	#define TEXTURE2D_ARRAY_FLOAT(textureName)    Texture2DArray textureName    // no support to _float on Array, it's being added
	#define TEXTURECUBE_FLOAT(textureName)        TextureCube_float textureName
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)  TextureCubeArray textureName  // no support to _float on Array, it's being added
	#define TEXTURE3D_FLOAT(textureName)          Texture3D_float textureName

	#define TEXTURE2D_HALF(textureName)           Texture2D_half textureName
	#define TEXTURE2D_ARRAY_HALF(textureName)     Texture2DArray textureName    // no support to _float on Array, it's being added
	#define TEXTURECUBE_HALF(textureName)         TextureCube_half textureName
	#define TEXTURECUBE_ARRAY_HALF(textureName)   TextureCubeArray textureName  // no support to _float on Array, it's being added
	#define TEXTURE3D_HALF(textureName)           Texture3D_half textureName

	#define TEXTURE2D_SHADOW(textureName)         TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_SHADOW(textureName)   TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_SHADOW(textureName)       TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_SHADOW(textureName) TEXTURECUBE_ARRAY(textureName)

	#define RW_TEXTURE2D(type, textureName)       RWTexture2D<type> textureName
	#define RW_TEXTURE2D_ARRAY(type, textureName) RWTexture2DArray<type> textureName
	#define RW_TEXTURE3D(type, textureName)       RWTexture3D<type> textureName

	#define SAMPLER(samplerName)                  SamplerState samplerName
	#define SAMPLER_CMP(samplerName)              SamplerComparisonState samplerName

	#define TEXTURE2D_PARAM(textureName, samplerName)                 TEXTURE2D(textureName),         SAMPLER(samplerName)
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)           TEXTURE2D_ARRAY(textureName),   SAMPLER(samplerName)
	#define TEXTURECUBE_PARAM(textureName, samplerName)               TEXTURECUBE(textureName),       SAMPLER(samplerName)
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)         TEXTURECUBE_ARRAY(textureName), SAMPLER(samplerName)
	#define TEXTURE3D_PARAM(textureName, samplerName)                 TEXTURE3D(textureName),         SAMPLER(samplerName)

	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)          TEXTURE2D(textureName),         SAMPLER_CMP(samplerName)
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)    TEXTURE2D_ARRAY(textureName),   SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)        TEXTURECUBE(textureName),       SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_ARRAY_SHADOW_PARAM(textureName, samplerName)  TEXTURECUBE_ARRAY(textureName), SAMPLER_CMP(samplerName)

	#define TEXTURE2D_ARGS(textureName, samplerName)                textureName, samplerName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)          textureName, samplerName
	#define TEXTURECUBE_ARGS(textureName, samplerName)              textureName, samplerName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)        textureName, samplerName
	#define TEXTURE3D_ARGS(textureName, samplerName)                textureName, samplerName

	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)         textureName, samplerName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)   textureName, samplerName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)       textureName, samplerName
	#define TEXTURECUBE_ARRAY_SHADOW_ARGS(textureName, samplerName) textureName, samplerName

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               textureName.Sample(samplerName, coord2)
	#define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      textureName.SampleLevel(samplerName, coord2, lod)
	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    textureName.SampleBias(samplerName, coord2, bias)
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)              textureName.SampleGrad(samplerName, coord2, dpdx, dpdy)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  textureName.Sample(samplerName, float3(coord2, index))
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         textureName.SampleLevel(samplerName, float3(coord2, index), lod)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       textureName.SampleBias(samplerName, float3(coord2, index), bias)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) textureName.SampleGrad(samplerName, float3(coord2, index), dpdx, dpdy)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    textureName.SampleLevel(samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  textureName.SampleBias(samplerName, coord3, bias)
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)                textureName.Sample(samplerName, float4(coord3, index))
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)       textureName.SampleLevel(samplerName, float4(coord3, index), lod)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)     textureName.SampleBias(samplerName, float4(coord3, index), bias)
	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                               textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                      textureName.SampleLevel(samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                    textureName.SampleCmpLevelZero(samplerName, (coord3).xy, (coord3).z)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)       textureName.SampleCmpLevelZero(samplerName, float3((coord3).xy, index), (coord3).z)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                  textureName.SampleCmpLevelZero(samplerName, (coord4).xyz, (coord4).w)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)     textureName.SampleCmpLevelZero(samplerName, float4((coord4).xyz, index), (coord4).w)


	#define LOAD_TEXTURE2D(textureName, unCoord2)                       textureName.Load(int3(unCoord2, 0))
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)              textureName.Load(int3(unCoord2, lod))
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)     textureName.Load(unCoord2, sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)          textureName.Load(int4(unCoord2, index, 0))
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod) textureName.Load(int4(unCoord2, index, lod))
	#define LOAD_TEXTURE3D(textureName, unCoord3)                       textureName.Load(int4(unCoord3, 0))
	#define LOAD_TEXTURE3D_LOD(textureName, unCoord3, lod)              textureName.Load(int4(unCoord3, lod))

	#define PLATFORM_SUPPORT_GATHER
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                textureName.Gather(samplerName, coord2)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)   textureName.Gather(samplerName, float3(coord2, index))
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)              textureName.Gather(samplerName, coord3)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index) textureName.Gather(samplerName, float4(coord3, index))
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)            textureName.GatherRed(samplerName, coord2)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherGreen(samplerName, coord2)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)           textureName.GatherBlue(samplerName, coord2)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherAlpha(samplerName, coord2)

#elif defined(SHADER_API_GLCORE)

	// OpenGL 4.1 SM 5.0 https://docs.unity3d.com/Manual/SL-ShaderCompileTargets.html
	#if (SHADER_TARGET >= 46)
	#define OPENGL4_1_SM5 1
	#else
	#define OPENGL4_1_SM5 0
	#endif

	// Initialize arbitrary structure with zero values.
	// Do not exist on some platform, in this case we need to have a standard name that call a function that will initialize all parameters to 0
	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }

	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) textureName.CalculateLevelOfDetail(samplerName, coord2)

	// Texture abstraction

	#define TEXTURE2D(textureName)                  Texture2D textureName
	#define TEXTURE2D_ARRAY(textureName)            Texture2DArray textureName
	#define TEXTURECUBE(textureName)                TextureCube textureName
	#define TEXTURECUBE_ARRAY(textureName)          TextureCubeArray textureName
	#define TEXTURE3D(textureName)                  Texture3D textureName

	#define TEXTURE2D_FLOAT(textureName)            TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_FLOAT(textureName)      TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_FLOAT(textureName)          TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)    TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_FLOAT(textureName)            TEXTURE3D(textureName)

	#define TEXTURE2D_HALF(textureName)             TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_HALF(textureName)       TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_HALF(textureName)           TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_HALF(textureName)     TEXTURECUBE_ARRAY(textureName)
	#define TEXTURE3D_HALF(textureName)             TEXTURE3D(textureName)

	#define TEXTURE2D_SHADOW(textureName)           TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_SHADOW(textureName)     TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_SHADOW(textureName)         TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_SHADOW(textureName)   TEXTURECUBE_ARRAY(textureName)

	#define RW_TEXTURE2D(type, textureName)         RWTexture2D<type> textureName
	#define RW_TEXTURE2D_ARRAY(type, textureName)   RWTexture2DArray<type> textureName
	#define RW_TEXTURE3D(type, textureName)         RWTexture3D<type> textureName

	#define SAMPLER(samplerName)                    SamplerState samplerName
	#define SAMPLER_CMP(samplerName)                SamplerComparisonState samplerName

	#define TEXTURE2D_PARAM(textureName, samplerName)                 TEXTURE2D(textureName),         SAMPLER(samplerName)
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)           TEXTURE2D_ARRAY(textureName),   SAMPLER(samplerName)
	#define TEXTURECUBE_PARAM(textureName, samplerName)               TEXTURECUBE(textureName),       SAMPLER(samplerName)
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)         TEXTURECUBE_ARRAY(textureName), SAMPLER(samplerName)
	#define TEXTURE3D_PARAM(textureName, samplerName)                 TEXTURE3D(textureName),         SAMPLER(samplerName)

	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)          TEXTURE2D(textureName),         SAMPLER_CMP(samplerName)
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)    TEXTURE2D_ARRAY(textureName),   SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)        TEXTURECUBE(textureName),       SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_ARRAY_SHADOW_PARAM(textureName, samplerName)  TEXTURECUBE_ARRAY(textureName), SAMPLER_CMP(samplerName)

	#define TEXTURE2D_ARGS(textureName, samplerName)                textureName, samplerName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)          textureName, samplerName
	#define TEXTURECUBE_ARGS(textureName, samplerName)              textureName, samplerName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)        textureName, samplerName
	#define TEXTURE3D_ARGS(textureName, samplerName)                textureName, samplerName

	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)         textureName, samplerName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)   textureName, samplerName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)       textureName, samplerName
	#define TEXTURECUBE_ARRAY_SHADOW_ARGS(textureName, samplerName) textureName, samplerName

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               textureName.Sample(samplerName, coord2)
	#define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      textureName.SampleLevel(samplerName, coord2, lod)
	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    textureName.SampleBias(samplerName, coord2, bias)
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, ddx, ddy)                textureName.SampleGrad(samplerName, coord2, ddx, ddy)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  textureName.Sample(samplerName, float3(coord2, index))
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         textureName.SampleLevel(samplerName, float3(coord2, index), lod)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       textureName.SampleBias(samplerName, float3(coord2, index), bias)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) textureName.SampleGrad(samplerName, float3(coord2, index), dpdx, dpdy)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    textureName.SampleLevel(samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  textureName.SampleBias(samplerName, coord3, bias)
	#ifdef UNITY_NO_CUBEMAP_ARRAY
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)           ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY)
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)  ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY_LOD)
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, bias) ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY_LOD)
	#else
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)           textureName.Sample(samplerName, float4(coord3, index))
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)  textureName.SampleLevel(samplerName, float4(coord3, index), lod)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)textureName.SampleBias(samplerName, float4(coord3, index), bias)
	#endif
	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                          textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                 textureName.SampleLevel(samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                   textureName.SampleCmpLevelZero(samplerName, (coord3).xy, (coord3).z)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)      textureName.SampleCmpLevelZero(samplerName, float3((coord3).xy, index), (coord3).z)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                 textureName.SampleCmpLevelZero(samplerName, (coord4).xyz, (coord4).w)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)    textureName.SampleCmpLevelZero(samplerName, float4((coord4).xyz, index), (coord4).w)

	#define LOAD_TEXTURE2D(textureName, unCoord2)                                   textureName.Load(int3(unCoord2, 0))
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)                          textureName.Load(int3(unCoord2, lod))
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)                 textureName.Load(unCoord2, sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)                      textureName.Load(int4(unCoord2, index, 0))
	#define LOAD_TEXTURE2D_ARRAY_MSAA(textureName, unCoord2, index, sampleIndex)    textureName.Load(int3(unCoord2, index), sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod)             textureName.Load(int4(unCoord2, index, lod))

	#if OPENGL4_1_SM5
	#define PLATFORM_SUPPORT_GATHER
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                  textureName.Gather(samplerName, coord2)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)     textureName.Gather(samplerName, float3(coord2, index))
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)                textureName.Gather(samplerName, coord3)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)   textureName.Gather(samplerName, float4(coord3, index))
	#else
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                  ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURE2D)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)     ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURE2D_ARRAY)
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)                ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURECUBE)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)   ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURECUBE_ARRAY)
	#endif


	#elif defined(SHADER_API_GLES3)

	// GLES 3.1 + AEP shader feature https://docs.unity3d.com/Manual/SL-ShaderCompileTargets.html
	#if (SHADER_TARGET >= 40)
	#define GLES3_1_AEP 1
	#else
	#define GLES3_1_AEP 0
	#endif

	// Initialize arbitrary structure with zero values.
	// Do not exist on some platform, in this case we need to have a standard name that call a function that will initialize all parameters to 0
	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }

	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) textureName.CalculateLevelOfDetail(samplerName, coord2)

	// Texture abstraction

	#define TEXTURE2D(textureName)                  Texture2D textureName
	#define TEXTURE2D_ARRAY(textureName)            Texture2DArray textureName
	#define TEXTURECUBE(textureName)                TextureCube textureName
	#define TEXTURECUBE_ARRAY(textureName)          TextureCubeArray textureName
	#define TEXTURE3D(textureName)                  Texture3D textureName

	#define TEXTURE2D_FLOAT(textureName)            Texture2D_float textureName
	#define TEXTURE2D_ARRAY_FLOAT(textureName)      Texture2DArray textureName    // no support to _float on Array, it's being added
	#define TEXTURECUBE_FLOAT(textureName)          TextureCube_float textureName
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)    TextureCubeArray textureName  // no support to _float on Array, it's being added
	#define TEXTURE3D_FLOAT(textureName)            Texture3D_float textureName

	#define TEXTURE2D_HALF(textureName)             Texture2D_half textureName
	#define TEXTURE2D_ARRAY_HALF(textureName)       Texture2DArray textureName    // no support to _float on Array, it's being added
	#define TEXTURECUBE_HALF(textureName)           TextureCube_half textureName
	#define TEXTURECUBE_ARRAY_HALF(textureName)     TextureCubeArray textureName  // no support to _float on Array, it's being added
	#define TEXTURE3D_HALF(textureName)             Texture3D_half textureName

	#define TEXTURE2D_SHADOW(textureName)           TEXTURE2D(textureName)
	#define TEXTURE2D_ARRAY_SHADOW(textureName)     TEXTURE2D_ARRAY(textureName)
	#define TEXTURECUBE_SHADOW(textureName)         TEXTURECUBE(textureName)
	#define TEXTURECUBE_ARRAY_SHADOW(textureName)   TEXTURECUBE_ARRAY(textureName)

	#if GLES3_1_AEP
	#define RW_TEXTURE2D(type, textureName)         RWTexture2D<type> textureName
	#define RW_TEXTURE2D_ARRAY(type, textureName)   RWTexture2DArray<type> textureName
	#define RW_TEXTURE3D(type, textureName)         RWTexture3D<type> textureName
	#else
	#define RW_TEXTURE2D(type, textureName)         ERROR_ON_UNSUPPORTED_FUNCTION(RWTexture2D)
	#define RW_TEXTURE2D_ARRAY(type, textureName)   ERROR_ON_UNSUPPORTED_FUNCTION(RWTexture2DArray)
	#define RW_TEXTURE3D(type, textureName)         ERROR_ON_UNSUPPORTED_FUNCTION(RWTexture3D)
	#endif

	#define SAMPLER(samplerName)                    SamplerState samplerName
	#define SAMPLER_CMP(samplerName)                SamplerComparisonState samplerName

	#define TEXTURE2D_PARAM(textureName, samplerName)                 TEXTURE2D(textureName),         SAMPLER(samplerName)
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)           TEXTURE2D_ARRAY(textureName),   SAMPLER(samplerName)
	#define TEXTURECUBE_PARAM(textureName, samplerName)               TEXTURECUBE(textureName),       SAMPLER(samplerName)
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)         TEXTURECUBE_ARRAY(textureName), SAMPLER(samplerName)
	#define TEXTURE3D_PARAM(textureName, samplerName)                 TEXTURE3D(textureName),         SAMPLER(samplerName)

	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)          TEXTURE2D(textureName),         SAMPLER_CMP(samplerName)
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)    TEXTURE2D_ARRAY(textureName),   SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)        TEXTURECUBE(textureName),       SAMPLER_CMP(samplerName)
	#define TEXTURECUBE_ARRAY_SHADOW_PARAM(textureName, samplerName)  TEXTURECUBE_ARRAY(textureName), SAMPLER_CMP(samplerName)

	#define TEXTURE2D_ARGS(textureName, samplerName)                textureName, samplerName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)          textureName, samplerName
	#define TEXTURECUBE_ARGS(textureName, samplerName)              textureName, samplerName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)        textureName, samplerName
	#define TEXTURE3D_ARGS(textureName, samplerName)                textureName, samplerName

	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)         textureName, samplerName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)   textureName, samplerName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)       textureName, samplerName
	#define TEXTURECUBE_ARRAY_SHADOW_ARGS(textureName, samplerName) textureName, samplerName

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               textureName.Sample(samplerName, coord2)
	#define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      textureName.SampleLevel(samplerName, coord2, lod)
	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    textureName.SampleBias(samplerName, coord2, bias)
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, ddx, ddy)                textureName.SampleGrad(samplerName, coord2, ddx, ddy)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  textureName.Sample(samplerName, float3(coord2, index))
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         textureName.SampleLevel(samplerName, float3(coord2, index), lod)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       textureName.SampleBias(samplerName, float3(coord2, index), bias)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) textureName.SampleGrad(samplerName, float3(coord2, index), dpdx, dpdy)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    textureName.SampleLevel(samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  textureName.SampleBias(samplerName, coord3, bias)

	#ifdef UNITY_NO_CUBEMAP_ARRAY
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)           ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY)
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)  ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY_LOD)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY_BIAS)
	#else
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)           textureName.Sample(samplerName, float4(coord3, index))
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)  textureName.SampleLevel(samplerName, float4(coord3, index), lod)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)textureName.SampleBias(samplerName, float4(coord3, index), bias)
	#endif

	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                          textureName.Sample(samplerName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                 textureName.SampleLevel(samplerName, coord3, lod)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                   textureName.SampleCmpLevelZero(samplerName, (coord3).xy, (coord3).z)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)      textureName.SampleCmpLevelZero(samplerName, float3((coord3).xy, index), (coord3).z)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                 textureName.SampleCmpLevelZero(samplerName, (coord4).xyz, (coord4).w)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)    textureName.SampleCmpLevelZero(samplerName, float4((coord4).xyz, index), (coord4).w)


	#define LOAD_TEXTURE2D(textureName, unCoord2)                                       textureName.Load(int3(unCoord2, 0))
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)                              textureName.Load(int3(unCoord2, lod))
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)                     textureName.Load(unCoord2, sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)                          textureName.Load(int4(unCoord2, index, 0))
	#define LOAD_TEXTURE2D_ARRAY_MSAA(textureName, unCoord2, index, sampleIndex)        textureName.Load(int3(unCoord2, index), sampleIndex)
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod)                 textureName.Load(int4(unCoord2, index, lod))
	#define LOAD_TEXTURE3D(textureName, unCoord3)                                       textureName.Load(int4(unCoord3, 0))
	#define LOAD_TEXTURE3D_LOD(textureName, unCoord3, lod)                              textureName.Load(int4(unCoord3, lod))

	#if GLES3_1_AEP
	#define PLATFORM_SUPPORT_GATHER
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                  textureName.Gather(samplerName, coord2)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)     textureName.Gather(samplerName, float3(coord2, index))
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)                textureName.Gather(samplerName, coord3)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)   textureName.Gather(samplerName, float4(coord3, index))
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)              textureName.GatherRed(samplerName, coord2)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)            textureName.GatherGreen(samplerName, coord2)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)             textureName.GatherBlue(samplerName, coord2)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)            textureName.GatherAlpha(samplerName, coord2)
	#else
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                  ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURE2D)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)     ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURE2D_ARRAY)
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)                ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURECUBE)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)   ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURECUBE_ARRAY)
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)              ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_RED_TEXTURE2D)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)            ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_GREEN_TEXTURE2D)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)             ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_BLUE_TEXTURE2D)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)            ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_ALPHA_TEXTURE2D)
	#endif


#elif defined(SHADER_API_GLES)


	#define uint int

	#define rcp(x) 1.0 / (x)
	#define ddx_fine ddx
	#define ddy_fine ddy
	#define asfloat
	#define asuint(x) asint(x)
	#define f32tof16
	#define f16tof32

	#define ERROR_ON_UNSUPPORTED_FUNCTION(funcName) #error #funcName is not supported on GLES 2.0

	// Initialize arbitrary structure with zero values.
	// Do not exist on some platform, in this case we need to have a standard name that call a function that will initialize all parameters to 0
	#define ZERO_INITIALIZE(type, name) name = (type)0;
	#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }


	// Texture util abstraction

	#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) #error calculate Level of Detail not supported in GLES2

	// Texture abstraction

	#define TEXTURE2D(textureName)                          sampler2D textureName
	#define TEXTURE2D_ARRAY(textureName)                    samplerCUBE textureName // No support to texture2DArray
	#define TEXTURECUBE(textureName)                        samplerCUBE textureName
	#define TEXTURECUBE_ARRAY(textureName)                  samplerCUBE textureName // No supoport to textureCubeArray and can't emulate with texture2DArray
	#define TEXTURE3D(textureName)                          sampler3D textureName

	#define TEXTURE2D_FLOAT(textureName)                    sampler2D_float textureName
	#define TEXTURE2D_ARRAY_FLOAT(textureName)              TEXTURECUBE_FLOAT(textureName) // No support to texture2DArray
	#define TEXTURECUBE_FLOAT(textureName)                  samplerCUBE_float textureName
	#define TEXTURECUBE_ARRAY_FLOAT(textureName)            TEXTURECUBE_FLOAT(textureName) // No support to textureCubeArray
	#define TEXTURE3D_FLOAT(textureName)                    sampler3D_float textureName

	#define TEXTURE2D_HALF(textureName)                     sampler2D_half textureName
	#define TEXTURE2D_ARRAY_HALF(textureName)               TEXTURECUBE_HALF(textureName) // No support to texture2DArray
	#define TEXTURECUBE_HALF(textureName)                   samplerCUBE_half textureName
	#define TEXTURECUBE_ARRAY_HALF(textureName)             TEXTURECUBE_HALF(textureName) // No support to textureCubeArray
	#define TEXTURE3D_HALF(textureName)                     sampler3D_half textureName

	#define TEXTURE2D_SHADOW(textureName)                   SHADOW2D_TEXTURE_AND_SAMPLER textureName
	#define TEXTURE2D_ARRAY_SHADOW(textureName)             TEXTURECUBE_SHADOW(textureName) // No support to texture array
	#define TEXTURECUBE_SHADOW(textureName)                 SHADOWCUBE_TEXTURE_AND_SAMPLER textureName
	#define TEXTURECUBE_ARRAY_SHADOW(textureName)           TEXTURECUBE_SHADOW(textureName) // No support to texture array

	#define RW_TEXTURE2D(type, textureNam)                  ERROR_ON_UNSUPPORTED_FUNCTION(RWTexture2D)
	#define RW_TEXTURE2D_ARRAY(type, textureName)           ERROR_ON_UNSUPPORTED_FUNCTION(RWTexture2DArray)
	#define RW_TEXTURE3D(type, textureNam)                  ERROR_ON_UNSUPPORTED_FUNCTION(RWTexture3D)

	#define SAMPLER(samplerName)
	#define SAMPLER_CMP(samplerName)

	#define TEXTURE2D_PARAM(textureName, samplerName)                sampler2D textureName
	#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)          samplerCUBE textureName
	#define TEXTURECUBE_PARAM(textureName, samplerName)              samplerCUBE textureName
	#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)        samplerCUBE textureName
	#define TEXTURE3D_PARAM(textureName, samplerName)                sampler3D textureName
	#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)         SHADOW2D_TEXTURE_AND_SAMPLER textureName
	#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)   SHADOWCUBE_TEXTURE_AND_SAMPLER textureName
	#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)       SHADOWCUBE_TEXTURE_AND_SAMPLER textureName

	#define TEXTURE2D_ARGS(textureName, samplerName)               textureName
	#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)         textureName
	#define TEXTURECUBE_ARGS(textureName, samplerName)             textureName
	#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)       textureName
	#define TEXTURE3D_ARGS(textureName, samplerName)               textureName
	#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)        textureName
	#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)  textureName
	#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)      textureName

	#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2) tex2D(textureName, coord2)

	#if (SHADER_TARGET >= 30)
	    #define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod) tex2Dlod(textureName, float4(coord2, 0, lod))
	#else
	    // No lod support. Very poor approximation with bias.
	    #define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod) SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, lod)
	#endif

	#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                       tex2Dbias(textureName, float4(coord2, 0, bias))
	#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, ddx, ddy)                   SAMPLE_TEXTURE2D(textureName, samplerName, coord2)
	#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                     ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURE2D_ARRAY)
	#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)            ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURE2D_ARRAY_LOD)
	#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)          ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURE2D_ARRAY_BIAS)
	#define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy)    ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURE2D_ARRAY_GRAD)
	#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                                texCUBE(textureName, coord3)
	// No lod support. Very poor approximation with bias.
	#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                       SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, lod)
	#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                     texCUBEbias(textureName, float4(coord3, bias))
	#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)                   ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY)
	#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)          ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY_LOD)
	#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)        ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY_BIAS)
	#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                                  tex3D(textureName, coord3)
	#define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                         ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURE3D_LOD)

	#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                           SHADOW2D_SAMPLE(textureName, samplerName, coord3)
	#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)              ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURE2D_ARRAY_SHADOW)
	#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                         SHADOWCUBE_SAMPLE(textureName, samplerName, coord4)
	#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)            ERROR_ON_UNSUPPORTED_FUNCTION(SAMPLE_TEXTURECUBE_ARRAY_SHADOW)


	// Not supported. Can't define as error because shader library is calling these functions.
	#define LOAD_TEXTURE2D(textureName, unCoord2)                                               half4(0, 0, 0, 0)
	#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)                                      half4(0, 0, 0, 0)
	#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)                             half4(0, 0, 0, 0)
	#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)                                  half4(0, 0, 0, 0)
	#define LOAD_TEXTURE2D_ARRAY_MSAA(textureName, unCoord2, index, sampleIndex)                half4(0, 0, 0, 0)
	#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod)                         half4(0, 0, 0, 0)
	#define LOAD_TEXTURE3D(textureName, unCoord3)                                               ERROR_ON_UNSUPPORTED_FUNCTION(LOAD_TEXTURE3D)
	#define LOAD_TEXTURE3D_LOD(textureName, unCoord3, lod)                                      ERROR_ON_UNSUPPORTED_FUNCTION(LOAD_TEXTURE3D_LOD)

	// Gather not supported. Fallback to regular texture sampling.
	#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                  ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURE2D)
	#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)     ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURE2D_ARRAY)
	#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)                ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURECUBE)
	#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)   ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_TEXTURECUBE_ARRAY)
	#define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)              ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_RED_TEXTURE2D)
	#define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)            ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_GREEN_TEXTURE2D)
	#define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)             ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_BLUE_TEXTURE2D)
	#define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)            ERROR_ON_UNSUPPORTED_FUNCTION(GATHER_ALPHA_TEXTURE2D)

#else
#error unsupported shader api
#endif




// default flow control attributes
#ifndef UNITY_BRANCH
#   define UNITY_BRANCH
#endif
#ifndef UNITY_FLATTEN
#   define UNITY_FLATTEN
#endif
#ifndef UNITY_UNROLL
#   define UNITY_UNROLL
#endif
#ifndef UNITY_UNROLLX
#   define UNITY_UNROLLX(_x)
#endif
#ifndef UNITY_LOOP
#   define UNITY_LOOP
#endif



#define _GRABPASSUSED 1
#define REQUIRE_OPAQUE_TEXTURE


         

         // data across stages, stripped like the above.
         struct VertexToPixel
         {
            UNITY_POSITION(pos);
            float3 worldPos : TEXCOORD0;
            float3 worldNormal : TEXCOORD1;
            float4 worldTangent : TEXCOORD2;
             float4 texcoord0 : TEXCOORD3;
            // float4 texcoord1 : TEXCOORD4;
            // float4 texcoord2 : TEXCOORD5;

            // #if %TEXCOORD3REQUIREKEY%
            // float4 texcoord3 : TEXCOORD6;
            // #endif

            // #if %SCREENPOSREQUIREKEY%
             float4 screenPos : TEXCOORD7;
            // #endif

            #ifdef EDITOR_VISUALIZATION
              float2 vizUV : TEXCOORD8;
              float4 lightCoord : TEXCOORD9;
            #endif

            
            // #if %VERTEXCOLORREQUIREKEY%
             float4 vertexColor : COLOR;
            // #endif

            // #if %EXTRAV2F0REQUIREKEY%
             float4 extraV2F0 : TEXCOORD10;
            // #endif

            // #if %EXTRAV2F1REQUIREKEY%
             float4 extraV2F1 : TEXCOORD11;
            // #endif

            // #if %EXTRAV2F2REQUIREKEY%
            // float4 extraV2F2 : TEXCOORD12;
            // #endif

            // #if %EXTRAV2F3REQUIREKEY%
            // float4 extraV2F3 : TEXCOORD13;
            // #endif

            // #if %EXTRAV2F4REQUIREKEY%
            // float4 extraV2F4 : TEXCOORD14;
            // #endif

            // #if %EXTRAV2F5REQUIREKEY%
            // float4 extraV2F5 : TEXCOORD15;
            // #endif

            // #if %EXTRAV2F6REQUIREKEY%
            // float4 extraV2F6 : TEXCOORD16;
            // #endif

            // #if %EXTRAV2F7REQUIREKEY%
            // float4 extraV2F7 : TEXCOORD17;
            // #endif


            UNITY_VERTEX_INPUT_INSTANCE_ID
            UNITY_VERTEX_OUTPUT_STEREO
         };

         
            
            // data describing the user output of a pixel
            struct Surface
            {
               half3 Albedo;
               half Height;
               half3 Normal;
               half Smoothness;
               half3 Emission;
               half Metallic;
               half3 Specular;
               half Occlusion;
               half SpecularPower; // for simple lighting
               half Alpha;
               float outputDepth; // if written, SV_Depth semantic is used. ShaderData.clipPos.z is unused value
               // HDRP Only
               half SpecularOcclusion;
               half SubsurfaceMask;
               half Thickness;
               half CoatMask;
               half CoatSmoothness;
               half Anisotropy;
               half IridescenceMask;
               half IridescenceThickness;
               int DiffusionProfileHash;
               float SpecularAAThreshold;
               float SpecularAAScreenSpaceVariance;
               // requires _OVERRIDE_BAKEDGI to be defined, but is mapped in all pipelines
               float3 DiffuseGI;
               float3 BackDiffuseGI;
               float3 SpecularGI;
               // requires _OVERRIDE_SHADOWMASK to be defines
               float4 ShadowMask;
            };

            // Data the user declares in blackboard blocks
            struct Blackboard
            {
                
	float  groundHeight;
	float  surfaceHeight;
	float3 surfaceNormal;

	Fluid fluid;


	float foam;


                float blackboardDummyData;
            };

            // data the user might need, this will grow to be big. But easy to strip
            struct ShaderData
            {
               float4 clipPos; // SV_POSITION
               float3 localSpacePosition;
               float3 localSpaceNormal;
               float3 localSpaceTangent;
        
               float3 worldSpacePosition;
               float3 worldSpaceNormal;
               float3 worldSpaceTangent;
               float tangentSign;

               float3 worldSpaceViewDir;
               float3 tangentSpaceViewDir;

               float4 texcoord0;
               float4 texcoord1;
               float4 texcoord2;
               float4 texcoord3;

               float2 screenUV;
               float4 screenPos;

               float4 vertexColor;
               bool isFrontFace;

               float4 extraV2F0;
               float4 extraV2F1;
               float4 extraV2F2;
               float4 extraV2F3;
               float4 extraV2F4;
               float4 extraV2F5;
               float4 extraV2F6;
               float4 extraV2F7;

               float3x3 TBNMatrix;
               Blackboard blackboard;
            };

            struct VertexData
            {
               #if SHADER_TARGET > 30
               // uint vertexID : SV_VertexID;
               #endif
               float4 vertex : POSITION;
               float3 normal : NORMAL;
               float4 tangent : TANGENT;
               float4 texcoord0 : TEXCOORD0;

               // optimize out mesh coords when not in use by user or lighting system
               #if _URP && (_USINGTEXCOORD1 || _PASSMETA || _PASSFORWARD || _PASSGBUFFER)
                  float4 texcoord1 : TEXCOORD1;
               #endif

               #if _URP && (_USINGTEXCOORD2 || _PASSMETA || ((_PASSFORWARD || _PASSGBUFFER) && defined(DYNAMICLIGHTMAP_ON)))
                  float4 texcoord2 : TEXCOORD2;
               #endif

               #if _STANDARD && (_USINGTEXCOORD1 || (_PASSMETA || ((_PASSFORWARD || _PASSGBUFFER || _PASSFORWARDADD) && LIGHTMAP_ON)))
                  float4 texcoord1 : TEXCOORD1;
               #endif
               #if _STANDARD && (_USINGTEXCOORD2 || (_PASSMETA || ((_PASSFORWARD || _PASSGBUFFER) && DYNAMICLIGHTMAP_ON)))
                  float4 texcoord2 : TEXCOORD2;
               #endif


               #if _HDRP
                  float4 texcoord1 : TEXCOORD1;
                  float4 texcoord2 : TEXCOORD2;
               #endif

               // #if %TEXCOORD3REQUIREKEY%
               // float4 texcoord3 : TEXCOORD3;
               // #endif

               // #if %VERTEXCOLORREQUIREKEY%
                float4 vertexColor : COLOR;
               // #endif

               #if _HDRP && (_PASSMOTIONVECTOR || ((_PASSFORWARD || _PASSUNLIT) && defined(_WRITE_TRANSPARENT_MOTION_VECTOR)))
                  float3 previousPositionOS : TEXCOORD4; // Contain previous transform position (in case of skinning for example)
                  #if defined (_ADD_PRECOMPUTED_VELOCITY)
                     float3 precomputedVelocity    : TEXCOORD5; // Add Precomputed Velocity (Alembic computes velocities on runtime side).
                  #endif
               #endif

               UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct TessVertex 
            {
               float4 vertex : INTERNALTESSPOS;
               float3 normal : NORMAL;
               float4 tangent : TANGENT;
               float4 texcoord0 : TEXCOORD0;
               float4 texcoord1 : TEXCOORD1;
               float4 texcoord2 : TEXCOORD2;

               // #if %TEXCOORD3REQUIREKEY%
               // float4 texcoord3 : TEXCOORD3;
               // #endif

               // #if %VERTEXCOLORREQUIREKEY%
                float4 vertexColor : COLOR;
               // #endif

               // #if %EXTRAV2F0REQUIREKEY%
                float4 extraV2F0 : TEXCOORD5;
               // #endif

               // #if %EXTRAV2F1REQUIREKEY%
                float4 extraV2F1 : TEXCOORD6;
               // #endif

               // #if %EXTRAV2F2REQUIREKEY%
               // float4 extraV2F2 : TEXCOORD7;
               // #endif

               // #if %EXTRAV2F3REQUIREKEY%
               // float4 extraV2F3 : TEXCOORD8;
               // #endif

               // #if %EXTRAV2F4REQUIREKEY%
               // float4 extraV2F4 : TEXCOORD9;
               // #endif

               // #if %EXTRAV2F5REQUIREKEY%
               // float4 extraV2F5 : TEXCOORD10;
               // #endif

               // #if %EXTRAV2F6REQUIREKEY%
               // float4 extraV2F6 : TEXCOORD11;
               // #endif

               // #if %EXTRAV2F7REQUIREKEY%
               // float4 extraV2F7 : TEXCOORD12;
               // #endif

               #if _HDRP && (_PASSMOTIONVECTOR || ((_PASSFORWARD || _PASSUNLIT) && defined(_WRITE_TRANSPARENT_MOTION_VECTOR)))
                  float3 previousPositionOS : TEXCOORD13; // Contain previous transform position (in case of skinning for example)
                  #if defined (_ADD_PRECOMPUTED_VELOCITY)
                     float3 precomputedVelocity : TEXCOORD14;
                  #endif
               #endif

               UNITY_VERTEX_INPUT_INSTANCE_ID
               UNITY_VERTEX_OUTPUT_STEREO
            };

            struct ExtraV2F
            {
               float4 extraV2F0;
               float4 extraV2F1;
               float4 extraV2F2;
               float4 extraV2F3;
               float4 extraV2F4;
               float4 extraV2F5;
               float4 extraV2F6;
               float4 extraV2F7;
               Blackboard blackboard;
               float4 time;
            };


            float3 WorldToTangentSpace(ShaderData d, float3 normal)
            {
               return mul(d.TBNMatrix, normal);
            }

            float3 TangentToWorldSpace(ShaderData d, float3 normal)
            {
               return mul(normal, d.TBNMatrix);
            }

            // in this case, make standard more like SRPs, because we can't fix
            // unity_WorldToObject in HDRP, since it already does macro-fu there

            #if _STANDARD
               float3 TransformWorldToObject(float3 p) { return mul(unity_WorldToObject, float4(p, 1)); };
               float3 TransformObjectToWorld(float3 p) { return mul(unity_ObjectToWorld, float4(p, 1)); };
               float4 TransformWorldToObject(float4 p) { return mul(unity_WorldToObject, p); };
               float4 TransformObjectToWorld(float4 p) { return mul(unity_ObjectToWorld, p); };
               float4x4 GetWorldToObjectMatrix() { return unity_WorldToObject; }
               float4x4 GetObjectToWorldMatrix() { return unity_ObjectToWorld; }
               #if (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (SHADER_TARGET_SURFACE_ANALYSIS && !SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))
                 #define UNITY_SAMPLE_TEX2D_LOD(tex,coord, lod) tex.SampleLevel (sampler##tex,coord, lod)
                 #define UNITY_SAMPLE_TEX2D_SAMPLER_LOD(tex,samplertex,coord, lod) tex.SampleLevel (sampler##samplertex,coord, lod)
              #else
                 #define UNITY_SAMPLE_TEX2D_LOD(tex,coord,lod) tex2D (tex,coord,0,lod)
                 #define UNITY_SAMPLE_TEX2D_SAMPLER_LOD(tex,samplertex,coord,lod) tex2D (tex,coord,0,lod)
              #endif

               #undef UNITY_MATRIX_I_M

               #define UNITY_MATRIX_I_M   unity_WorldToObject


            #endif

            float3 GetCameraWorldPosition()
            {
               #if _HDRP
                  return GetCameraRelativePositionWS(_WorldSpaceCameraPos);
               #else
                  return _WorldSpaceCameraPos;
               #endif
            }

            #if _GRABPASSUSED
               #if _STANDARD
                  TEXTURE2D(_Grab);
                  SAMPLER(sampler__Grab);
               #endif

               half3 GetSceneColor(float2 uv)
               {
                  #if _STANDARD
                     return SAMPLE_TEXTURE2D(_Grab, sampler__Grab, uv).rgb;
                  #else
                     return SHADERGRAPH_SAMPLE_SCENE_COLOR(uv);
                  #endif
               }
            #endif


      
            #if _STANDARD
               UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
               float GetSceneDepth(float2 uv) { return SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv); }
               float GetLinear01Depth(float2 uv) { return Linear01Depth(GetSceneDepth(uv)); }
               float GetLinearEyeDepth(float2 uv) { return LinearEyeDepth(GetSceneDepth(uv)); } 
            #else
               float GetSceneDepth(float2 uv) { return SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv); }
               float GetLinear01Depth(float2 uv) { return Linear01Depth(GetSceneDepth(uv), _ZBufferParams); }
               float GetLinearEyeDepth(float2 uv) { return LinearEyeDepth(GetSceneDepth(uv), _ZBufferParams); } 
            #endif

            float3 GetWorldPositionFromDepthBuffer(float2 uv, float3 worldSpaceViewDir)
            {
               float eye = GetLinearEyeDepth(uv);
               float3 camView = mul((float3x3)UNITY_MATRIX_M, transpose(mul(UNITY_MATRIX_I_M, UNITY_MATRIX_I_V)) [2].xyz);

               float dt = dot(worldSpaceViewDir, camView);
               float3 div = worldSpaceViewDir/dt;
               float3 wpos = (eye * div) + GetCameraWorldPosition();
               return wpos;
            }

            #if _HDRP
            float3 ObjectToWorldSpacePosition(float3 pos)
            {
               return GetAbsolutePositionWS(TransformObjectToWorld(pos));
            }
            #else
            float3 ObjectToWorldSpacePosition(float3 pos)
            {
               return TransformObjectToWorld(pos);
            }
            #endif

            #if _STANDARD
               UNITY_DECLARE_SCREENSPACE_TEXTURE(_CameraDepthNormalsTexture);
               float3 GetSceneNormal(float2 uv, float3 worldSpaceViewDir)
               {
                  float4 depthNorms = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_CameraDepthNormalsTexture, uv);
                  float3 norms = DecodeViewNormalStereo(depthNorms);
                  norms = mul((float3x3)UNITY_MATRIX_V, norms) * 0.5 + 0.5;
                  return norms;
               }
            #elif _HDRP
               float3 GetSceneNormal(float2 uv, float3 worldSpaceViewDir)
               {
                  NormalData nd;
                  DecodeFromNormalBuffer(_ScreenSize.xy * uv, nd);
                  return nd.normalWS;
               }
            #elif _URP
               #if (SHADER_LIBRARY_VERSION_MAJOR >= 10)
                  #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareNormalsTexture.hlsl"
               #endif

               float3 GetSceneNormal(float2 uv, float3 worldSpaceViewDir)
               {
                  #if (SHADER_LIBRARY_VERSION_MAJOR >= 10)
                     return SampleSceneNormals(uv);
                  #else
                     float3 wpos = GetWorldPositionFromDepthBuffer(uv, worldSpaceViewDir);
                     return normalize(-cross(ddx(wpos), ddy(wpos))) * 0.5 + 0.5;
                  #endif

                }
             #endif

             #if _HDRP

               half3 UnpackNormalmapRGorAG(half4 packednormal)
               {
                     // This do the trick
                  packednormal.x *= packednormal.w;

                  half3 normal;
                  normal.xy = packednormal.xy * 2 - 1;
                  normal.z = sqrt(1 - saturate(dot(normal.xy, normal.xy)));
                  return normal;
               }
               half3 UnpackNormal(half4 packednormal)
               {
                  #if defined(UNITY_NO_DXT5nm)
                     return packednormal.xyz * 2 - 1;
                  #else
                     return UnpackNormalmapRGorAG(packednormal);
                  #endif
               }
               #endif
               #if _HDRP || _URP

               half3 UnpackScaleNormal(half4 packednormal, half scale)
               {
                 #ifndef UNITY_NO_DXT5nm
                   // Unpack normal as DXT5nm (1, y, 1, x) or BC5 (x, y, 0, 1)
                   // Note neutral texture like "bump" is (0, 0, 1, 1) to work with both plain RGB normal and DXT5nm/BC5
                   packednormal.x *= packednormal.w;
                 #endif
                   half3 normal;
                   normal.xy = (packednormal.xy * 2 - 1) * scale;
                   normal.z = sqrt(1 - saturate(dot(normal.xy, normal.xy)));
                   return normal;
               }	

             #endif


            void GetSun(out float3 lightDir, out float3 color)
            {
               lightDir = float3(0.5, 0.5, 0);
               color = 1;
               #if _HDRP
                  if (_DirectionalLightCount > 0)
                  {
                     DirectionalLightData light = _DirectionalLightDatas[0];
                     lightDir = -light.forward.xyz;
                     color = light.color;
                  }
               #elif _STANDARD
			         lightDir = normalize(_WorldSpaceLightPos0.xyz);
                  color = _LightColor0.rgb;
               #elif _URP
	               Light light = GetMainLight();
	               lightDir = light.direction;
	               color = light.color;
               #endif
            }


            
         
	float    _FlowDensity;
	float2   _FlowSeparationXZ;
	float    _FlowSimulationHeight;
	float    _FlowCameraHeight;
	float2   _FlowCountXZ;
	float4   _FlowCoordU000;
	float4   _FlowCoord0V00;
	float    _FlowSpeed;
	float4x4 _FlowMatrix;

	float _Sink;


	float _WaveStrengthMin;
	float _WaveStrengthMax;
	float _WaveStrengthScale;

	float _Tiling;
	float _AnimationSpeed;
	float _FoamBrightness;


	half _FlatShadingBlend;


	float _RangeMax;
	float _AlphaStep;
	int _AlphaMaxSteps;
	float _AlphaDepthScale;





         

         

         
	TEXTURE2D(_FlowDataA);
	SAMPLER(sampler_FlowDataA);
	TEXTURE2D(_FlowDataB);
	SAMPLER(sampler_FlowDataB);
	TEXTURE2D(_FlowDataC);
	SAMPLER(sampler_FlowDataC);
	TEXTURE2D(_FlowDataD);
	SAMPLER(sampler_FlowDataD);
	TEXTURE2D(_FlowDataE);
	SAMPLER(sampler_FlowDataE);
	TEXTURE2D(_FlowDataF);
	SAMPLER(sampler_FlowDataF);

	float4 SGT_O2W(float4 v)
	{
		v = mul(UNITY_MATRIX_M, v);
		#if _HDRP
			v.xyz = GetAbsolutePositionWS(v.xyz);
		#endif
		return v;
	}

	float4 SGT_W2O(float4 v)
	{
		#if _HDRP
			v.xyz = GetCameraRelativePositionWS(v.xyz);
		#endif
		return mul(UNITY_MATRIX_I_M, v);
	}

	float4 SGT_O2V(float4 v)
	{
		#if _STANDARD
			return float4(UnityObjectToViewPos(v.xyz), 1.0f);
		#else
			return float4(TransformWorldToView(TransformObjectToWorld(v.xyz)), 1.0f);
		#endif
	}

	float GetFluidHeight(float2 uv)
	{
		float groundHeight = SAMPLE_TEXTURE2D_LOD(_FlowDataA, sampler_FlowDataA, uv, 0).r;
		float fluidDepth   = SAMPLE_TEXTURE2D_LOD(_FlowDataC, sampler_FlowDataC, uv, 0).r;

		return groundHeight + fluidDepth;
	}

	float2 GetHeightAndDepth(float2 uv)
	{
		float groundHeight = SAMPLE_TEXTURE2D_LOD(_FlowDataA, sampler_FlowDataA, uv, 0).r;
		float fluidDepth   = SAMPLE_TEXTURE2D_LOD(_FlowDataC, sampler_FlowDataC, uv, 0).r;

		return float2(groundHeight, fluidDepth);
	}

	Column GetColumn(float2 uv)
	{
		return DecodeColumn(SAMPLE_TEXTURE2D_LOD(_FlowDataA, sampler_FlowDataA, uv, 0), SAMPLE_TEXTURE2D_LOD(_FlowDataB, sampler_FlowDataB, uv, 0));
	}

	Fluid GetColumnFluid(float2 uv)
	{
		float4 c = SAMPLE_TEXTURE2D_LOD(_FlowDataC, sampler_FlowDataC, uv, 0);
		float4 d = SAMPLE_TEXTURE2D_LOD(_FlowDataD, sampler_FlowDataD, uv, 0);
		float4 e = SAMPLE_TEXTURE2D_LOD(_FlowDataE, sampler_FlowDataE, uv, 0);
		float4 f = SAMPLE_TEXTURE2D_LOD(_FlowDataF, sampler_FlowDataF, uv, 0);
		return DecodeFluid(c, d, e, f);
	}

	bool InsideFluid(float3 wpos)
	{
		float2 columnPixel = mul(_FlowMatrix, float4(wpos, 1.0f)).xy;
		float2 columnCoord = CoordFromPixel(columnPixel, _FlowCountXZ);
		float2 columnHAD   = GetHeightAndDepth(columnCoord);

		return min(columnCoord.x, columnCoord.y) >= 0.0 && max(columnCoord.x, columnCoord.y) <= 1.0f && wpos.y > columnHAD.x && wpos.y < (columnHAD.x + columnHAD.y);
	}

	bool UnderFluid(float3 wpos)
	{
		float2 columnPixel = mul(_FlowMatrix, float4(wpos, 1.0f)).xy;
		float2 columnCoord = CoordFromPixel(columnPixel, _FlowCountXZ);
		float2 columnHAD   = GetHeightAndDepth(columnCoord);

		return min(columnCoord.x, columnCoord.y) >= 0.0 && max(columnCoord.x, columnCoord.y) <= 1.0f && wpos.y < (columnHAD.x + columnHAD.y);
	}

	float RayMarchInside(float3 wpos, float3 wdir, float step, int maxs, float maxd)
	{
		float epsi = step * 0.01f;
		float dist = 0.0f;

		for (int i = 0; i < maxs && step > epsi; i++)
		{
			dist += step;

			float3 pos = wpos + wdir * dist;

			if (InsideFluid(pos) == false)
			{
				dist -= step;
				step *= 0.5f;
			}

			if (dist > maxd)
			{
				return maxd;
			}
		}

		return dist;
	}

	float RayMarchUnder(float3 wpos, float3 wdir, float step, int maxs, float maxd)
	{
		float epsi = step * 0.01f;
		float dist = 0.0f;

		for (int i = 0; i < maxs && step > epsi; i++)
		{
			dist += step;

			float3 pos = wpos + wdir * dist;

			if (UnderFluid(pos) == false)
			{
				dist -= step;
				step *= 0.5f;
			}

			if (dist > maxd)
			{
				return maxd;
			}
		}

		return dist;
	}

	void Ext_ModifyVertex0 (inout VertexData v, inout ExtraV2F e)
	{
		float4 wpos        = SGT_O2W(v.vertex);
		float2 columnPixel = mul(_FlowMatrix, float4(wpos.xyz, 1.0f)).xy;
		float2 columnCoord = SnapCoordFromPixel(round(columnPixel), _FlowCountXZ);

		Column column0 = GetColumn(columnCoord);
		Column columnL = GetColumn(columnCoord - _FlowCoordU000.xy);
		Column columnR = GetColumn(columnCoord + _FlowCoordU000.xy);
		Column columnB = GetColumn(columnCoord - _FlowCoord0V00.xy);
		Column columnT = GetColumn(columnCoord + _FlowCoord0V00.xy);

		Fluid fluid0 = GetColumnFluid(columnCoord);
		Fluid fluidL = GetColumnFluid(columnCoord - _FlowCoordU000.xy);
		Fluid fluidR = GetColumnFluid(columnCoord + _FlowCoordU000.xy);
		Fluid fluidB = GetColumnFluid(columnCoord - _FlowCoord0V00.xy);
		Fluid fluidT = GetColumnFluid(columnCoord + _FlowCoord0V00.xy);

		float ww = fluidL.Depth + fluidR.Depth + fluidB.Depth + fluidT.Depth + 0.001f;
		float wL = fluidL.Depth / ww;
		float wR = fluidR.Depth / ww;
		float wB = fluidB.Depth / ww;
		float wT = fluidT.Depth / ww;
		float w0 = saturate(fluid0.Depth * 10);

		float hL = columnL.GroundHeight + fluidL.Depth;
		float hR = columnR.GroundHeight + fluidR.Depth;
		float hB = columnB.GroundHeight + fluidB.Depth;
		float hT = columnT.GroundHeight + fluidT.Depth;
		float hh = hL * wL + hR * wR + hB * wB + hT * wT;
		float h0 = column0.GroundHeight + fluid0.Depth;

		hh = lerp(hh, h0 - _Sink, saturate(0.01f / ww)); // Prevent skirts going down too far

		Fluid fluid = fluid0;

		fluid.Depth = lerp(fluidL.Depth * wL + fluidR.Depth * wR + fluidB.Depth * wB + fluidT.Depth * wT, fluid.Depth, w0);
		fluid.RGBA  = lerp(fluidL.RGBA  * wL + fluidR.RGBA  * wR + fluidB.RGBA  * wB + fluidT.RGBA  * wT, fluid.RGBA , w0);
		fluid.ESMV  = lerp(fluidL.ESMV  * wL + fluidR.ESMV  * wR + fluidB.ESMV  * wB + fluidT.ESMV  * wT, fluid.ESMV , w0);
		fluid.F123  = lerp(fluidL.F123  * wL + fluidR.F123  * wR + fluidB.F123  * wB + fluidT.F123  * wT, fluid.F123 , w0);

		e.blackboard.groundHeight  = column0.GroundHeight;
		e.blackboard.surfaceHeight = lerp(hh, h0, w0);
		e.blackboard.surfaceNormal = normalize(float3((hL - hR) / _FlowSeparationXZ.x, 2.0f, (hB - hT) / _FlowSeparationXZ.y));
		e.blackboard.fluid         = fluid;
	}


	TEXTURE2D(_NoiseMap);
	SAMPLER(sampler_NoiseMap);

	TEXTURE2D(_NormalFoamMap);
	SAMPLER(sampler_NormalFoamMap);

	void Ext_ModifyVertex3 (inout VertexData v, inout ExtraV2F e)
	{
		v.vertex.y = lerp(e.blackboard.groundHeight, e.blackboard.surfaceHeight, v.texcoord0.w) - _FlowSimulationHeight;

		v.normal = lerp(e.blackboard.surfaceNormal, v.normal, v.texcoord0.z);

		v.vertexColor = e.blackboard.fluid.RGBA;

		e.extraV2F0.xyz = SGT_O2V(v.vertex).xyz;
		e.extraV2F0.w   = e.blackboard.fluid.Depth;

		e.extraV2F1.xyz = e.blackboard.fluid.ESMV.xyz;
		e.extraV2F1.w = e.blackboard.fluid.F123.x;
	}

	float3 FlowUVW(float2 uv, float2 flowVector, float2 jump, float tiling, float time, float phaseOffset)
	{
		float progress = frac(time + phaseOffset);
		float3 uvw;
		uvw.xy = uv - flowVector * (progress - 0.5f);
		uvw.xy *= tiling;
		uvw.xy += phaseOffset;
		uvw.xy += (time - progress) * jump;
		uvw.z = 1 - abs(1 - 2 * progress);
		return uvw;
	}

	float3 CombineNormals(float3 n1, float3 n2)
	{
		return normalize(half3(n1.xy + n2.xy, n1.z*n2.z));
	}

	float3 UnpackNormalAndScale(float2 xy, float scale)
	{
		xy = xy * 2.0f - 1.0f; xy *= scale; return float3(xy, sqrt(1.0 - saturate(dot(xy, xy))));
	}

	float4 SampleStochastic(float2 uv, float noise)
	{
		float cur_height = uv.y + noise;
		float this_index = floor(cur_height);
		float next_index = this_index + 1.0f;

		float2 uvA     = uv + sin(float2(1.0f, 2.0f) * this_index);
		float2 uvB     = uv + sin(float2(1.0f, 2.0f) * next_index);
		float2 gradX   = ddx(uv);
		float2 gradY   = ddy(uv);

		float4 sampleA = SAMPLE_TEXTURE2D_GRAD(_NormalFoamMap, sampler_NormalFoamMap, uvA, gradX, gradY);
		float4 sampleB = SAMPLE_TEXTURE2D_GRAD(_NormalFoamMap, sampler_NormalFoamMap, uvB, gradX, gradY);

		return lerp(sampleA, sampleB, cur_height - this_index);
	}

	void Ext_SurfaceFunction3 (inout Surface o, inout ShaderData d)
	{
		d.blackboard.fluid.RGBA     = d.vertexColor;
		d.blackboard.fluid.Depth    = d.extraV2F0.w;
		d.blackboard.fluid.ESMV.xyz = d.extraV2F1.xyz;
		d.blackboard.fluid.F123.x   = d.extraV2F1.w;

		if (d.blackboard.fluid.Depth < 0.01f)
		{
			discard;
		}

		float2 uv          = d.worldSpacePosition.xz;
		float2 columnPixel = mul(_FlowMatrix, float4(d.worldSpacePosition, 1.0f)).xy;
		float2 columnCoord = CoordFromPixel(columnPixel, _FlowCountXZ);
		Column column      = GetColumn(columnCoord);

		float  time = _Time.y * _AnimationSpeed;
		float2 jump = float2(0.13f, 0.17f);
		float2 fvec = (column.Outflow.yw - column.Outflow.xz) * _FlowSeparationXZ * _FlowSpeed;
		float  fmag = log10(1.0f + length(fvec)) * 0.1f;

		float3 flowA = FlowUVW(uv, fvec / _AnimationSpeed, jump, _Tiling, time, 0.0f);
		float3 flowB = FlowUVW(uv, fvec / _AnimationSpeed, jump, _Tiling, time, 0.5f);

		#if _STOCHASTIC_ON
			float  noise = SAMPLE_TEXTURE2D(_NoiseMap, sampler_NoiseMap, uv * 0.0025f).a * 4.0f;
			float4 nfmA  = SampleStochastic(flowA, noise);
			float4 nfmB  = SampleStochastic(flowB, noise);
		#else
			float4 nfmA = SAMPLE_TEXTURE2D(_NormalFoamMap, sampler_NormalFoamMap, flowA.xy);
			float4 nfmB = SAMPLE_TEXTURE2D(_NormalFoamMap, sampler_NormalFoamMap, flowB.xy);
		#endif

		// Water normals
		float  normalStr    = lerp(_WaveStrengthMin, _WaveStrengthMax, saturate(_WaveStrengthScale * fmag));
		float3 waterNormalA = UnpackNormalAndScale(nfmA.xy, flowA.z * normalStr);
		float3 waterNormalB = UnpackNormalAndScale(nfmB.xy, flowB.z * normalStr);
		float3 waterNormals = CombineNormals(waterNormalA, waterNormalB);

		o.Normal = lerp(waterNormals, o.Normal, d.texcoord0.z);
		o.Albedo = d.blackboard.fluid.RGBA.xyz;

		#if _FOAM_OFF
			d.blackboard.foam = 0.0f;
		#else
			d.blackboard.foam = d.blackboard.fluid.F123.x * (1.0f - d.texcoord0.z);

			#if _FOAM_ALPHA
				float3 foamAlbedo = (nfmA.w * flowA.z + nfmB.w * flowB.z) * _FoamBrightness;
			#elif _FOAM_CUTOUT
				float3 foamAlbedo = _FoamBrightness;
				float  foamRamp   = nfmA.w * flowA.z + nfmB.w * flowB.z;
				d.blackboard.foam = saturate((d.blackboard.foam - foamRamp) * 10.0f);
			#endif

			float3 foamNormal = float3(0.0f, 0.0f, 1.0f);

			o.Albedo = lerp(o.Albedo, foamAlbedo, d.blackboard.foam);
			o.Normal = lerp(o.Normal, foamNormal, d.blackboard.foam);
		#endif

		o.Smoothness = d.blackboard.fluid.ESMV.y;
		o.Metallic   = d.blackboard.fluid.ESMV.z;
	}


	void Ext_SurfaceFunction4 (inout Surface o, inout ShaderData d)
	{
	#if _FACETED_ON
		// lets just affect the TBN data, so we flat shade the original polygons, not the normal map
		float3 dx = ddx(d.worldSpacePosition);
		float3 dy = ddy(d.worldSpacePosition);
		float3 worldNormal = normalize(cross(dy, dx));
		worldNormal = lerp(d.worldSpaceNormal, worldNormal, _FlatShadingBlend);
		d.worldSpaceNormal = worldNormal;
		d.TBNMatrix[2] = worldNormal;
	#endif
	}


	void Ext_SurfaceFunction5 (inout Surface o, ShaderData d)
	{
		#if _ALPHA_OFF
		#else
			float3 position  = d.worldSpacePosition;
			float3 step      = d.worldSpacePosition - _WorldSpaceCameraPos;
			float2 bentScrUV = d.screenUV + o.Normal.xy * 0.05f * log(1.0f + d.blackboard.fluid.Depth * 1.0f);
			float  distMax   = max(_RangeMax * 0.001f, _RangeMax * (1.0f - d.blackboard.fluid.RGBA.w));
			float  distRange = distMax;
			float  vertDist  = length(d.extraV2F0.xyz);
			float  camtDist  = GetLinearEyeDepth(bentScrUV) * length(d.extraV2F0.xyz / d.extraV2F0.z);

			if (camtDist < vertDist)
			{
				camtDist = GetLinearEyeDepth(d.screenUV) * length(d.extraV2F0.xyz / d.extraV2F0.z);
			}

			float diffDist = max(0.0f, camtDist - vertDist);

			// The depth buffer becomes unusable at certain ranges, so fade it out
			diffDist += max(0.0f, camtDist * _AlphaDepthScale - _RangeMax);
			distRange = min(distRange, diffDist);

			#if _ALPHA_VERTICAL
				float dist = d.blackboard.fluid.Depth;
			#elif _ALPHA_DEPTH
				float dist = diffDist;
			#elif _ALPHA_MARCH_FLUID
				float dist = RayMarchInside(position, normalize(step), _AlphaStep, _AlphaMaxSteps, distMax);
			#elif _ALPHA_MARCH_FLUID_AND_DEPTH
				float dist = RayMarchInside(position, normalize(step), _AlphaStep, _AlphaMaxSteps, distRange);
			#endif

			// Set opacity based on distance through fluid relative to the maximum distance, and make sure high opacity fluids become solid
			float opacity = saturate(dist / distMax + d.blackboard.foam + pow(d.blackboard.fluid.RGBA.w, 10.0f));

			o.Albedo    = lerp(0.0f, o.Albedo, opacity);
			o.Emission  = lerp(GetSceneColor(bentScrUV), o.Emission, opacity);
			o.Emission += o.Albedo * d.blackboard.fluid.ESMV.x * opacity;
		#endif
	}





        
            void ChainSurfaceFunction(inout Surface l, inout ShaderData d)
            {
                 // Ext_SurfaceFunction0(l, d);
                 // Ext_SurfaceFunction1(l, d);
                 // Ext_SurfaceFunction2(l, d);
                  Ext_SurfaceFunction3(l, d);
                  Ext_SurfaceFunction4(l, d);
                  Ext_SurfaceFunction5(l, d);
                 // Ext_SurfaceFunction6(l, d);
                 // Ext_SurfaceFunction7(l, d);
                 // Ext_SurfaceFunction8(l, d);
                 // Ext_SurfaceFunction9(l, d);
		           // Ext_SurfaceFunction10(l, d);
                 // Ext_SurfaceFunction11(l, d);
                 // Ext_SurfaceFunction12(l, d);
                 // Ext_SurfaceFunction13(l, d);
                 // Ext_SurfaceFunction14(l, d);
                 // Ext_SurfaceFunction15(l, d);
                 // Ext_SurfaceFunction16(l, d);
                 // Ext_SurfaceFunction17(l, d);
                 // Ext_SurfaceFunction18(l, d);
		           // Ext_SurfaceFunction19(l, d);
                 // Ext_SurfaceFunction20(l, d);
                 // Ext_SurfaceFunction21(l, d);
                 // Ext_SurfaceFunction22(l, d);
                 // Ext_SurfaceFunction23(l, d);
                 // Ext_SurfaceFunction24(l, d);
                 // Ext_SurfaceFunction25(l, d);
                 // Ext_SurfaceFunction26(l, d);
                 // Ext_SurfaceFunction27(l, d);
                 // Ext_SurfaceFunction28(l, d);
		           // Ext_SurfaceFunction29(l, d);
            }

            void ChainModifyVertex(inout VertexData v, inout VertexToPixel v2p, float4 time)
            {
                 ExtraV2F d;
                 
                 ZERO_INITIALIZE(ExtraV2F, d);
                 ZERO_INITIALIZE(Blackboard, d.blackboard);
                 // due to motion vectors in HDRP, we need to use the last
                 // time in certain spots. So if you are going to use _Time to adjust vertices,
                 // you need to use this time or motion vectors will break. 
                 d.time = time;

                   Ext_ModifyVertex0(v, d);
                 // Ext_ModifyVertex1(v, d);
                 // Ext_ModifyVertex2(v, d);
                  Ext_ModifyVertex3(v, d);
                 // Ext_ModifyVertex4(v, d);
                 // Ext_ModifyVertex5(v, d);
                 // Ext_ModifyVertex6(v, d);
                 // Ext_ModifyVertex7(v, d);
                 // Ext_ModifyVertex8(v, d);
                 // Ext_ModifyVertex9(v, d);
                 // Ext_ModifyVertex10(v, d);
                 // Ext_ModifyVertex11(v, d);
                 // Ext_ModifyVertex12(v, d);
                 // Ext_ModifyVertex13(v, d);
                 // Ext_ModifyVertex14(v, d);
                 // Ext_ModifyVertex15(v, d);
                 // Ext_ModifyVertex16(v, d);
                 // Ext_ModifyVertex17(v, d);
                 // Ext_ModifyVertex18(v, d);
                 // Ext_ModifyVertex19(v, d);
                 // Ext_ModifyVertex20(v, d);
                 // Ext_ModifyVertex21(v, d);
                 // Ext_ModifyVertex22(v, d);
                 // Ext_ModifyVertex23(v, d);
                 // Ext_ModifyVertex24(v, d);
                 // Ext_ModifyVertex25(v, d);
                 // Ext_ModifyVertex26(v, d);
                 // Ext_ModifyVertex27(v, d);
                 // Ext_ModifyVertex28(v, d);
                 // Ext_ModifyVertex29(v, d);


                 // #if %EXTRAV2F0REQUIREKEY%
                  v2p.extraV2F0 = d.extraV2F0;
                 // #endif

                 // #if %EXTRAV2F1REQUIREKEY%
                  v2p.extraV2F1 = d.extraV2F1;
                 // #endif

                 // #if %EXTRAV2F2REQUIREKEY%
                 // v2p.extraV2F2 = d.extraV2F2;
                 // #endif

                 // #if %EXTRAV2F3REQUIREKEY%
                 // v2p.extraV2F3 = d.extraV2F3;
                 // #endif

                 // #if %EXTRAV2F4REQUIREKEY%
                 // v2p.extraV2F4 = d.extraV2F4;
                 // #endif

                 // #if %EXTRAV2F5REQUIREKEY%
                 // v2p.extraV2F5 = d.extraV2F5;
                 // #endif

                 // #if %EXTRAV2F6REQUIREKEY%
                 // v2p.extraV2F6 = d.extraV2F6;
                 // #endif

                 // #if %EXTRAV2F7REQUIREKEY%
                 // v2p.extraV2F7 = d.extraV2F7;
                 // #endif
            }

            void ChainModifyTessellatedVertex(inout VertexData v, inout VertexToPixel v2p)
            {
               ExtraV2F d;
               ZERO_INITIALIZE(ExtraV2F, d);
               ZERO_INITIALIZE(Blackboard, d.blackboard);

               // #if %EXTRAV2F0REQUIREKEY%
                d.extraV2F0 = v2p.extraV2F0;
               // #endif

               // #if %EXTRAV2F1REQUIREKEY%
                d.extraV2F1 = v2p.extraV2F1;
               // #endif

               // #if %EXTRAV2F2REQUIREKEY%
               // d.extraV2F2 = v2p.extraV2F2;
               // #endif

               // #if %EXTRAV2F3REQUIREKEY%
               // d.extraV2F3 = v2p.extraV2F3;
               // #endif

               // #if %EXTRAV2F4REQUIREKEY%
               // d.extraV2F4 = v2p.extraV2F4;
               // #endif

               // #if %EXTRAV2F5REQUIREKEY%
               // d.extraV2F5 = v2p.extraV2F5;
               // #endif

               // #if %EXTRAV2F6REQUIREKEY%
               // d.extraV2F6 = v2p.extraV2F6;
               // #endif

               // #if %EXTRAV2F7REQUIREKEY%
               // d.extraV2F7 = v2p.extraV2F7;
               // #endif


               // Ext_ModifyTessellatedVertex0(v, d);
               // Ext_ModifyTessellatedVertex1(v, d);
               // Ext_ModifyTessellatedVertex2(v, d);
               // Ext_ModifyTessellatedVertex3(v, d);
               // Ext_ModifyTessellatedVertex4(v, d);
               // Ext_ModifyTessellatedVertex5(v, d);
               // Ext_ModifyTessellatedVertex6(v, d);
               // Ext_ModifyTessellatedVertex7(v, d);
               // Ext_ModifyTessellatedVertex8(v, d);
               // Ext_ModifyTessellatedVertex9(v, d);
               // Ext_ModifyTessellatedVertex10(v, d);
               // Ext_ModifyTessellatedVertex11(v, d);
               // Ext_ModifyTessellatedVertex12(v, d);
               // Ext_ModifyTessellatedVertex13(v, d);
               // Ext_ModifyTessellatedVertex14(v, d);
               // Ext_ModifyTessellatedVertex15(v, d);
               // Ext_ModifyTessellatedVertex16(v, d);
               // Ext_ModifyTessellatedVertex17(v, d);
               // Ext_ModifyTessellatedVertex18(v, d);
               // Ext_ModifyTessellatedVertex19(v, d);
               // Ext_ModifyTessellatedVertex20(v, d);
               // Ext_ModifyTessellatedVertex21(v, d);
               // Ext_ModifyTessellatedVertex22(v, d);
               // Ext_ModifyTessellatedVertex23(v, d);
               // Ext_ModifyTessellatedVertex24(v, d);
               // Ext_ModifyTessellatedVertex25(v, d);
               // Ext_ModifyTessellatedVertex26(v, d);
               // Ext_ModifyTessellatedVertex27(v, d);
               // Ext_ModifyTessellatedVertex28(v, d);
               // Ext_ModifyTessellatedVertex29(v, d);

               // #if %EXTRAV2F0REQUIREKEY%
                v2p.extraV2F0 = d.extraV2F0;
               // #endif

               // #if %EXTRAV2F1REQUIREKEY%
                v2p.extraV2F1 = d.extraV2F1;
               // #endif

               // #if %EXTRAV2F2REQUIREKEY%
               // v2p.extraV2F2 = d.extraV2F2;
               // #endif

               // #if %EXTRAV2F3REQUIREKEY%
               // v2p.extraV2F3 = d.extraV2F3;
               // #endif

               // #if %EXTRAV2F4REQUIREKEY%
               // v2p.extraV2F4 = d.extraV2F4;
               // #endif

               // #if %EXTRAV2F5REQUIREKEY%
               // v2p.extraV2F5 = d.extraV2F5;
               // #endif

               // #if %EXTRAV2F6REQUIREKEY%
               // v2p.extraV2F6 = d.extraV2F6;
               // #endif

               // #if %EXTRAV2F7REQUIREKEY%
               // v2p.extraV2F7 = d.extraV2F7;
               // #endif
            }

            void ChainFinalColorForward(inout Surface l, inout ShaderData d, inout half4 color)
            {
               //   Ext_FinalColorForward0(l, d, color);
               //   Ext_FinalColorForward1(l, d, color);
               //   Ext_FinalColorForward2(l, d, color);
               //   Ext_FinalColorForward3(l, d, color);
               //   Ext_FinalColorForward4(l, d, color);
               //   Ext_FinalColorForward5(l, d, color);
               //   Ext_FinalColorForward6(l, d, color);
               //   Ext_FinalColorForward7(l, d, color);
               //   Ext_FinalColorForward8(l, d, color);
               //   Ext_FinalColorForward9(l, d, color);
               //  Ext_FinalColorForward10(l, d, color);
               //  Ext_FinalColorForward11(l, d, color);
               //  Ext_FinalColorForward12(l, d, color);
               //  Ext_FinalColorForward13(l, d, color);
               //  Ext_FinalColorForward14(l, d, color);
               //  Ext_FinalColorForward15(l, d, color);
               //  Ext_FinalColorForward16(l, d, color);
               //  Ext_FinalColorForward17(l, d, color);
               //  Ext_FinalColorForward18(l, d, color);
               //  Ext_FinalColorForward19(l, d, color);
               //  Ext_FinalColorForward20(l, d, color);
               //  Ext_FinalColorForward21(l, d, color);
               //  Ext_FinalColorForward22(l, d, color);
               //  Ext_FinalColorForward23(l, d, color);
               //  Ext_FinalColorForward24(l, d, color);
               //  Ext_FinalColorForward25(l, d, color);
               //  Ext_FinalColorForward26(l, d, color);
               //  Ext_FinalColorForward27(l, d, color);
               //  Ext_FinalColorForward28(l, d, color);
               //  Ext_FinalColorForward29(l, d, color);
            }

            void ChainFinalGBufferStandard(inout Surface s, inout ShaderData d, inout half4 GBuffer0, inout half4 GBuffer1, inout half4 GBuffer2, inout half4 outEmission, inout half4 outShadowMask)
            {
               //   Ext_FinalGBufferStandard0(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //   Ext_FinalGBufferStandard1(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //   Ext_FinalGBufferStandard2(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //   Ext_FinalGBufferStandard3(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //   Ext_FinalGBufferStandard4(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //   Ext_FinalGBufferStandard5(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //   Ext_FinalGBufferStandard6(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //   Ext_FinalGBufferStandard7(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //   Ext_FinalGBufferStandard8(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //   Ext_FinalGBufferStandard9(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard10(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard11(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard12(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard13(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard14(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard15(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard16(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard17(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard18(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard19(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard20(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard21(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard22(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard23(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard24(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard25(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard26(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard27(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard28(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
               //  Ext_FinalGBufferStandard29(s, d, GBuffer0, GBuffer1, GBuffer2, outEmission, outShadowMask);
            }



         

         ShaderData CreateShaderData(VertexToPixel i
                  #if NEED_FACING
                     , bool facing
                  #endif
         )
         {
            ShaderData d = (ShaderData)0;
            d.clipPos = i.pos;
            d.worldSpacePosition = i.worldPos;

            d.worldSpaceNormal = normalize(i.worldNormal);
            d.worldSpaceTangent = normalize(i.worldTangent.xyz);
            d.tangentSign = i.worldTangent.w;
            float3 bitangent = cross(i.worldTangent.xyz, i.worldNormal) * d.tangentSign * -1;
            

            d.TBNMatrix = float3x3(d.worldSpaceTangent, bitangent, d.worldSpaceNormal);
            d.worldSpaceViewDir = normalize(_WorldSpaceCameraPos - i.worldPos);

            d.tangentSpaceViewDir = mul(d.TBNMatrix, d.worldSpaceViewDir);
             d.texcoord0 = i.texcoord0;
            // d.texcoord1 = i.texcoord1;
            // d.texcoord2 = i.texcoord2;

            // #if %TEXCOORD3REQUIREKEY%
            // d.texcoord3 = i.texcoord3;
            // #endif

            // d.isFrontFace = facing;
            // #if %VERTEXCOLORREQUIREKEY%
             d.vertexColor = i.vertexColor;
            // #endif

            // these rarely get used, so we back transform them. Usually will be stripped.
            #if _HDRP
                // d.localSpacePosition = mul(unity_WorldToObject, float4(GetCameraRelativePositionWS(i.worldPos), 1)).xyz;
            #else
                // d.localSpacePosition = mul(unity_WorldToObject, float4(i.worldPos, 1)).xyz;
            #endif
            // d.localSpaceNormal = normalize(mul((float3x3)unity_WorldToObject, i.worldNormal));
            // d.localSpaceTangent = normalize(mul((float3x3)unity_WorldToObject, i.worldTangent.xyz));

            // #if %SCREENPOSREQUIREKEY%
             d.screenPos = i.screenPos;
             d.screenUV = (i.screenPos.xy / i.screenPos.w);
            // #endif


            // #if %EXTRAV2F0REQUIREKEY%
             d.extraV2F0 = i.extraV2F0;
            // #endif

            // #if %EXTRAV2F1REQUIREKEY%
             d.extraV2F1 = i.extraV2F1;
            // #endif

            // #if %EXTRAV2F2REQUIREKEY%
            // d.extraV2F2 = i.extraV2F2;
            // #endif

            // #if %EXTRAV2F3REQUIREKEY%
            // d.extraV2F3 = i.extraV2F3;
            // #endif

            // #if %EXTRAV2F4REQUIREKEY%
            // d.extraV2F4 = i.extraV2F4;
            // #endif

            // #if %EXTRAV2F5REQUIREKEY%
            // d.extraV2F5 = i.extraV2F5;
            // #endif

            // #if %EXTRAV2F6REQUIREKEY%
            // d.extraV2F6 = i.extraV2F6;
            // #endif

            // #if %EXTRAV2F7REQUIREKEY%
            // d.extraV2F7 = i.extraV2F7;
            // #endif

            return d;
         }
         

         // vertex shader
         VertexToPixel Vert (VertexData v)
         {
            UNITY_SETUP_INSTANCE_ID(v);
            VertexToPixel o;
            UNITY_INITIALIZE_OUTPUT(VertexToPixel,o);
            UNITY_TRANSFER_INSTANCE_ID(v,o);
            UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

#if !_TESSELLATION_ON
           ChainModifyVertex(v, o, _Time);
#endif


            o.pos = UnityMetaVertexPosition(v.vertex, v.texcoord1.xy, v.texcoord2.xy, unity_LightmapST, unity_DynamicLightmapST);
            #ifdef EDITOR_VISUALIZATION
               o.vizUV = 0;
               o.lightCoord = 0;
               if (unity_VisualizationMode == EDITORVIZ_TEXTURE)
                  o.vizUV = UnityMetaVizUV(unity_EditorViz_UVIndex, v.texcoord0.xy, v.texcoord1.xy, v.texcoord2.xy, unity_EditorViz_Texture_ST);
               else if (unity_VisualizationMode == EDITORVIZ_SHOWLIGHTMASK)
               {
                  o.vizUV = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                  o.lightCoord = mul(unity_EditorViz_WorldToLight, mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1)));
               }
            #endif


             o.texcoord0 = v.texcoord0;
            // o.texcoord1 = v.texcoord1;
            // o.texcoord2 = v.texcoord2;

            // #if %TEXCOORD3REQUIREKEY%
            // o.texcoord3 = v.texcoord3;
            // #endif

            // #if %VERTEXCOLORREQUIREKEY%
             o.vertexColor = v.vertexColor;
            // #endif

            // #if %SCREENPOSREQUIREKEY%
             o.screenPos = ComputeScreenPos(o.pos);
            // #endif

            o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
            o.worldNormal = UnityObjectToWorldNormal(v.normal);
            o.worldTangent.xyz = UnityObjectToWorldDir(v.tangent.xyz);
            fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
            o.worldTangent.w = tangentSign;

            return o;
         }

         

         // fragment shader
         fixed4 Frag (VertexToPixel IN
         #if NEED_FACING
            , bool facing : SV_IsFrontFace
         #endif
         ) : SV_Target
         {
            UNITY_SETUP_INSTANCE_ID(IN);

            #ifdef FOG_COMBINED_WITH_TSPACE
               UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
            #elif defined (FOG_COMBINED_WITH_WORLD_POS)
               UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
            #else
               UNITY_EXTRACT_FOG(IN);
            #endif

            ShaderData d = CreateShaderData(IN
               #if NEED_FACING
                 , facing
              #endif
            );

            Surface l = (Surface)0;

            l.Albedo = half3(0.5, 0.5, 0.5);
            l.Normal = float3(0,0,1);
            l.Occlusion = 1;
            l.Alpha = 1;

            
            ChainSurfaceFunction(l, d);

            UnityMetaInput metaIN;
            UNITY_INITIALIZE_OUTPUT(UnityMetaInput, metaIN);
            metaIN.Albedo = l.Albedo;
            metaIN.Emission = l.Emission;
          
            #if _USESPECULAR
               metaIN.SpecularColor = l.Specular;
            #endif

            #ifdef EDITOR_VISUALIZATION
              metaIN.VizUV = IN.vizUV;
              metaIN.LightCoord = IN.lightCoord;
            #endif
            return UnityMetaFragment(metaIN);
         }
         ENDCG

      }

      











   }
   
   
   
}
