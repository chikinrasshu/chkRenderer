//
//  Triangle.swift
//  chkRenderer
//
//  Created by Jorge Botarro on 02-05-22.
//

import Metal
import MetalKit

// Simple unit-length equilateral triangle centered around the origin
class Triangle: Primitive {
    override func buildVertices() {
        let yTop: Float = sqrt(3.0) / 3.0
        let yBot: Float = -sqrt(3.0) / 6.0
        
        vertices = [
            Vertex(pos: [-0.5, yBot, 0], uv: [0.0, 0.0]),
            Vertex(pos: [   0, yTop, 0], uv: [0.5, 1.0]),
            Vertex(pos: [ 0.5, yBot, 0], uv: [1.0, 0.0]),
        ]
        
        indices = [
            0, 1, 2
        ]
    }
}
