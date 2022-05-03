//
//  Cube.swift
//  chkRenderer
//
//  Created by Jorge Botarro on 02-05-22.
//

import Metal
import MetalKit

class Cube: Primitive {
    
    override func buildVertices() {
        let s: Float = 0.5
        
        vertices = [
            Vertex(pos: [-s, -s, -s], color: [1, 0, 0, 1], uv: [0.0, 0.0]),
            Vertex(pos: [ s, -s, -s], color: [1, 1, 0, 1], uv: [0.0, 0.0]),
            Vertex(pos: [ s,  s, -s], color: [1, 0, 1, 1], uv: [0.0, 0.0]),
            Vertex(pos: [-s,  s, -s], color: [0, 0, 0, 1], uv: [0.0, 0.0]),
            
            Vertex(pos: [-s, -s,  s], color: [1, 1, 0, 1], uv: [0.0, 0.0]),
            Vertex(pos: [ s, -s,  s], color: [1, 0, 1, 1], uv: [0.0, 0.0]),
            Vertex(pos: [ s,  s,  s], color: [0, 1, 1, 1], uv: [0.0, 0.0]),
            Vertex(pos: [-s,  s,  s], color: [1, 1, 1, 1], uv: [0.0, 0.0]),
        ]
        
        indices = [
            0, 1, 3,  3, 1, 2,
            1, 5, 2,  2, 5, 6,
            5, 4, 6,  6, 4, 7,
            4, 0, 7,  7, 0, 3,
            3, 2, 7,  7, 2, 6,
            4, 5, 0,  0, 5, 1
        ]
    }
    
}
