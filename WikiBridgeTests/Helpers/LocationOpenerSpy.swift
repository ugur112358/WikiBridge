import Domain

final class LocationOpenerSpy: LocationOpener {
    private let result: Bool
    private(set) var openedCoordinates: [Coordinate] = []

    init(result: Bool) {
        self.result = result
    }

    func open(_ coordinate: Coordinate) -> Bool {
        openedCoordinates.append(coordinate)
        return result
    }
}
