import Foundation
import Cocoa

struct Solarized {
    static let base03    = NSColor(calibratedHue: 193/255.0, saturation: 100/255.0, brightness:  21/255.0, alpha: 1)
    static let base02    = NSColor(calibratedHue: 192/255.0, saturation:  90/255.0, brightness:  26/255.0, alpha: 1)
    static let base01    = NSColor(calibratedHue: 194/255.0, saturation:  25/255.0, brightness:  46/255.0, alpha: 1)
    static let base00    = NSColor(calibratedHue: 195/255.0, saturation:  23/255.0, brightness:  51/255.0, alpha: 1)
    static let base0     = NSColor(calibratedHue: 186/255.0, saturation:  13/255.0, brightness:  59/255.0, alpha: 1)
    static let base1     = NSColor(calibratedHue: 180/255.0, saturation:   9/255.0, brightness:  63/255.0, alpha: 1)
    static let base2     = NSColor(calibratedHue:  44/255.0, saturation:  11/255.0, brightness:  93/255.0, alpha: 1)
    static let base3     = NSColor(calibratedHue:  44/255.0, saturation:  10/255.0, brightness:  99/255.0, alpha: 1)
    static let yellow    = NSColor(calibratedHue:  45/255.0, saturation: 100/255.0, brightness:  71/255.0, alpha: 1)
    static let orange    = NSColor(calibratedHue:  18/255.0, saturation:  89/255.0, brightness:  80/255.0, alpha: 1)
    static let red       = NSColor(calibratedHue:   1/255.0, saturation:  79/255.0, brightness:  86/255.0, alpha: 1)
    static let magenta   = NSColor(calibratedHue: 331/255.0, saturation:  74/255.0, brightness:  83/255.0, alpha: 1)
    static let violet    = NSColor(calibratedHue: 237/255.0, saturation:  45/255.0, brightness:  77/255.0, alpha: 1)
    static let blue      = NSColor(calibratedHue: 205/255.0, saturation:  82/255.0, brightness:  82/255.0, alpha: 1)
    static let cyan      = NSColor(calibratedHue: 175/255.0, saturation:  74/255.0, brightness:  63/255.0, alpha: 1)
    static let green     = NSColor(calibratedHue:  68/255.0, saturation: 100/255.0, brightness:  60/255.0, alpha: 1)
}

public struct SolarizedLight: Stylesheet {
    public let body = Solarized.base00
    public let background = Solarized.base3
    
    public init() { }
    
    public func color(for kind: TokenKind) -> NSColor {
        switch kind {
        case .string:
            return Solarized.magenta
        case .number:
            return Solarized.yellow
        case .keyword:
            return Solarized.base1
        case .comment:
            return Solarized.base01
        case .attribute:
            return Solarized.orange
        }
    }
}

public struct SolarizedDark: Stylesheet {
    public let body = Solarized.base00
    public let background = Solarized.base03
    
    public init() { }
    
    public func color(for kind: TokenKind) -> NSColor {
        switch kind {
        case .string:
            return Solarized.magenta
        case .number:
            return Solarized.yellow
        case .keyword:
            return Solarized.base1
        case .comment:
            return Solarized.base01
        case .attribute:
            return Solarized.orange
        }
    }
}

extension Stylesheet where Self == SolarizedLight {
    static var solarizedLight: SolarizedLight { .init() }
}

extension Stylesheet where Self == SolarizedDark {
    static var solarizedDark: SolarizedDark { .init() }
}
