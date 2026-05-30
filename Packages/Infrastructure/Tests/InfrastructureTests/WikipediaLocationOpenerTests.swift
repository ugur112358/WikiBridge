import XCTest
import Domain
@testable import Infrastructure

final class WikipediaLocationOpenerTests: XCTestCase {

    func test_open_constructsCorrectWikipediaURL() throws {
        let spy = URLOpenerSpy(canOpen: true)
        let sut = WikipediaLocationOpener(opener: spy)
        let coordinate = try Coordinate(latitude: 52.3676, longitude: 4.9041)

        _ = sut.open(coordinate)

        XCTAssertEqual(spy.openedURL?.scheme, "wikipedia")
        XCTAssertEqual(spy.openedURL?.host, "places")
        XCTAssertTrue(spy.openedURL?.query?.contains("lat=52.3676") ?? false)
        XCTAssertTrue(spy.openedURL?.query?.contains("lon=4.9041") ?? false)
    }

    func test_open_returnsTrueWhenAppAvailable() throws {
        let spy = URLOpenerSpy(canOpen: true)
        let sut = WikipediaLocationOpener(opener: spy)
        let coordinate = try Coordinate(latitude: 52.3676, longitude: 4.9041)

        let result = sut.open(coordinate)

        XCTAssertTrue(result)
    }

    func test_open_returnsFalseWhenAppUnavailable() throws {
        let spy = URLOpenerSpy(canOpen: false)
        let sut = WikipediaLocationOpener(opener: spy)
        let coordinate = try Coordinate(latitude: 52.3676, longitude: 4.9041)

        let result = sut.open(coordinate)

        XCTAssertFalse(result)
    }

    func test_open_doesNotOpenURLWhenAppUnavailable() throws {
        let spy = URLOpenerSpy(canOpen: false)
        let sut = WikipediaLocationOpener(opener: spy)
        let coordinate = try Coordinate(latitude: 52.3676, longitude: 4.9041)

        _ = sut.open(coordinate)

        XCTAssertNil(spy.openedURL)
    }
}

// MARK: - Spy

private final class URLOpenerSpy: URLOpening {
    private let canOpen: Bool
    private(set) var openedURL: URL?

    init(canOpen: Bool) {
        self.canOpen = canOpen
    }

    func canOpenURL(_ url: URL) -> Bool {
        canOpen
    }

    func open(_ url: URL) {
        openedURL = url
    }
}
