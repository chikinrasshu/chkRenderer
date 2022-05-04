//
//  MatrixMath.swift
//  chkRenderer
//
//  Created by Jorge Botarro on 02-05-22.
//

import Metal
import MetalKit

func degrees(radians: Float) -> Float {
    return Float(Double(radians * 180.0) / Double.pi)
}

func radians(degrees: Float) -> Float {
    return Float(Double.pi * Double(degrees / 180.0))
}

extension matrix_float4x4 {
    init(nearZ: Float, farZ: Float, left: Float, right: Float, top: Float, bottom: Float) {
        let dx = right - left
        let dy = top - bottom
        let dz = farZ - nearZ
        
        let a = 2.0 / dx
        let b = 2.0 / dy
        let c = -2.0 / dz
        
        let d = (right + left) / dx
        let e = (top + bottom) / dy
        let f = (farZ + nearZ) / dz
        
        self.init([
            [a, 0, 0, 0],
            [0, b, 0, 0],
            [0, 0, c, 0],
            [d, e, f, 1]
        ])
    }
    
    init(perspectiveFOV: Float, aspectRatio: Float, nearZ: Float, farZ: Float) {
        let fov = radians(degrees: perspectiveFOV)
        let zDelta = nearZ - farZ
        
        let y = 1.0 / tan(fov / 2)
        let x = y / aspectRatio
        let z = (nearZ + farZ) / zDelta
        let w = (2 * nearZ * farZ) / zDelta
        
        self.init([
            [x, 0, 0,  0],
            [0, y, 0,  0],
            [0, 0, z, -1],
            [0, 0, w,  0]
        ])
    }
    
    mutating func scale(axis: SIMD3<Float>) {
        var result = matrix_identity_float4x4
        
        result.columns.0.x = axis.x
        result.columns.1.y = axis.y
        result.columns.2.z = axis.z
        
        self = matrix_multiply(self, result)
    }
    
    mutating func translate(axis: SIMD3<Float>) {
        var result = matrix_identity_float4x4
        
        result.columns.3.x = axis.x
        result.columns.3.y = axis.y
        result.columns.3.z = axis.z
        
        self = matrix_multiply(self, result)
    }
    
    mutating func rotate(axis: SIMD3<Float>, angle: Float) {
        var result = matrix_identity_float4x4
        let c: Float = cos(angle)
        let s: Float = sin(angle)
        let mc: Float = 1 - c
        
        let r1c1: Float = axis.x * axis.x * mc + c
        let r2c1: Float = axis.x * axis.y * mc + axis.z * s
        let r3c1: Float = axis.x * axis.z * mc - axis.y * s
        
        let r1c2: Float = axis.x * axis.y * mc - axis.z * s
        let r2c2: Float = axis.y * axis.y * mc + c
        let r3c2: Float = axis.y * axis.z * mc + axis.x * s
        
        let r1c3: Float = axis.x * axis.z * mc + axis.y * s
        let r2c3: Float = axis.y * axis.z * mc - axis.x * s
        let r3c3: Float = axis.z * axis.z * mc + c
        
        result.columns.0 = [r1c1, r2c1, r3c1, 0]
        result.columns.1 = [r1c2, r2c2, r3c2, 0]
        result.columns.2 = [r1c3, r2c3, r3c3, 0]
        
        self = matrix_multiply(self, result)
    }
    
}
