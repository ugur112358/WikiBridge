import Foundation
import Domain
import Observation

@MainActor
@Observable
final class LocationsViewModel {
    private(set) var state: ViewState<[LocationItem]> = .idle

    // MARK: - Events (Coordinator listens to these)
    @ObservationIgnored var onCustomCoordinatesTapped: (() -> Void)?
    @ObservationIgnored var onOpenFailed: ((String) -> Void)?

    private let fetchLocationsUseCase: FetchLocationsUseCase
    private let openLocationUseCase: OpenLocationUseCase

    init(fetchLocationsUseCase: FetchLocationsUseCase, openLocationUseCase: OpenLocationUseCase) {
        self.fetchLocationsUseCase = fetchLocationsUseCase
        self.openLocationUseCase = openLocationUseCase
    }

    func loadLocations() async {
        state = .loading
        do {
            let locations = try await fetchLocationsUseCase.execute()
            state = .loaded(locations.map { mapToItem($0) })
        } catch {
            state = .error(PresentationErrorMapper.map(error))
        }
    }

    func didSelectLocation(_ item: LocationItem) {
        openLocation(latitude: item.latitude, longitude: item.longitude)
    }

    func didTapCustomCoordinates() {
        onCustomCoordinatesTapped?()
    }

    private func openLocation(latitude: Double, longitude: Double) {
        do {
            let success = try openLocationUseCase.execute(latitude: latitude, longitude: longitude)
            if !success {
                onOpenFailed?(L10n.Errors.wikipediaUnavailable)
            }
        } catch {
            onOpenFailed?(L10n.Errors.invalidCoordinates)
        }
    }

    private func mapToItem(_ location: Location) -> LocationItem {
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        let name = location.name ?? L10n.Locations.unknownName
        let formattedCoordinates = L10n.Locations.coordinateFormat(
            lat: String(format: "%.4f", lat),
            lon: String(format: "%.4f", lon)
        )

        return LocationItem(
            id: "\(name),\(lat),\(lon)",
            name: name,
            latitude: lat,
            longitude: lon,
            formattedCoordinates: formattedCoordinates,
            accessibilityLabel: "\(name), \(formattedCoordinates)"
        )
    }
}
