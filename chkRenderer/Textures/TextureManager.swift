//
//  TextureManager.swift
//  chkRenderer
//
//  Created by Jorge Botarro on 03-05-22.
//

import Metal
import MetalKit

class TextureManager {
    private static var textures: [String: MTLTexture] = [:]
    private static var device: MTLDevice? = nil
    private static var loader: MTKTextureLoader? = nil
    
    static func initialize(device: MTLDevice) {
        self.device = device
        self.loader = MTKTextureLoader(device: self.device!)
        
    }
    
    static func load(name: String) -> MTLTexture? {
        if loader == nil { return nil }
        
        let url = Bundle.main.url(forResource: name, withExtension: nil)
        // let origin = NSString(string: MTKTextureLoader.Origin.bottomLeft.rawValue)
        // let options = [MTKTextureLoader.Option.origin: origin]
        
        do {
            let texture = try loader?.newTexture(URL: url!, options: nil)
            textures[name] = texture
            return texture
        } catch let error as NSError {
            print("Error loading texture '\(name)': \(error)")
        }
        return nil
    }
    
    static func get(name: String) -> MTLTexture? {
        if let texture = textures[name] {
            return texture
        } else {
            return load(name: name)
        }
    }
}
