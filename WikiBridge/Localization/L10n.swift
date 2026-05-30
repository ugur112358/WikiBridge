import Foundation

enum L10n {
    enum Locations {
        static let title = String(localized: "locations.title")
        static let loading = String(localized: "locations.loading")
        static let empty = String(localized: "locations.empty")
        static let unknownName = String(localized: "locations.unknown_name")
        static let customButton = String(localized: "locations.custom_button")
        
        static func coordinateFormat(lat: String, lon: String) -> String {
            String(format: String(localized: "locations.coordinate_format"), lat, lon)
        }
    }
    
    enum CustomCoordinates {
        static let title = String(localized: "custom_coordinates.title")
        static let latitudePlaceholder = String(localized: "custom_coordinates.latitude_placeholder")
        static let longitudePlaceholder = String(localized: "custom_coordinates.longitude_placeholder")
        static let submitButton = String(localized: "custom_coordinates.submit_button")
        static let validationError = String(localized: "custom_coordinates.validation_error")
        static let sectionTitle = String(localized: "custom_coordinates.section_title")
    }
    
    enum Errors {
        static let connectivity = String(localized: "errors.connectivity")
        static let invalidData = String(localized: "errors.invalid_data")
        static let serverError = String(localized: "errors.server_error")
        static let unexpected = String(localized: "errors.unexpected")
        static let retryButton = String(localized: "errors.retry_button")
        static let wikipediaUnavailable = String(localized: "errors.wikipedia_unavailable")
        static let invalidCoordinates = String(localized: "errors.invalid_coordinates")
        static let alertTitle = String(localized: "errors.alert_title")
    }
    
    enum Accessibility {
        static let locationRow = String(localized: "accessibility.location_row")
        static let latitudeField = String(localized: "accessibility.latitude_field")
        static let longitudeField = String(localized: "accessibility.longitude_field")
        static let locationRowHint = String(localized: "accessibility.location_row_hint")
    }
    
    enum General {
        static let ok = String(localized: "general.ok")
    }
}
