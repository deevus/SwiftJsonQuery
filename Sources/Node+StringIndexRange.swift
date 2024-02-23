import SwiftTreeSitter
import TreeSitterJSON

extension Node {
    func stringRange(in sourceString: String) -> Range<String.Index> {
        let lowerBound = String.Index(utf16Offset: range.lowerBound, in: sourceString)

        let upperBound = String.Index(utf16Offset: range.upperBound, in: sourceString)

        return Range.init(uncheckedBounds: (lowerBound, upperBound));
    }
}
