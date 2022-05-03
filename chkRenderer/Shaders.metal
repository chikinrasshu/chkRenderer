//
//  Shaders.metal
//  chkRenderer
//
//  Created by Jorge Botarro on 01-05-22.
//

#include <metal_stdlib>
using namespace metal;

#include "ShaderDefinitions.h"

struct VertexOut {
    float4 pos [[position]];
    float4 color;
    float2 uv;
};

vertex VertexOut basicVertexFunc(const device Vertex* vertices [[buffer(0)]],
                                 unsigned int vID [[vertex_id]],
                                 constant ModelUniforms& mU [[buffer(1)]],
                                 constant SceneUniforms& sU [[buffer(2)]]) {
    
    Vertex v = vertices[vID];
    VertexOut vOut;
    
    float4x4 mvp = sU.projection * mU.modelView;
    
    vOut.pos = mvp * float4(v.pos, 1);
    vOut.color = v.color * mU.color;
    vOut.uv = v.uv;
    
    return vOut;
}

fragment float4 basicFragmentFunc(VertexOut interpolated [[stage_in]],
                                  constant BasicUniforms& uniforms [[buffer(0)]]) {
    
    float4 color = float4(uniforms.brightness * interpolated.color.rgb, interpolated.color.a);
    
    return color;
}

fragment float4 basicTexturedFragmentFunc(VertexOut interpolated [[stage_in]],
                                          constant BasicUniforms& uniforms [[buffer(0)]],
                                          sampler sampler2d [[sampler(0)]],
                                          texture2d<float> texture [[texture(0)]]) {
    
    float4 texColor = texture.sample(sampler2d, interpolated.uv);
    float4 baseColor = float4(uniforms.brightness * interpolated.color.rgb, interpolated.color.a);
    
    return baseColor * texColor;
}
