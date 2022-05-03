//
//  Primitive.swift
//  chkRenderer
//
//  Created by Jorge Botarro on 01-05-22.
//

import Metal
import MetalKit

// A node that's made of vertices
class Primitive: Node {
    var renderPipelineState: MTLRenderPipelineState!
    var vertexDescriptor: MTLVertexDescriptor!
    
    var vertices: [Vertex] = []
    var indices: [UInt16] = []
    var texture: MTLTexture?
    var uniforms = ModelUniforms()
    
    var vertexBuffer: MTLBuffer!
    var indexBuffer: MTLBuffer!
    
    var vertexFunctionName: String = "basicVertexFunc"
    var fragmentFunctionName: String = "basicFragmentFunc"
    
    init(device: MTLDevice, name: String, texName: String = "", parent: Node? = nil) {
        super.init(device: device, name: name, parent: parent)
        uniforms.color = [1, 1, 1, 1]
        
        if let tmpTexture = setTexture(device: device, imageName: texName) {
            texture = tmpTexture
            fragmentFunctionName = "basicTexturedFragmentFunc"
        }
        
        buildVertices()
        buildBuffers(device: device)
        do { renderPipelineState = try buildRenderPipeline(device: device) }
        catch { renderPipelineState = nil }
        
    }
    
    func buildVertices() {
        // Override me!
    }
    
    func buildBuffers(device: MTLDevice) {
        vertexBuffer = device.makeBuffer(bytes: vertices,
                                         length: MemoryLayout<Vertex>.stride * vertices.count,
                                         options: [])!
        indexBuffer = device.makeBuffer(bytes: indices,
                                        length: MemoryLayout<UInt16>.size * indices.count,
                                        options: [])!
    }
}

extension Primitive: Renderable, Texturable {
    
    func draw(renderEncoder: MTLRenderCommandEncoder) {
        
        // Draw all the childs first
        for child in children {
            if let renderableChild = child as? Renderable {
                renderableChild.draw(renderEncoder: renderEncoder)
            }
        }
        
        // Now draw ourselves
        if vertices.count > 0 {
            uniforms.modelView = globalTransform
            
            renderEncoder.setRenderPipelineState(renderPipelineState)
            renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            renderEncoder.setVertexBytes(&uniforms, length: MemoryLayout<ModelUniforms>.size, index: 1)
            
            renderEncoder.drawIndexedPrimitives(type: .triangle,
                                                indexCount: indices.count, indexType: .uint16,
                                                indexBuffer: indexBuffer, indexBufferOffset: 0)
        }
    }
    
}
