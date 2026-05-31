import XCTest
import Domain
@testable import WikiBridge

@MainActor
final class LocationsViewModelTests: XCTestCase {

    // MARK: - Load Locations

    func test_loadLocations_deliversLoadedStateOnSuccess() async {
        let loader = LocationsLoaderStub(result: .success([makeLocation(name: "Amsterdam", lat: 52.3676, lon: 4.9041)]))
        let sut = makeSUT(loader: loader)

        await sut.loadLocations()

        guard case .loaded(let items) = sut.state else {
            return XCTFail("Expected loaded state, got \(sut.state)")
        }
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items[0].name, "Amsterdam")
        XCTAssertEqual(items[0].latitude, 52.3676)
        XCTAssertEqual(items[0].longitude, 4.9041)
    }

    func test_loadLocations_deliversErrorStateOnFailure() async {
        let loader = LocationsLoaderStub(result: .failure(DomainError.connectivity))
        let sut = makeSUT(loader: loader)

        await sut.loadLocations()

        guard case .error(let error) = sut.state else {
            return XCTFail("Expected error state, got \(sut.state)")
        }
        XCTAssertTrue(error.isRetryable)
    }

    func test_loadLocations_doesNotReloadWhenAlreadyLoaded() async {
        let loader = LocationsLoaderStub(result: .success([makeLocation()]))
        let sut = makeSUT(loader: loader)

        await sut.loadLocations()
        await sut.loadLocations()

        XCTAssertEqual(loader.loadCallCount, 1)
    }

    func test_refreshLocations_reloadsEvenWhenAlreadyLoaded() async {
        let loader = LocationsLoaderStub(result: .success([makeLocation()]))
        let sut = makeSUT(loader: loader)

        await sut.loadLocations()
        await sut.refreshLocations()

        XCTAssertEqual(loader.loadCallCount, 2)
    }

    // MARK: - Open Location

    func test_didSelectLocation_triggersOnOpenFailedWhenOpenerReturnsFalse() async {
        let opener = LocationOpenerSpy(result: false)
        let sut = makeSUT(opener: opener)
        var receivedMessage: String?
        sut.onOpenFailed = { receivedMessage = $0 }

        let item = makeLocationItem()
        sut.didSelectLocation(item)

        XCTAssertNotNil(receivedMessage)
    }

    func test_didSelectLocation_doesNotTriggerOnOpenFailedWhenOpenerSucceeds() async {
        let opener = LocationOpenerSpy(result: true)
        let sut = makeSUT(opener: opener)
        var receivedMessage: String?
        sut.onOpenFailed = { receivedMessage = $0 }

        let item = makeLocationItem()
        sut.didSelectLocation(item)

        XCTAssertNil(receivedMessage)
    }

    // MARK: - Location Name Mapping

    func test_loadLocations_mapsNilNameToUnknown() async {
        let loader = LocationsLoaderStub(result: .success([makeLocation(name: nil)]))
        let sut = makeSUT(loader: loader)

        await sut.loadLocations()

        guard case .loaded(let items) = sut.state else {
            return XCTFail("Expected loaded state, got \(sut.state)")
        }
        XCTAssertEqual(items[0].name, L10n.Locations.unknownName)
    }

    // MARK: - Helpers

    private func makeSUT(
        loader: LocationsLoaderStub = LocationsLoaderStub(result: .success([])),
        opener: LocationOpenerSpy = LocationOpenerSpy(result: true)
    ) -> LocationsViewModel {
        let fetchUseCase = FetchLocationsUseCase(loader: loader)
        let openUseCase = OpenLocationUseCase(opener: opener)
        return LocationsViewModel(fetchLocationsUseCase: fetchUseCase, openLocationUseCase: openUseCase)
    }

    private func makeLocation(name: String? = "Test", lat: Double = 1.0, lon: Double = 2.0) -> Location {
        Location(name: name, coordinate: try! Coordinate(latitude: lat, longitude: lon))
    }

    private func makeLocationItem(lat: Double = 52.3676, lon: Double = 4.9041) -> LocationItem {
        LocationItem(
            id: "test,\(lat),\(lon)",
            name: "Test",
            latitude: lat,
            longitude: lon,
            formattedCoordinates: "\(lat), \(lon)",
            accessibilityLabel: "Test, \(lat), \(lon)"
        )
    }
}
