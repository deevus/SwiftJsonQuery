import Foundation
import ArgumentParser

@main
struct SwiftJsonQuery: ParsableCommand {
    @Argument 
    var jsonPath: String;

    @Argument
    var fileName: String

    func run() throws {
        let jsonPathDict = self.jsonPathToDictionary(self.jsonPath)

        let fileContents = try String(contentsOfFile: self.fileName, encoding: .utf8)

        guard let data = fileContents.data(using: .utf8) else { return }

        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }

        var result: [String: Any] = jsonObject

        for (key) in jsonPathDict {
            guard let child = result[key] as? [String: Any] else { return }

            result = child
        }

        guard let prettyPrintedJson = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else {
            return
        }

        print(String(decoding: prettyPrintedJson, as: UTF8.self))
    }

    func jsonPathToDictionary(_ jsonPath: String) -> [String] {
        jsonPath.split(separator: ".").map { segment in 
            String(segment)
        }
    }
}
