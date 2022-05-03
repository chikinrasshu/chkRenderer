//
//  Renderable.swift
//  chkRenderer
//
//  Created by Jorge Botarro on 01-05-22.
//

import Metal
import MetalKit

protocol Renderable {
    var renderPipelineState: MTLRenderPipelineState! { get set }
    
    var vertexFunctionName: String { get set }
    var fragmentFunctionName: String { get set }
    
    func draw(renderEncoder: MTLRenderCommandEncoder)
}

extension Renderable {
    
    func buildRenderPipeline(device: MTLDevice) throws -> MTLRenderPipelineState {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        
        pipelineDescriptor.vertexFunction = Renderer.library?.makeFunction(name: "basicVertexFunc")
        pipelineDescriptor.fragmentFunction = Renderer.library?.makeFunction(name: "basicFragmentFunc")
        pipelineDescriptor.colorAttachments[0].pixelFormat = Renderer.pixelFormat!
        pipelineDescriptor.depthAttachmentPixelFormat = Renderer.depthFormat!
        
        return try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
}
