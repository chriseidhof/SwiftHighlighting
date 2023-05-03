import Cocoa

public protocol Stylesheet {
    func color(for: TokenKind) -> NSColor
    func trait(for kind: TokenKind) -> NSFontDescriptor.SymbolicTraits?
    func replaceComment(text: String) -> NSAttributedString?
    var body: NSColor { get }
    var background: NSColor { get }
}

extension Stylesheet {
    public func trait(for kind: TokenKind) -> NSFontDescriptor.SymbolicTraits? {
        nil
    }

    public func customAttributes(for kind: TokenKind) -> [NSAttributedString.Key: Any] {
        [:]
    }

    public func replaceComment(text: String) -> NSAttributedString? {
        return nil
    }
}
