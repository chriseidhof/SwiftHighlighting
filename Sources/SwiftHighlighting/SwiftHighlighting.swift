//
//  SwiftHighlighting.swift
//  Workshop
//
//  Created by Chris Eidhof on 25.03.21.
//

import AppKit
import SwiftParser
import SwiftSyntax

@available(macOS 12, *)
extension AttributedString {
    static public func highlightSwift(_ input: String, stylesheet: Stylesheet = .xcodeDefault) -> AttributedString {
        let nsString = NSAttributedString.highlightSwift(input, stylesheet: stylesheet)
        return AttributedString(nsString)
    }
}

extension NSAttributedString {
    static public func highlightSwift(_ input: String, stylesheet: Stylesheet = .xcodeDefault, attributes: [NSAttributedString.Key: Any] = [:]) -> NSAttributedString {
        var atts = attributes
        if atts[.foregroundColor] == nil {
            atts[.foregroundColor] = stylesheet.body
        }
        let str = NSMutableAttributedString(string: input, attributes: atts)
        let result = try! SwiftHighlighter.shared.highlight([input])[0] // todo
        str.highlightCodeBlock(result: result, stylesheet: stylesheet, originalString: input)
        return str
    }
}

extension NSMutableAttributedString {
    func highlightCodeBlock(result: SwiftHighlighter.Result, stylesheet: Stylesheet, originalString: String) {
        let nsString = string as NSString
        let start = 0
        var replacements: [(NSRange, NSAttributedString)] = []
        for el in result {
            let offset = NSRange(el.range, in: originalString)
            let theRange = NSRange(location: start + offset.location, length: offset.length)
            guard theRange.location >= 0, theRange.length < nsString.length else {
                print("invalid range: \(theRange)")
                continue
            }
            addAttribute(.foregroundColor, value: stylesheet.color(for: el.kind), range: theRange)
            if let traits = stylesheet.trait(for: el.kind), let font = attribute(.font, at: theRange.location, effectiveRange: nil) as? NSFont {
                let desc = font.fontDescriptor.withSymbolicTraits(traits)
                let newFont = NSFont(descriptor: desc, size: font.pointSize) ?? font
                addAttribute(.font, value: newFont, range: theRange)
            }
            let atts = stylesheet.customAttributes(for: el.kind)
            if !atts.isEmpty {
                addAttributes(atts, range: theRange)
            }
            if el.kind == .comment {
                let substr = nsString.substring(with: theRange)
                if let r = stylesheet.replaceComment(text: substr) {
                    replacements.append((theRange, r))
                }
            }
        }
        for (range, replacement) in replacements.reversed() {
            replaceCharacters(in: range, with: replacement)
        }
    }
}

class SwiftHighlighter {
    typealias Result = [(range: Range<String.Index>, kind: Token.Kind)]
    
    var cache: [String:Result] = [:]
    
    static let shared = SwiftHighlighter()
    
    func highlight(_ pieces: [String]) throws -> [Result] {
        // todo we probably only need to return (Block,Result) for the non-cached pieces!
        var combined: String = ""
        
        let ranges: [Range<String.Index>?] = pieces.map { piece in
            if cache[piece] != nil { return nil }
            let start = combined.endIndex
            combined.append(piece)
            let end = combined.endIndex
            if piece != pieces.last {
                combined.append("\n\n")
            }
            return start..<end
        }
        
        // combined contains all the code that still needs to be highlighted
        // ranges contains the ranges of the to-be-highlighted pieces (in combined), and nil for each piece that's in the cache.
        
        let allResults = combined.isEmpty ? [] : try _highlight(combined)
        var separated: [Result] = zip(ranges, ranges.indices).map { (range, index) in
            if range == nil { return cache[pieces[index]]! } else { return [] }
        }
        // at this point, separated contains a non-nil entry for each cached piece.
    
        
        
        for var el in allResults {
            guard let currentIndex = ranges.firstIndex(where: { $0?.contains(el.range.lowerBound) == true }) else {
                continue // not sure when this can crash, but we had a crash at least once.
            }
            let distance = combined.distance(from: ranges[currentIndex]!.lowerBound, to: el.range.lowerBound)
            let piece = pieces[currentIndex]
            let start = piece.index(piece.startIndex, offsetBy: distance)
            let distance2 = combined.distance(from: el.range.lowerBound, to: el.range.upperBound)
            let end = piece.index(start, offsetBy: distance2, limitedBy: piece.endIndex) ?? piece.endIndex
            el.range = start..<end
            separated[currentIndex].append(el)
        }
        for (k,v) in zip(pieces,separated) {
            cache[k] = v
        }
        return separated
    }
    
