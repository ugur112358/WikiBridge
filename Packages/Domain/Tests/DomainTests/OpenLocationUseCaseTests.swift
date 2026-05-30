import XCTest
@testable import Domain

final class OpenLocationUseCaseTests: XCTestCase {

    func test_execute_withValidCoordinates_callsOpener() throws {
        let spy = LocationOpenerSpy(result: true)
        let sut = OpenLocationUseCase(opener: spy)

        _ = try sut.execute(latitude: 52.3676, longitude: 4.9041)

        XCTAssertEqual(spy.openedCoordinate, try Coordinate(latitude: 52.3676, longitude: 4.9041))
    }

    func test_execute_withValidCoordinates_returnsTrueWhenOpenerSucceeds() throws {
        let spy = LocationOpenerSpy(result: true)
        let sut = OpenLocationUseCase(opener: spy)

        let result = try sut.execute(latitude: 52.3676, longitude: 4.9041)

        XCTAssertTrue(result)
    }

    func test_execute_withValidCoordinates_returnsFalseWhenOpenerFails() throws {
        let spy = LocationOpenerSpy(result: false)
        let sut = OpenLocationUseCase(opener: spy)

        let result = try sut.execute(latitude: 52.3676, longitude: 4.9041)

        XCTAssertFalse(result)
    }

    func test_execute_withInvalidLatitude_throwsValidationError() {
        let spy = LocationOpenerSpy(result: true)
        let sut = OpenLocationUseCase(opener: spy)

        XCTAssertThrowsError(try sut.execute(latitude: 91.0, longitude: 4.9041)) { error in
            XCTAssertEqual(error as? Coordinate.ValidationError, .invalidLatitude(91.0))
        }
    }

    func test_execute_withInvalidLongitude_throwsValidationError() {
        let spy = LocationOpenerSpy(result: true)
        let sut = OpenLocationUseCase(opener: spy)

        XCTAssertThrowsError(try sut.execute(latitude: 52.3676, longitude: 181.0)) { error in
            XCTAssertEqual(error as? Coordinate.ValidationError, .invalidLongitude(181.0))
        }
    }

    func test_execute_withInvalidCoordinates_doesNotCallOpener() {
        let spy = LocationOpenerSpy(result: true)
        let sut = OpenLocationUseCase(opener: spy)

        _ = try? sut.execute(latitude: 91.0, longitude: 4.9041)

        XCTAssertNil(spy.openedCoordinate)
    }
}

// MARK: - Spy

private final class LocationOpenerSpy: LocationOpener {
    private let result: Bool
    private(set) var openedCoordinate: Coordinate?

    init(result: Bool) {
        self.result = result
    }

    @discardableResult
    func open(_ coordinate: Coordinate) -> Bool {
        openedCoordinate = coordinate
        return result
    }
}
