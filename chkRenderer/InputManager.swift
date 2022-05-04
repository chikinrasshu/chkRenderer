//
//  InputManager.swift
//  chkRenderer
//
//  Created by Jorge Botarro on 03-05-22.
//

import Metal
import MetalKit

enum InputKey: UInt16 {
    // US layout dependent
    case A              = 0x00
    case B              = 0x0B
    case C              = 0x08
    case D              = 0x02
    case E              = 0x0E
    case F              = 0x03
    case G              = 0x05
    case H              = 0x04
    case I              = 0x22
    case J              = 0x26
    case K              = 0x28
    case L              = 0x25
    case M              = 0x2E
    case N              = 0x2D
    case O              = 0x1F
    case P              = 0x23
    case Q              = 0x0C
    case R              = 0x0F
    case S              = 0x01
    case T              = 0x11
    case U              = 0x20
    case V              = 0x09
    case W              = 0x0D
    case X              = 0x07
    case Y              = 0x10
    case Z              = 0x06
    
    // Layout independent
    case Return         = 0x24
    case Enter          = 0x4C
    case Tab            = 0x30
    case Space          = 0x31
    case Delete         = 0x33
    case Escape         = 0x35
    case Command        = 0x37
    case Shift          = 0x38
    case CapsLock       = 0x39
    case Option         = 0x3A
    case Control        = 0x3B
    case RightShift     = 0x3C
    case RightOption    = 0x3D
    case RightControl   = 0x3E
    case LeftArrow      = 0x7B
    case RightArrow     = 0x7C
    case DownArrow      = 0x7D
    case UpArrow        = 0x7E
    case VolumeUp       = 0x48
    case VolumeDown     = 0x49
    case Mute           = 0x4A
    case Help           = 0x72
    case Home           = 0x73
    case PageUp         = 0x74
    case PageDown       = 0x79
    case ForwardDelete  = 0x75
    case End            = 0x77
    case Function       = 0x3F
    case F1             = 0x7A
    case F2             = 0x78
    case F3             = 0x63
    case F4             = 0x76
    case F5             = 0x60
    case F6             = 0x61
    case F7             = 0x62
    case F8             = 0x64
    case F9             = 0x65
    case F10            = 0x6D
    case F11            = 0x67
    case F12            = 0x6F
    case F13            = 0x69
    case F14            = 0x6B
    case F15            = 0x71
    case F16            = 0x6A
    case F17            = 0x40
    case F18            = 0x4F
    case F19            = 0x50
    case F20            = 0x5A
    
    case Num0           = 0x1D
    case Num1           = 0x12
    case Num2           = 0x13
    case Num3           = 0x14
    case Num4           = 0x15
    case Num5           = 0x17
    case Num6           = 0x16
    case Num7           = 0x1A
    case Num8           = 0x1C
    case Num9           = 0x19
    
    case Equals         = 0x18
    case Minus          = 0x1B
    case Semicolon      = 0x29
    case Apostrophe     = 0x27
    case Comma          = 0x2B
    case Period         = 0x2F
    case ForwardSlash   = 0x2C
    case Backslash      = 0x2A
    case Grave          = 0x32
    case LeftBracket    = 0x21
    case RightBracket   = 0x1E
    
    case KeypadDecimal  = 0x41
    case KeypadMultiply = 0x43
    case KeypadPlus     = 0x45
    case KeypadClear    = 0x47
    case KeypadDivide   = 0x4B
    // case KeypadEnter    = 0x4C
    case KeypadMinus    = 0x4E
    case KeypadEquals   = 0x51
    case Keypad0        = 0x52
    case Keypad1        = 0x53
    case Keypad2        = 0x54
    case Keypad3        = 0x55
    case Keypad4        = 0x56
    case Keypad5        = 0x57
    case Keypad6        = 0x58
    case Keypad7        = 0x59
    case Keypad8        = 0x5B
    case Keypad9        = 0x5C
}

class InputManager {
    private static var KEY_COUNT: Int = 256
    private static var keys: [Bool] = Array(repeating: false, count: KEY_COUNT)
    
    static func setKeyState(key: InputKey, state: Bool) { keys[Int(key.rawValue)] = state }
    static func isPressed(key: InputKey) -> Bool { return keys[Int(key.rawValue)] }
}
