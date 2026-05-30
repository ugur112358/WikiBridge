import Foundation
import Domain
import Observation

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

    @MainActor
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
        LocationItem(
            id: "\(location.coordinate.latitude),\(location.coordinate.longitude)",
            name: location.name ?? L10n.Locations.unknownName,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
    }
}
