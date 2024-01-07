enum JsonQueryError: Error {
    case invalidJsonPath(_ path: String)
    case invalidJsonInput
    case fileReadError
    case dataError
    case jsonPathEvaluationError
}
