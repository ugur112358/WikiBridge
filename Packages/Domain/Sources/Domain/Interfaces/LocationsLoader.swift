public protocol LocationsLoader {
    func load() async throws -> [Location]
}
