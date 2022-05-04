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
    var projection = matrix_identity_float4x4
    var isPerspective = true
    
    override init(device: MTLDevice, name: String = "", parent: Node? = nil) {
        var finalName: String
        if name == "" {
            if parent != nil {
                finalName = parent!.name + "'s Camera"
            } else {
                finalName = "Camera"
            }
        } else {
            finalName = name
        }
        
        super.init(device: device, name: finalName, parent: parent)
        
        updateMatrix()
    }
    
    func updateMatrix() {
        if (isPerspective) { setPerspective() }
        // else { setOrthographic() }
    }
    
    func setPerspective() {
        projection = matrix_float4x4(perspectiveFOV: fov,
                                     aspectRatio: Renderer.aspectRatio,
                                     nearZ: nearZ, farZ: farZ)
    }
    
    func setOrthographic() {
        let w = Renderer.width
        let h = Renderer.height
        projection = matrix_float4x4(nearZ: nearZ, farZ: farZ,
                                     left: 0, right: w,
                                     top: 0, bottom: h)
    }
    
}
