import Domain

final class LocationsLoaderStub: LocationsLoader {
    private let result: Result<[Location], Error>
    private(set) var loadCallCount = 0

    init(result: Result<[Location], Error>) {
        self.result = result
    }

    func load() async throws -> [Location] {
        loadCallCount += 1
        return try result.get()
    }
}
