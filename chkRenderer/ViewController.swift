//
//  ViewController.swift
//  chkRenderer
//
//  Created by Jorge Botarro on 01-05-22.
//

import Cocoa
import Metal
import MetalKit

class ViewController: NSViewController {
    var renderer: Renderer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        processViews(of: self.view)
    }
    
    func processViews(of: NSView) {
        for childView in of.subviews {
            processViews(of: childView)
        }
        
        // Create a renderer for every MTKView
        guard let chkView = of as? ChkView else {
            return
        }
        
        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            print("Metal is not supported on this device!")
            return
        }
        chkView.device = defaultDevice
        chkView.colorPixelFormat = .bgra8Unorm
        chkView.depthStencilPixelFormat = .depth32Float
        
        guard let tmpRenderer = Renderer(chkView: chkView) else {
            print("Failed to initialize the renderer!")
            return
        }
        renderer = tmpRenderer
        renderer.mtkView(chkView, drawableSizeWillChange: chkView.drawableSize)
        
        chkView.delegate = renderer
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}
