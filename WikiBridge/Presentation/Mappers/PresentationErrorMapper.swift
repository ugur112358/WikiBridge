import Domain

enum PresentationErrorMapper {
    static func map(_ error: Error) -> PresentationError {
        guard let domainError = error as? DomainError else {
            return PresentationError(message: L10n.Errors.unexpected, isRetryable: true)
        }
        switch domainError {
        case .connectivity:
            return PresentationError(message: L10n.Errors.connectivity, isRetryable: true)
        case .invalidData:
            return PresentationError(message: L10n.Errors.invalidData, isRetryable: false)
        case .serverError:
            return PresentationError(message: L10n.Errors.serverError, isRetryable: true)
        }
    }
}
