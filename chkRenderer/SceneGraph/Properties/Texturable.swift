//
//  Texturable.swift
//  chkRenderer
//
//  Created by Jorge Botarro on 02-05-22.
//

import Metal
import MetalKit

protocol Texturable {
    var texture: MTLTexture? { get set }
}

extension Texturable {
    func setTexture(device: MTLDevice, imageName: String) -> MTLTexture? {
        if (imageName == "") { return nil }
        
        var texture: MTLTexture? = nil
        let textureLoader = MTKTextureLoader(device: device)
        let url = Bundle.main.url(forResource: imageName, withExtension: nil)
        
        let origin = NSString(string: MTKTextureLoader.Origin.bottomLeft.rawValue)
        let options = [MTKTextureLoader.Option.origin: origin]

        do {
            texture = try textureLoader.newTexture(URL: url!, options: options)
        } catch let error as NSError {
            print("Failed to load Texture: \(error)")
        }
        
        return texture
    }
}
