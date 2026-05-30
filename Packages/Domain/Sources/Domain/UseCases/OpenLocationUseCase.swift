public struct OpenLocationUseCase {
    private let opener: LocationOpener

    public init(opener: LocationOpener) {
        self.opener = opener
    }

    @discardableResult
    public func execute(latitude: Double, longitude: Double) throws -> Bool {
        let coordinate = try Coordinate(latitude: latitude, longitude: longitude)
        return opener.open(coordinate)
    }
}
