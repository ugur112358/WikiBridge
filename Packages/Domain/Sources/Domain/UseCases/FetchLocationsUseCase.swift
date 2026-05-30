public struct FetchLocationsUseCase {
    private let loader: LocationsLoader

    public init(loader: LocationsLoader) {
        self.loader = loader
    }

    public func execute() async throws -> [Location] {
        try await loader.load()
    }
}
