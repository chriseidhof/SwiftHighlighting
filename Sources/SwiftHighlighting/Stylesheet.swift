import Cocoa

public protocol Stylesheet {
    func color(for: TokenKind) -> NSColor
    var body: NSColor { get }
    var background: NSColor { get }
}
