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
    static var width: Float = 800
    static var height: Float = 800
    
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
    let robot: Node
    
    // Timing
    var lastRenderTime: CFTimeInterval? = nil
    var elapsedTime: Double = 0.0
    
    init?(chkView: MTKView) {
        device = chkView.device!
        commandQueue = device.makeCommandQueue()!
        
        // Setup some globals
        TextureManager.initialize(device: device)
        Renderer.library = device.makeDefaultLibrary()
        Renderer.pixelFormat = chkView.colorPixelFormat
        Renderer.depthFormat = chkView.depthStencilPixelFormat
        Renderer.width = Float(chkView.frame.width)
        Renderer.height = Float(chkView.frame.height)
        Renderer.aspectRatio = Float(chkView.frame.width / chkView.frame.height)
        
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
        scene.camera.position.y = 1.5
        // let p = Plane(device: device, name: "TestPlane")
        // scene.add(child: p)
        
        robot = Node(device: device, name: "TestCube")
        robot.position.z = -20
        
        // Add the body parts to the robot
        let body = CubeBodyPiece(device: device, name: "Body")
        body.color = [1,0,0,1]
        body.position.y = 3.5
        robot.add(child: body)
        
        let lLeg = CubeBodyPiece(device: device, name: "LeftLeg")
        lLeg.color = [0,0,1,1]
        lLeg.position.x = -0.8
        // lLeg.scale.y = 3.5
        lLeg.rotation.x = .pi
        
        let rLeg = CubeBodyPiece(device: device, name: "RightLeg")
        rLeg.color = [0,0,1,1]
        rLeg.position.x = 0.8
        // rLeg.scale.y = 3.5
        rLeg.rotation.x = .pi
        
        let lArm = CubeBodyPiece(device: device, name: "LeftArm")
        lArm.color = [0,0,1,1]
        lArm.position.x = -1.2
        lArm.position.y = 3.0
        lArm.position.z = -0.1
        // lArm.scale.y = 3.5
        lArm.rotation.x = .pi
        
        let rArm = CubeBodyPiece(device: device, name: "RightArm")
        rArm.color = [0,0,1,1]
        rArm.position.x = 1.2
        rArm.position.y = 3.0
        rArm.position.z = -0.1
        // rArm.scale.y = 3.5
        rArm.rotation.x = .pi
        
        let head = CubeBodyPiece(device: device, name: "Head")
        head.color = [0,1,0,1]
        head.position.y = 3.0
        
        body.add(child: head)
        body.add(child: lLeg)
        body.add(child: rLeg)
        body.add(child: lArm)
        body.add(child: rArm)
        
        scene.add(child: robot)
        
        // scene.camera.rotation.x = .pi / 4
        // scene.camera.position.y = -5
    }
    
    static func buildTextureSampler(device: MTLDevice, minFilter: MTLSamplerMinMagFilter, magFilter: MTLSamplerMinMagFilter) -> MTLSamplerState {
        let samplerDescriptor = MTLSamplerDescriptor()
        samplerDescriptor.minFilter = minFilter
        samplerDescriptor.magFilter = magFilter
        
        return device.makeSamplerState(descriptor: samplerDescriptor)!
    }
    
    // Update the scene
    func update(view: MTKView, dtInterval: CFTimeInterval) {
        let ptr = fragmentBuffer.contents().bindMemory(to: BasicUniforms.self, capacity: 1)
        ptr.pointee.brightness = Float(0.25 * cos(elapsedTime) + 0.75)
        
        let dt = Float(dtInterval)
        
        if (InputManager.isPressed(key: .Q)) {
            scene.camera.position.x -= dt
            robot.position.x -= dt
        }
        if (InputManager.isPressed(key: .E)) {
            scene.camera.position.x += dt
            robot.position.x += dt
        }
        
        if (InputManager.isPressed(key: .W)) {
            robot.rotation.x += dt
        }
        if (InputManager.isPressed(key: .S)) {
            robot.rotation.x -= dt
        }
        if (InputManager.isPressed(key: .A)) {
            robot.rotation.y -= dt
        }
        if (InputManager.isPressed(key: .D)) {
            robot.rotation.y += dt
        }
        
        if (InputManager.isPressed(key: .UpArrow)) {
            scene.camera.rotation.x -= dt
        }
        if (InputManager.isPressed(key: .DownArrow)) {
            scene.camera.rotation.x += dt
        }
        if (InputManager.isPressed(key: .LeftArrow)) {
            scene.camera.rotation.y += dt
        }
        if (InputManager.isPressed(key: .RightArrow)) {
            scene.camera.rotation.y -= dt
        }
        if (InputManager.isPressed(key: .Comma)) {
            scene.camera.position.y -= dt
        }
        if (InputManager.isPressed(key: .Period)) {
            scene.camera.position.y += dt
        }
        
        scene.update(dt: dt)
        
        elapsedTime += dtInterval
    }
    
    // Draw the current scene
    func draw(in view: MTKView) {
        gpuLock.wait()
        // Calculate the dt
        let systemTime = CACurrentMediaTime()
        let dtInterval = (lastRenderTime == nil) ? 0.0 : (systemTime - lastRenderTime!)
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
        
        // renderEncoder.setTriangleFillMode(.lines)
        
        update(view: view, dtInterval: dtInterval)
        scene.render(renderEncoder: renderEncoder)
        
        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.addCompletedHandler{ _ in self.gpuLock.signal() }
        commandBuffer.commit()
    }
    
    // View updated, most likely changed size
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        Renderer.width = Float(view.frame.width)
        Renderer.height = Float(view.frame.height)
        Renderer.aspectRatio = Float(view.frame.width / view.frame.height)
        scene.camera.updateMatrix()
    }
}