    private func _highlight(_ code: String) throws -> Result {
        let sourceFile = Parser.parse(source: code)
        let highlighter = SwiftHighlighterRewriter()
        _ = highlighter.visit(sourceFile)
        
        let result: Result = highlighter.result.map { t in
            let start = code.utf8.index(code.utf8.startIndex, offsetBy: t.start.utf8Offset)
            let end = code.utf8.index(code.utf8.startIndex, offsetBy: t.end.utf8Offset, limitedBy: code.utf8.endIndex) ?? code.utf8.endIndex
            let result = start..<end
            return (result, t.kind)
        }
        return result
    }
}

public enum TokenKind {
    case string
    case number
    case keyword
    case comment
    case attribute
}

struct Token {
    typealias Kind = TokenKind
    var kind: Kind
    var start: AbsolutePosition
    var end: AbsolutePosition
}

extension TokenSyntax {
    func enumerateAllTrivia(_ f: (TriviaPiece, _ start: AbsolutePosition, _ end: AbsolutePosition) -> ()) {
        var pos = position
        for piece in leadingTrivia {
            let endPos = pos + piece.sourceLength
            f(piece, pos, endPos)
            pos = endPos
        }
        
        pos = endPositionBeforeTrailingTrivia
        for piece in trailingTrivia {
            let endPos = pos + piece.sourceLength
            f(piece, pos, endPos)
            pos = endPos
        }
        
    }
}

extension TriviaPiece {
    var isComment: Bool {
        switch self {
        case .lineComment, .blockComment, .docBlockComment, .docLineComment:
            return true
        default:
            return false
        }
    }
}
class SwiftHighlighterRewriter: SyntaxRewriter {
    var result: [Token] = []
    override func visit(_ node: VariableDeclSyntax) -> DeclSyntax {
        if let attributes = node.attributes {
        for attribute in attributes {
            if case .attribute = attribute {
                result.append(.init(kind: .attribute, start: attribute.positionAfterSkippingLeadingTrivia, end: attribute.endPosition))
            }
        }
        }
        return super.visit(node)
    }

    override func visit(_ node: AttributeSyntax) -> AttributeSyntax {
        result.append(.init(kind: .attribute, start: node.positionAfterSkippingLeadingTrivia, end: node.endPosition))
        return super.visit(node)
    }

    override func visit(_ token: TokenSyntax) -> TokenSyntax {
        let kind: Token.Kind?
        switch token.tokenKind {
        case .stringQuote, .stringSegment:
            kind = .string
        case .integerLiteral, .floatingLiteral:
            kind = .number
        case .keyword:
//        case _ where token.tokenKind.isLexerClassifiedKeyword, .keyword:
            kind = .keyword
        default:
            kind = nil
//            print("Unknown token: \(token.tokenKind) \(token)")
        }
        if let k = kind {
            result.append(Token(kind: k, start: token.positionAfterSkippingLeadingTrivia, end: token.endPosition))
        }

        token.enumerateAllTrivia { piece, start, end in
            if piece.isComment {
                result.append(Token(kind: .comment, start: start, end: end))
            }
        }
        return token
    }
}
