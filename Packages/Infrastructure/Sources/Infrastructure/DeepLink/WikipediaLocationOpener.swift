import Foundation
import Domain

public struct WikipediaLocationOpener: LocationOpener {
    private let opener: URLOpening

    public init(opener: URLOpening) {
        self.opener = opener
    }

    @discardableResult
    public func open(_ coordinate: Coordinate) -> Bool {
        guard let url = makeURL(coordinate) else { return false }
        guard opener.canOpenURL(url) else { return false }
        opener.open(url)
        return true
    }

    private func makeURL(_ coordinate: Coordinate) -> URL? {
        var components = URLComponents()
        components.scheme = "wikipedia"
        components.host = "places"
        components.queryItems = [
            URLQueryItem(name: "lat", value: "\(coordinate.latitude)"),
            URLQueryItem(name: "lon", value: "\(coordinate.longitude)")
        ]
        return components.url
    }
}

