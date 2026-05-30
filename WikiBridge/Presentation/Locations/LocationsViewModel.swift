import Foundation
import Domain
import Observation

@Observable
final class LocationsViewModel {
    private(set) var state: ViewState<[LocationItem]> = .idle
    
    // MARK: - Events (Coordinator listens to these)
    var onLocationSelected: ((Double, Double) -> Void)?
    var onCustomCoordinatesTapped: (() -> Void)?

    private let fetchLocationsUseCase: FetchLocationsUseCase

    init(fetchLocationsUseCase: FetchLocationsUseCase) {
        self.fetchLocationsUseCase = fetchLocationsUseCase
    }

    @MainActor
    func loadLocations() async {
        state = .loading
        do {
            let locations = try await fetchLocationsUseCase.execute()
            state = .loaded(locations.map { mapToItem($0) })
        } catch {
            state = .error(mapError(error))
        }
    }

    func didSelectLocation(_ item: LocationItem) {
        onLocationSelected?(item.latitude, item.longitude)
    }

    func didTapCustomCoordinates() {
        onCustomCoordinatesTapped?()
    }
    
    private func mapToItem(_ location: Location) -> LocationItem {
        LocationItem(
            id: "\(location.coordinate.latitude),\(location.coordinate.longitude)",
            name: location.name ?? "Unknown Location",
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
    }

    // MARK: - Error Mapping

    private func mapError(_ error: Error) -> PresentationError {
        guard let domainError = error as? DomainError else {
            return PresentationError(message: "An unexpected error occurred.", isRetryable: true)
        }
        switch domainError {
        case .connectivity:
            return PresentationError(message: "Please check your internet connection and try again.", isRetryable: true)
        case .invalidData:
            return PresentationError(message: "Something went wrong. Please try again later.", isRetryable: false)
        case .serverError:
            return PresentationError(message: "Server is temporarily unavailable. Please try again.", isRetryable: true)
        }
    }
}
