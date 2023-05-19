import XCTest
@testable import SwiftHighlighting

final class SwiftHighlightingTests: XCTestCase {
    func testStruct() throws {
        let input = """
            struct Foo {
                // Comment
                let bar = true
                var str = ("hello", 42)

                @discardableResult
                func bar() -> Int {
                    return 0
                }
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
            (fragment: "@discardableResult", kind: .attribute),
            (fragment: "func ", kind: .keyword),
            (fragment: "0", kind: .number),
        ]

        for range in testRanges {
            XCTAssertTrue(result.contains(where: { (r, k) in
                r == input.range(of: range.fragment) && k == range.kind
            }), "Should contain {\(range.fragment)} as a \(range.kind)")
        }
    }

    func testRegression0() throws {
        let input = """
        HStack {
             Text("View 1") // label: 1
        }
        """

        let result = try SwiftHighlighter.shared.highlight([input])[0]

        let testRanges: [(fragment: String, kind: SwiftHighlighting.TokenKind)] = [
            (fragment: "View 1", kind: .string),
            (fragment: "// label: 1", kind: .comment),
        ]

        for range in testRanges {
            XCTAssertTrue(result.contains(where: { (r, k) in
                r == input.range(of: range.fragment) && k == range.kind
            }), "Should contain {\(range.fragment)} as a \(range.kind)")
        }
    }
}
