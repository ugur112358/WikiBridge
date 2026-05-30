struct LocationItem: Equatable, Hashable, Identifiable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
    let formattedCoordinates: String
    let accessibilityLabel: String
}
