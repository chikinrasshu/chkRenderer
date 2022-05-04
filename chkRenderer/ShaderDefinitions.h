//
//  ShaderDefinitions.h
//  chkRenderer
//
//  Created by Jorge Botarro on 01-05-22.
//

#ifndef ShaderDefinitions_h
#define ShaderDefinitions_h

#include <simd/simd.h>

struct Vertex {
    simd_float3 pos;
    simd_float2 uv;
};

struct ModelUniforms {
    simd_float4x4 model;
    simd_float4 color;
};

struct SceneUniforms {
    simd_float4x4 view;
    simd_float4x4 projection;
};

struct BasicUniforms {
    float brightness;
};

#endif /* ShaderDefinitions_h */
