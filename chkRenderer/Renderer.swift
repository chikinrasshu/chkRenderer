//
//  Renderer.swift
//  chkRenderer
//
//  Created by Jorge Botarro on 01-05-22.
//

import Metal
import MetalKit

class Renderer: NSObject, MTKViewDelegate {
    static var library: MTLLibrary? = nil
    static var pixelFormat: MTLPixelFormat? = .bgra8Unorm
    static var depthFormat: MTLPixelFormat? = MTLPixelFormat.invalid
    static var aspectRatio: Float = 1.0
    
    // Texture samplers
    static var linearSampler: MTLSamplerState? = nil
    static var blockySampler: MTLSamplerState? = nil
    static var pixelSampler: MTLSamplerState? = nil
    
    // Rendering
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let depthStencilState: MTLDepthStencilState
    let gpuLock = DispatchSemaphore(value: 1)
    
    // Scene
    let fragmentBuffer: MTLBuffer
    let scene: Scene
    
    // Timing
    var lastRenderTime: CFTimeInterval? = nil
    var elapsedTime: Double = 0.0
    
    init?(mtkView: MTKView) {
        device = mtkView.device!
        commandQueue = device.makeCommandQueue()!
        
        // Setup some globals
        Renderer.library = device.makeDefaultLibrary()
        Renderer.pixelFormat = mtkView.colorPixelFormat
        Renderer.depthFormat = mtkView.depthStencilPixelFormat
        Renderer.aspectRatio = Float(mtkView.frame.width / mtkView.frame.height)
        
        // Enable depth testing
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilState = device.makeDepthStencilState(descriptor: depthStencilDescriptor)!
        
        // Setup some samplers
        Renderer.linearSampler = Renderer.buildTextureSampler(device: device, minFilter: .linear, magFilter: .linear)
        Renderer.blockySampler = Renderer.buildTextureSampler(device: device, minFilter: .nearest, magFilter: .nearest)
        Renderer.pixelSampler = Renderer.buildTextureSampler(device: device, minFilter: .linear, magFilter: .nearest)
        
        // Setup the uniforms
        var uniforms = BasicUniforms(brightness: 1.0)
        fragmentBuffer = device.makeBuffer(bytes: &uniforms,
                                           length: MemoryLayout<BasicUniforms>.stride,
                                           options: [])!
        
        // Setup the scene
        scene = Scene(device: device, name: "SceneRoot")
        let p = Plane(device: device, name: "TestPlane")
        let c = Cube(device: device, name: "TestCube")
        
        p.rotation.x = .pi / 2.0
        p.scale.x = 10
        p.scale.z = 10
        
        scene.add(child: p)
        scene.add(child: c)
    }
    
    static func buildTextureSampler(device: MTLDevice, minFilter: MTLSamplerMinMagFilter, magFilter: MTLSamplerMinMagFilter) -> MTLSamplerState {
        let samplerDescriptor = MTLSamplerDescriptor()
        samplerDescriptor.minFilter = minFilter
        samplerDescriptor.magFilter = magFilter
        
        return device.makeSamplerState(descriptor: samplerDescriptor)!
    }
    
    // Update the scene
    func update(view: MTKView, dt: CFTimeInterval) {
        let ptr = fragmentBuffer.contents().bindMemory(to: BasicUniforms.self, capacity: 1)
        ptr.pointee.brightness = Float(0.25 * cos(elapsedTime) + 0.75)
        
        scene.update(dt: dt)
        
        elapsedTime += dt
    }
    
    // Draw the current scene
    func draw(in view: MTKView) {
        gpuLock.wait()
        // Calculate the dt
        let systemTime = CACurrentMediaTime()
        let dt = (lastRenderTime == nil) ? 0.0 : (systemTime - lastRenderTime!)
        lastRenderTime = systemTime
        
        // Prepare the frame
        guard let drawable = view.currentDrawable else { return }
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        
        // renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.3, 0.3, 0.3, 1.0)
        renderEncoder.setDepthStencilState(depthStencilState)
        renderEncoder.setFragmentSamplerState(Renderer.pixelSampler!, index: 0)
        renderEncoder.setFragmentBuffer(fragmentBuffer, offset: 0, index: 0)
        
        update(view: view, dt: dt)
        scene.render(renderEncoder: renderEncoder)
        
        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.addCompletedHandler{ _ in self.gpuLock.signal() }
        commandBuffer.commit()
    }
    
    // View updated, most likely changed size
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        Renderer.aspectRatio = Float(view.frame.width / view.frame.height)
    }
}
