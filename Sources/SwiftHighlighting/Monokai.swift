import Cocoa

public struct Monokai: Stylesheet {
    public var background =
            NSColor(red: 0.15, green: 0.16, blue: 0.13, alpha: 1)

    public init() { }

    let pink = NSColor(red: 0.98, green: 0.15, blue: 0.45, alpha: 1)
    let green = NSColor(red: 0.61, green: 0.83, blue: 0.18, alpha: 1)
    let purple = NSColor(red: 0.75, green: 0.47, blue: 0.86, alpha: 1)
    let darkGray = NSColor(red: 0.46, green: 0.44, blue: 0.36, alpha: 1)
    public let body = NSColor(white: 0.87, alpha: 1)

    public func color(for kind: TokenKind) -> NSColor {
        switch kind {
        case .string: green
        case .number: body
        case .keyword: pink
        case .comment: darkGray
        case .attribute: purple
        }
    }
}

extension Stylesheet where Self == Monokai {
    public static var monokai: Self { .init() }
}

#if DEBUG

import SwiftUI

struct Helper<S: Stylesheet>: View {
    var stylesheet: S
    var text: String = exampleString
    @ScaledMetric var bodySize = 17

    var body: some View {
        Text(AttributedString(NSAttributedString.highlightSwift(text, stylesheet: stylesheet, attributes: [.font: NSFont.monospacedSystemFont(ofSize: bodySize, weight: .medium)])))
            .padding()
            .background(Color(stylesheet.background))
    }
}

import SwiftUI
#Preview {
    Helper(stylesheet: .monokai)
}
#endif
