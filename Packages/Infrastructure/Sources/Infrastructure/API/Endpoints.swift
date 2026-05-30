import Foundation

public enum Endpoints {
    public static let locations: URL = {
        guard let url = URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json") else {
            preconditionFailure("Invalid locations endpoint URL")
        }
        return url
    }()
}
