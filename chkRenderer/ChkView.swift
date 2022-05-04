//
//  ChkView.swift
//  chkRenderer
//
//  Created by Jorge Botarro on 03-05-22.
//

import Metal
import MetalKit

class ChkView: MTKView {
    
}

extension ChkView {
    override var acceptsFirstResponder: Bool { return true }
        
    override func keyDown(with event: NSEvent) {
        InputManager.setKeyState(key: InputKey(rawValue: event.keyCode)!, state: true)
    }
    
    override func keyUp(with event: NSEvent) {
        InputManager.setKeyState(key: InputKey(rawValue: event.keyCode)!, state: false)
    }
}
