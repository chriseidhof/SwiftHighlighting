import XCTest
@testable import SwiftHighlighting

final class SwiftHighlightingTests: XCTestCase {
    func testStruct() throws {
        let input = """
            struct Foo {
                // Comment
                let bar = true
                var str = ("hello", 42)
            }
            """

        let result = try SwiftHighlighter.shared.highlight([input])[0]

        let testRanges: [(fragment: String, kind: SwiftHighlighting.TokenKind)] = [
            (fragment: "struct ", kind: .keyword),
            (fragment: "// Comment", kind: .comment),
            (fragment: "let ", kind: .keyword),
            (fragment: "var ", kind: .keyword),
            (fragment: "true", kind: .keyword),
            (fragment: "hello", kind: .string),
            (fragment: "42", kind: .number),
        ]

        for range in testRanges {
            XCTAssertTrue(result.contains(where: { (r, k) in
                r == input.range(of: range.fragment) && k == range.kind
            }), "Should contain {\(range.fragment)} as a \(range.kind)")
        }
    }
}
