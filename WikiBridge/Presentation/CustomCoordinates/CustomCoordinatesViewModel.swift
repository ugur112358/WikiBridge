import Foundation
import Domain
import Observation

@Observable
final class CustomCoordinatesViewModel {
    var latitudeText: String = ""
    var longitudeText: String = ""
    private(set) var validationError: String?

    // MARK: - Events (Coordinator listens to these)
    var onSubmit: ((Double, Double) -> Void)?

    var isInputValid: Bool {
        parseLatitude() != nil && parseLongitude() != nil
    }

    func submit() {
        guard let latitude = parseLatitude(),
              let longitude = parseLongitude() else {
            validationError = "Please enter valid coordinates."
            return
        }
        validationError = nil
        onSubmit?(latitude, longitude)
    }

    // MARK: - Private

    private func parseLatitude() -> Double? {
        guard let value = Double(latitudeText),
              (-90...90).contains(value) else { return nil }
        return value
    }

    private func parseLongitude() -> Double? {
        guard let value = Double(longitudeText),
              (-180...180).contains(value) else { return nil }
        return value
    }
}
