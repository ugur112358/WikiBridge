import XCTest
import Domain
@testable import Infrastructure

final class RemoteLocationsLoaderTests: XCTestCase {

    func test_load_deliversEmptyListOnEmptyResponse() async throws {
        let client = HTTPClientSpy(result: .success(makeEmptyJSON()))
        let sut = RemoteLocationsLoader(client: client, url: anyURL())

        let locations = try await sut.load()

        XCTAssertEqual(locations, [])
    }

    func test_load_deliversLocationsOnValidResponse() async throws {
        let client = HTTPClientSpy(result: .success(makeValidJSON()))
        let sut = RemoteLocationsLoader(client: client, url: anyURL())

        let locations = try await sut.load()

        XCTAssertEqual(locations.count, 1)
        XCTAssertEqual(locations[0].name, "Amsterdam")
        XCTAssertEqual(locations[0].coordinate.latitude, 52.3676)
        XCTAssertEqual(locations[0].coordinate.longitude, 4.9041)
    }

    func test_load_filtersLocationsWithInvalidCoordinates() async throws {
        let client = HTTPClientSpy(result: .success(makeInvalidCoordinateJSON()))
        let sut = RemoteLocationsLoader(client: client, url: anyURL())

        let locations = try await sut.load()

        XCTAssertEqual(locations, [])
    }

    func test_load_throwsConnectivityErrorOnClientError() async {
        let client = HTTPClientSpy(result: .failure(anyError()))
        let sut = RemoteLocationsLoader(client: client, url: anyURL())

        do {
            _ = try await sut.load()
            XCTFail("Expected error")
        } catch {
            XCTAssertEqual(error as? DomainError, .connectivity)
        }
    }

    func test_load_throwsInvalidDataOnInvalidJSON() async {
        let client = HTTPClientSpy(result: .success(Data("invalid".utf8)))
        let sut = RemoteLocationsLoader(client: client, url: anyURL())

        do {
            _ = try await sut.load()
            XCTFail("Expected error")
        } catch {
            XCTAssertEqual(error as? DomainError, .invalidData)
        }
    }

    // MARK: - Helpers

    private func anyURL() -> URL {
        URL(string: "https://any-url.com")!
    }

    private func anyError() -> Error {
        NSError(domain: "test", code: 0)
    }

    private func makeEmptyJSON() -> Data {
        let json = ["locations": []]
        return try! JSONSerialization.data(withJSONObject: json)
    }

    private func makeValidJSON() -> Data {
        let json: [String: Any] = [
            "locations": [
                ["name": "Amsterdam", "lat": 52.3676, "long": 4.9041]
            ]
        ]
        return try! JSONSerialization.data(withJSONObject: json)
    }

    private func makeInvalidCoordinateJSON() -> Data {
        let json: [String: Any] = [
            "locations": [
                ["name": "Invalid", "lat": 999.0, "long": 4.9041]
            ]
        ]
        return try! JSONSerialization.data(withJSONObject: json)
    }
}

// MARK: - Spy

private final class HTTPClientSpy: HTTPClient {
    private let result: Result<Data, Error>

    init(result: Result<Data, Error>) {
        self.result = result
    }

    func fetch(from url: URL) async throws -> Data {
        try result.get()
    }
}
