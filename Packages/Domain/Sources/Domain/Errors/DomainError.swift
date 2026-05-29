public enum DomainError: Error, Equatable {
    case connectivity
    case invalidData
    case serverError(statusCode: Int)
}
