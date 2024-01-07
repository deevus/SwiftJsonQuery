import Foundation
import ArgumentParser
import SwiftPath

@main
struct SwiftJsonQuery: ParsableCommand {
    @Argument 
    var jsonPath: String;

    @Argument
    var fileName: String

    func run() throws {
        guard let jsonPath = JsonPath(self.jsonPath) else {
            throw JsonQueryError.invalidJsonPath(self.jsonPath)
        }

        guard let fileContents = try String(contentsOfFile: self.fileName, encoding: .utf8) as String? else { 
            throw JsonQueryError.fileReadError
        }

        guard let data = fileContents.data(using: .utf8) else { 
            throw JsonQueryError.dataError 
        }

        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw JsonQueryError.invalidJsonInput
        }

        guard let result = try jsonPath.evaluate(with: jsonObject) else {
            throw JsonQueryError.jsonPathEvaluationError
        }

        var output = try ConsoleOutput.init(result)

        print("\u{001B}[0;33m\(try output.string())")
    }
}
