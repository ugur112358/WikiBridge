public protocol LocationOpener {
    @discardableResult
    func open(_ coordinate: Coordinate) -> Bool
}
