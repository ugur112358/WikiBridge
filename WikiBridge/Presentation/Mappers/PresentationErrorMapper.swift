import Domain

enum PresentationErrorMapper {
    static func map(_ error: Error) -> PresentationError {
        guard let domainError = error as? DomainError else {
            return PresentationError(message: "An unexpected error occurred.", isRetryable: true)
        }
        switch domainError {
        case .connectivity:
            return PresentationError(message: "Please check your internet connection and try again.", isRetryable: true)
        case .invalidData:
            return PresentationError(message: "Something went wrong. Please try again later.", isRetryable: false)
        case .serverError:
            return PresentationError(message: "Server is temporarily unavailable. Please try again.", isRetryable: true)
        }
    }
}
