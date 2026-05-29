public struct Coordinate: Equatable, Hashable {
    public let latitude: Double
    public let longitude: Double

    public enum ValidationError: Error, Equatable {
        case invalidLatitude(Double)
        case invalidLongitude(Double)
    }

    public init(latitude: Double, longitude: Double) throws {
        guard (-90...90).contains(latitude) else {
            throw ValidationError.invalidLatitude(latitude)
        }
        guard (-180...180).contains(longitude) else {
            throw ValidationError.invalidLongitude(longitude)
        }
        self.latitude = latitude
        self.longitude = longitude
    }
}
