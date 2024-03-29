import Foundation
import SwiftTreeSitter
import TreeSitterJSON
import SwiftPath

struct ConsoleOutput {
    private let jsonString: String
    private var output: String = ""
    private var currentIndent: Int = 0

    init(_ jsonString: String) {
        self.jsonString = jsonString
    }

    init(_ jsonData: JsonValue) throws {
        jsonString = String(decoding: try JSONSerialization.data(withJSONObject: jsonData as Any), as: UTF8.self)
    }

    mutating func string() throws -> String {
        let language = Language.init(language: tree_sitter_json())

        let parser = Parser()
        try parser.setLanguage(language)

        guard let tree = parser.parse(jsonString) else {
            throw JsonQueryError.invalidJsonInput
        }

        return treeToString(tree)
    }

    private mutating func treeToString(_ tree: Tree) -> String {
        tree.rootNode?.enumerateChildren { block in 
            treeToStringRecursive(node: block)
        }

        return output;
    }

    private mutating func treeToStringRecursive(node: Node) {
        var indent = String(repeating: "    ", count: currentIndent)

        switch node.nodeType {
        case "{":
            output.append("\(AnsiColours.white.rawValue){\n")
            currentIndent += 1
        case "}":
            currentIndent -= 1
            indent = String(repeating: "    ", count: currentIndent)

            output.append("\n\(indent)\(AnsiColours.white.rawValue)}")
        case ",":
            output.append("\(AnsiColours.white.rawValue),\n")
        case ":":
            output.append("\(AnsiColours.white.rawValue): ")
        case "pair":
            let key = node.child(at: 0)!
            let separator = node.child(at: 1)!
            let value = node.child(at: 2)!

            output.append("\(indent)\(AnsiColours.blue.rawValue)\(jsonString[key.stringRange(in: jsonString)])")

            treeToStringRecursive(node: separator)
            treeToStringRecursive(node: value)
            return
        case "string": 
            output.append("\(AnsiColours.green.rawValue)\(jsonString[node.stringRange(in: jsonString)])")
        case "true":
            output.append("\(AnsiColours.magenta.rawValue)\(jsonString[node.stringRange(in: jsonString)])")
        case "false":
            output.append("\(AnsiColours.magenta.rawValue)\(jsonString[node.stringRange(in: jsonString)])")
        default:
            #if debug 
            debugPrint("Unknown node type: \(node.nodeType!)")
            #endif
        }

        node.enumerateChildren { block in 
            treeToStringRecursive(node: block)
        }
    }
}
