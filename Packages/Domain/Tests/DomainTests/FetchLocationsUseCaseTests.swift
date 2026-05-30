import XCTest
@testable import Domain

final class FetchLocationsUseCaseTests: XCTestCase {

    func test_execute_returnsLocationsFromLoader() async throws {
        let expected = [makeLocation(name: "Amsterdam", lat: 52.3676, lon: 4.9041)]
        let loader = LocationsLoaderStub(result: .success(expected))
        let sut = FetchLocationsUseCase(loader: loader)

        let result = try await sut.execute()

        XCTAssertEqual(result, expected)
    }

    func test_execute_throwsErrorFromLoader() async {
        let loader = LocationsLoaderStub(result: .failure(DomainError.connectivity))
        let sut = FetchLocationsUseCase(loader: loader)

        do {
            _ = try await sut.execute()
            XCTFail("Expected error")
        } catch {
            XCTAssertEqual(error as? DomainError, .connectivity)
        }
    }

    // MARK: - Helpers

    private func makeLocation(name: String, lat: Double, lon: Double) -> Location {
        Location(name: name, coordinate: try! Coordinate(latitude: lat, longitude: lon))
    }
}

// MARK: - Stub

private final class LocationsLoaderStub: LocationsLoader {
    private let result: Result<[Location], Error>

    init(result: Result<[Location], Error>) {
        self.result = result
    }

    func load() async throws -> [Location] {
        try result.get()
    }
}
