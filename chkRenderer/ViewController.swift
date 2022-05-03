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
    @IBOutlet weak var mtkView: MTKView!
    var renderer: Renderer!
    
    // Debug panel
    @IBOutlet weak var fovSlider: NSSlider!
    
    // Labels
    @IBOutlet weak var pXLabel: NSTextField!
    @IBOutlet weak var pYLabel: NSTextField!
    @IBOutlet weak var pZLabel: NSTextField!
    
    @IBOutlet weak var rXLabel: NSTextField!
    @IBOutlet weak var rYLabel: NSTextField!
    @IBOutlet weak var rZLabel: NSTextField!
    
    // Sliders
    @IBOutlet weak var pXSlider: NSSlider!
    @IBOutlet weak var pYSlider: NSSlider!
    @IBOutlet weak var pZSlider: NSSlider!
    
    @IBOutlet weak var rXSlider: NSSlider!
    @IBOutlet weak var rYSlider: NSSlider!
    @IBOutlet weak var rZSlider: NSSlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (mtkView == nil) {
            print("No MTKView is attached to this view!")
            return
        }
        
        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            print("Metal is not supported on this device!")
            return
        }
        mtkView.device = defaultDevice
        mtkView.colorPixelFormat = .bgra8Unorm
        mtkView.depthStencilPixelFormat = .depth32Float
        
        guard let tmpRenderer = Renderer(mtkView: mtkView) else {
            print("Failed to initialize the renderer!")
            return
        }
        renderer = tmpRenderer
        renderer.mtkView(mtkView, drawableSizeWillChange: mtkView.drawableSize)
        
        // Set initial state based on debug values
        fovSlider.floatValue = (renderer?.scene.camera.fov)!
        
        pXSlider.floatValue = (renderer?.scene.camera.position.x)!
        pYSlider.floatValue = (renderer?.scene.camera.position.y)!
        pZSlider.floatValue = (renderer?.scene.camera.position.z)!
        
        camX_ValueChanged(pXSlider!)
        camY_ValueChanged(pYSlider!)
        camZ_ValueChanged(pZSlider!)
        
        rXSlider.floatValue = degrees(radians: (renderer?.scene.camera.rotation.x)!)
        rYSlider.floatValue = degrees(radians: (renderer?.scene.camera.rotation.y)!)
        rZSlider.floatValue = degrees(radians: (renderer?.scene.camera.rotation.z)!)
        
        camRX_ValueChanged(rXSlider!)
        camRY_ValueChanged(rYSlider!)
        camRZ_ValueChanged(rZSlider!)
        
        mtkView.delegate = renderer
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    // Debug actions
    
    @IBAction func fovSlider_ValueChanged(_ sender: Any) {
        renderer?.scene.camera.fov = fovSlider.floatValue
    }
    
    // Camera position
    @IBAction func camX_ValueChanged(_ sender: Any) {
        renderer?.scene.camera.position.x = pXSlider.floatValue
        pXLabel.stringValue = String(format: "%0.2f", pXSlider.floatValue)
    }
    
    @IBAction func camY_ValueChanged(_ sender: Any) {
        renderer?.scene.camera.position.y = pYSlider.floatValue
        pYLabel.stringValue = String(format: "%0.2f", pYSlider.floatValue)
    }
    
    @IBAction func camZ_ValueChanged(_ sender: Any) {
        renderer?.scene.camera.position.z = pZSlider.floatValue
        pZLabel.stringValue = String(format: "%0.2f", pZSlider.floatValue)
    }
    
    // Camera rotation
    @IBAction func camRX_ValueChanged(_ sender: Any) {
        renderer?.scene.camera.rotation.x = radians(degrees: rXSlider.floatValue)
        rXLabel.stringValue = String(format: "%0.2f", rXSlider.floatValue)
    }
    
    @IBAction func camRY_ValueChanged(_ sender: Any) {
        renderer?.scene.camera.rotation.y = radians(degrees: rYSlider.floatValue)
        rYLabel.stringValue = String(format: "%0.2f", rYSlider.floatValue)
    }
    
    @IBAction func camRZ_ValueChanged(_ sender: Any) {
        renderer?.scene.camera.rotation.z = radians(degrees: rZSlider.floatValue)
        rZLabel.stringValue = String(format: "%0.2f", rZSlider.floatValue)
    }
    
    
    
}

