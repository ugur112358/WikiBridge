import Foundation

public protocol HTTPClient {
    func fetch(from url: URL) async throws -> Data
}
