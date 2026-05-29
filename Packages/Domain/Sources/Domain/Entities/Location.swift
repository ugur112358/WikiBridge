public struct Location: Equatable, Hashable {
    public let name: String?
    public let coordinate: Coordinate

    public init(name: String?, coordinate: Coordinate) {
        self.name = name
        self.coordinate = coordinate
    }
}
