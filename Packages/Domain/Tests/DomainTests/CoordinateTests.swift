import XCTest
@testable import Domain

final class CoordinateTests: XCTestCase {

    // MARK: - Valid Coordinates

    func test_init_withValidCoordinates_createsCoordinate() throws {
        let coordinate = try Coordinate(latitude: 52.3676, longitude: 4.9041)

        XCTAssertEqual(coordinate.latitude, 52.3676)
        XCTAssertEqual(coordinate.longitude, 4.9041)
    }

    func test_init_withMinBounds_createsCoordinate() throws {
        let coordinate = try Coordinate(latitude: -90, longitude: -180)

        XCTAssertEqual(coordinate.latitude, -90)
        XCTAssertEqual(coordinate.longitude, -180)
    }

    func test_init_withMaxBounds_createsCoordinate() throws {
        let coordinate = try Coordinate(latitude: 90, longitude: 180)

        XCTAssertEqual(coordinate.latitude, 90)
        XCTAssertEqual(coordinate.longitude, 180)
    }

    func test_init_withZeroCoordinates_createsCoordinate() throws {
        let coordinate = try Coordinate(latitude: 0, longitude: 0)

        XCTAssertEqual(coordinate.latitude, 0)
        XCTAssertEqual(coordinate.longitude, 0)
    }

    // MARK: - Invalid Latitude

    func test_init_withLatitudeAbove90_throwsInvalidLatitude() {
        XCTAssertThrowsError(try Coordinate(latitude: 90.1, longitude: 0)) { error in
            XCTAssertEqual(error as? Coordinate.ValidationError, .invalidLatitude(90.1))
        }
    }

    func test_init_withLatitudeBelow90_throwsInvalidLatitude() {
        XCTAssertThrowsError(try Coordinate(latitude: -90.1, longitude: 0)) { error in
            XCTAssertEqual(error as? Coordinate.ValidationError, .invalidLatitude(-90.1))
        }
    }

    // MARK: - Invalid Longitude

    func test_init_withLongitudeAbove180_throwsInvalidLongitude() {
        XCTAssertThrowsError(try Coordinate(latitude: 0, longitude: 180.1)) { error in
            XCTAssertEqual(error as? Coordinate.ValidationError, .invalidLongitude(180.1))
        }
    }

    func test_init_withLongitudeBelow180_throwsInvalidLongitude() {
        XCTAssertThrowsError(try Coordinate(latitude: 0, longitude: -180.1)) { error in
            XCTAssertEqual(error as? Coordinate.ValidationError, .invalidLongitude(-180.1))
        }
    }

    // MARK: - Equality

    func test_equality_sameValues_areEqual() throws {
        let a = try Coordinate(latitude: 1.0, longitude: 2.0)
        let b = try Coordinate(latitude: 1.0, longitude: 2.0)

        XCTAssertEqual(a, b)
    }

    func test_equality_differentValues_areNotEqual() throws {
        let a = try Coordinate(latitude: 1.0, longitude: 2.0)
        let b = try Coordinate(latitude: 3.0, longitude: 4.0)

        XCTAssertNotEqual(a, b)
    }
}
