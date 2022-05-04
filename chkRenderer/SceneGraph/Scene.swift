//
//  Scene.swift
//  chkRenderer
//
//  Created by Jorge Botarro on 02-05-22.
//

import Metal
import MetalKit

class Scene: Node {
    var device: MTLDevice
    var uniforms: SceneUniforms
    var camera: Camera
    
    override init(device: MTLDevice, name: String = "", parent: Node? = nil) {
        self.device = device
        uniforms = SceneUniforms()
        
        camera = Camera(device: device, name: "")
        
        super.init(device: device, name: name, parent: parent)
        add(child: camera)
    }
    
    override func render(renderEncoder: MTLRenderCommandEncoder) {
        // Setup the scene
        uniforms.view = camera.globalTransform.inverse
        uniforms.projection = camera.projection
        renderEncoder.setVertexBytes(&uniforms, length: MemoryLayout<SceneUniforms>.size, index: 2)
        
        // Render the scene!
        camera.render(renderEncoder: renderEncoder)
        super.render(renderEncoder: renderEncoder)
    }
    
}
