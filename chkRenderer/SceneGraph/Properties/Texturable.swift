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
    func setTexture(imageName: String) -> MTLTexture? {
        if (imageName == "") { return nil }

        return TextureManager.get(name: imageName)
    }
}
