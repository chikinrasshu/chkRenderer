//
//  CubeBodyPiece.swift
//  chkRenderer
//
//  Created by Jorge Botarro on 04-05-22.
//

import Metal
import MetalKit

class CubeBodyPiece: Primitive {
    
    override func buildVertices() {
        let s: Float = 0.5
        let s2: Float = 2.0 * s
        
        let tex00: simd_float2 = [0, 0]
        let tex01: simd_float2 = [0, 1]
        let tex10: simd_float2 = [1, 0]
        let tex11: simd_float2 = [1, 1]
        
        let a: simd_float3 = [-s, +0, -s]
        let b: simd_float3 = [+s, +0, -s]
        let c: simd_float3 = [+s, +0, +s]
        let d: simd_float3 = [-s, +0, +s]
        
        let e: simd_float3 = [-s, s2, -s]
        let f: simd_float3 = [+s, s2, -s]
        let g: simd_float3 = [+s, s2, +s]
        let h: simd_float3 = [-s, s2, +s]
        
        vertices = [
            // Front
            Vertex(pos: a, uv: tex00),
            Vertex(pos: b, uv: tex10),
            Vertex(pos: f, uv: tex11),
            Vertex(pos: e, uv: tex01),
            
            // Right
            Vertex(pos: b, uv: tex00),
            Vertex(pos: c, uv: tex10),
            Vertex(pos: g, uv: tex11),
            Vertex(pos: f, uv: tex01),
            
            // Back
            Vertex(pos: c, uv: tex00),
            Vertex(pos: d, uv: tex10),
            Vertex(pos: h, uv: tex11),
            Vertex(pos: g, uv: tex01),
            
            // Left
            Vertex(pos: d, uv: tex00),
            Vertex(pos: a, uv: tex10),
            Vertex(pos: e, uv: tex11),
            Vertex(pos: h, uv: tex01),
            
            // Bottom
            Vertex(pos: d, uv: tex00),
            Vertex(pos: c, uv: tex10),
            Vertex(pos: b, uv: tex11),
            Vertex(pos: a, uv: tex01),
            
            // Top
            Vertex(pos: e, uv: tex00),
            Vertex(pos: f, uv: tex10),
            Vertex(pos: g, uv: tex11),
            Vertex(pos: h, uv: tex01),
        ]
        
        indices = [
              0, 1, 2,  0, 2, 3, // Front
              4, 5, 6,  4, 6, 7, // Right
              8, 9,10,  8,10,11, // Back
             12,13,14, 12,14,15, // Left
             16,17,18, 16,18,19, // Bottom
             20,21,22, 20,22,23  // Top
        ]
    }
    
}
