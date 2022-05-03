//
//  Camera.swift
//  chkRenderer
//
//  Created by Jorge Botarro on 02-05-22.
//

import Metal
import MetalKit

class Camera: Node {
    var fov: Float = 45
    var nearZ: Float = 0.01, farZ: Float = 100.0
    var projection: matrix_float4x4 {
        let projection = matrix_float4x4(perspectiveFOV: fov,
                                         aspectRatio: Renderer.aspectRatio,
                                         nearZ: nearZ, farZ: farZ)
        return projection
    }
}
