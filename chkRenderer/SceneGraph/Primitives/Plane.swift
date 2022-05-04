//
//  Plane.swift
//  chkRenderer
//
//  Created by Jorge Botarro on 02-05-22.
//

import Metal
import MetalKit

class Plane: Primitive {
    
    override func buildVertices() {
        let s: Float = 0.5
        vertices = [
            Vertex(pos: [-s, -s,  0], uv: [0.0, 0.0]),
            Vertex(pos: [-s,  s,  0], uv: [0.0, 1.0]),
            Vertex(pos: [ s, -s,  0], uv: [1.0, 0.0]),
            Vertex(pos: [ s,  s,  0], uv: [1.0, 1.0]),
        ]
        
        indices = [
            0, 2, 3,
            0, 3, 1
        ]
    }
    
}
