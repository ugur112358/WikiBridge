import Foundation

public enum HTTPClientError: Error, Equatable {
    case invalidResponse
    case serverError(statusCode: Int)
}
