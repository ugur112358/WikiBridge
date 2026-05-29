import Foundation

struct LocationsResponseDTO: Decodable {
    let locations: [LocationDTO]
}

struct LocationDTO: Decodable {
    let name: String?
    let lat: Double?
    let long: Double?
}
