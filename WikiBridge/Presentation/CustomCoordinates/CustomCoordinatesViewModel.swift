import Foundation
import Domain
import Observation

@MainActor
@Observable
final class CustomCoordinatesViewModel {
    var latitudeText: String = ""
    var longitudeText: String = ""
    private(set) var validationError: String?

    // MARK: - Events (Coordinator listens to these)
    @ObservationIgnored var onOpenFailed: ((String) -> Void)?

    private let openLocationUseCase: OpenLocationUseCase

    init(openLocationUseCase: OpenLocationUseCase) {
        self.openLocationUseCase = openLocationUseCase
    }

    var isInputValid: Bool {
        Double(latitudeText) != nil && Double(longitudeText) != nil
    }

    func submit() {
        guard let latitude = Double(latitudeText),
              let longitude = Double(longitudeText) else {
            validationError = L10n.CustomCoordinates.validationError
            return
        }
        validationError = nil

        do {
            let success = try openLocationUseCase.execute(latitude: latitude, longitude: longitude)
            if !success {
                onOpenFailed?(L10n.Errors.wikipediaUnavailable)
            }
        } catch {
            onOpenFailed?(L10n.Errors.invalidCoordinates)
        }
    }
}
