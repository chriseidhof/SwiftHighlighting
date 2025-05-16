import Cocoa

public struct XcodeDefaultDark: Stylesheet {
    public var body = NSColor.white.withAlphaComponent(0.85)
    public var background =
            NSColor(hue: 233/360, saturation: 0.15, brightness: 0.14, alpha: 1)
    
    public init() { }
    
    public func color(for kind: TokenKind) -> NSColor {
        switch kind {
        case .string:
            return NSColor(hue: 5/360, saturation: 0.63, brightness: 0.99, alpha: 1)
        case .number:
            return NSColor(hue: 50/360, saturation: 0.49, brightness: 0.81, alpha: 1)
        case .keyword:
            return NSColor(hue: 334/360, saturation: 0.62, brightness: 0.99, alpha: 1)
        case .comment:
            return NSColor(hue: 210/360, saturation: 0.19, brightness: 0.53, alpha: 1)
        case .attribute:
            return NSColor(hue: 27/360, saturation: 0.55, brightness: 0.75, alpha: 1)
        }
    }
}

extension Stylesheet where Self == XcodeDefaultDark {
    public static var xcodeDefaultDark: XcodeDefaultDark { .init() }
}

public struct XcodeDefaultLight: Stylesheet {
    public var body =
            NSColor(hue: 233/360, saturation: 0, brightness: 0, alpha: 1)
    public var background = NSColor.white
    
    public init() { }
    
    public func color(for kind: TokenKind) -> NSColor {
        switch kind {
        case .string:
            return NSColor(hue: 1/360, saturation: 0.89, brightness: 0.77, alpha: 1)
        case .number:
            return NSColor(hue: 248/360, saturation: 1.00, brightness: 0.81, alpha: 1)
        case .keyword:
            return NSColor(hue: 304/360, saturation: 0.77, brightness: 0.61, alpha: 1)
        case .comment:
            return NSColor(hue: 209/360, saturation: 0.23, brightness: 0.48, alpha: 1)
        case .attribute:
            return NSColor(hue: 44/360, saturation: 0.98, brightness: 0.51, alpha: 1)
        }
    }
}

extension Stylesheet where Self == XcodeDefaultLight {
    public static var xcodeDefault: XcodeDefaultLight { .init() }
}

let exampleString = """
    public func color(for kind: TokenKind) -> NSColor {
        switch kind {
        case "test": foo()
        case .string:
            return NSColor(hue: 5/360, saturation: 0.63, brightness: 0.99, alpha: 1)

"""

#if DEBUG
import SwiftUI
#Preview {
    if #available(macOS 12, *) {
        Text(AttributedString(NSAttributedString.highlightSwift(exampleString, stylesheet: .xcodeDefaultDark)))
            .background(.black)
        Text(AttributedString(NSAttributedString.highlightSwift(exampleString, stylesheet: .xcodeDefault)))
            .background(.white)
    } else {
        // Fallback on earlier versions
    }
}
#endif
