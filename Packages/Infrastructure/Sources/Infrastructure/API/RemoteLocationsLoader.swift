import Foundation
import Domain

public final class RemoteLocationsLoader: LocationsLoader {
    private let client: HTTPClient
    private let url: URL

    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }

    public func load() async throws -> [Location] {
        let data: Data
        
        do {
            data = try await client.fetch(from: url)
        } catch let error as HTTPClientError {
            switch error {
            case .serverError(let statusCode):
                throw DomainError.serverError(statusCode: statusCode)
            case .invalidResponse:
                throw DomainError.invalidData
            }
        } catch {
            throw DomainError.connectivity
        }
        
        do {
            let response = try JSONDecoder().decode(LocationsResponseDTO.self, from: data)
            return map(response.locations)
        } catch {
            throw DomainError.invalidData
        }
    }

    private func map(_ dtos: [LocationDTO]) -> [Location] {
        dtos.compactMap { dto in
            guard let lat = dto.lat,
                  let lon = dto.long,
                  let coordinate = try? Coordinate(latitude: lat, longitude: lon) else {
                return nil
            }
            return Location(name: dto.name, coordinate: coordinate)
        }
    }
}

