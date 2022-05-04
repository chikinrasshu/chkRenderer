//
//  Node.swift
//  chkRenderer
//
//  Created by Jorge Botarro on 01-05-22.
//

import Foundation
import Metal

class Node {
    var name: String
    var parent: Node?
    var children: [Node] = []
    
    var localTransform: matrix_float4x4 {
        var matrix = matrix_identity_float4x4
        
        matrix.translate(axis: position)
        
        matrix.rotate(axis: [1, 0, 0], angle: rotation.x)
        matrix.rotate(axis: [0, 1, 0], angle: rotation.y)
        matrix.rotate(axis: [0, 0, 1], angle: rotation.z)
        
        matrix.scale(axis: scale)
        
        return matrix
    }
    var globalTransform = matrix_identity_float4x4
    
    var position: SIMD3<Float> = [0, 0, 0]
    var rotation: SIMD3<Float> = [0, 0, 0]
    var scale: SIMD3<Float> = [1, 1, 1]
    var color: SIMD4<Float> = [1, 1, 1, 1]
    
    init(device: MTLDevice, name: String = "", parent: Node? = nil) {
        self.name = name == "" ? "Node" : name
        self.parent = parent
    }
    
    func add(child: Node) {
        children.append(child)
        child.parent = self
    }
    
    func get(index: Int) -> Node? {
        var result: Node? = nil;
        
        if (index >= 0 && index < children.count) {
            result = children[index]
        }
        
        return result
    }
    
    func find(name: String) -> Node? {
        var result: Node? = nil
        
        for child in children {
            if child.name == name {
                result = child
                break
            }
        }
        
        return result
    }
    
    func update(dt: Float) {
        // Override me!
        if parent != nil {
            globalTransform = matrix_multiply(parent!.globalTransform, localTransform)
        } else {
            globalTransform = localTransform
        }
        
        for child in children {
            child.update(dt: dt)
        }
    }
    
    func render(renderEncoder: MTLRenderCommandEncoder) {
        for child in children {
            child.render(renderEncoder: renderEncoder)
        }
        
        // Draw ourselves if we're a Renderable Node
        if let renderable = self as? Renderable {
            renderable.draw(renderEncoder: renderEncoder)
        }
        
    }
}
