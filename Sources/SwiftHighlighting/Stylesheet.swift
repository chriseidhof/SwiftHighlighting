import Cocoa

public protocol Stylesheet {
    func color(for: TokenKind) -> NSColor
    func trait(for kind: TokenKind) -> NSFontDescriptor.SymbolicTraits?
    var body: NSColor { get }
    var background: NSColor { get }
}

extension Stylesheet {
    public func trait(for kind: TokenKind) -> NSFontDescriptor.SymbolicTraits? {
        nil
    }
}
