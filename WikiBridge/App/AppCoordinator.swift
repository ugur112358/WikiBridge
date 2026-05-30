import UIKit
import Domain
import Infrastructure

final class AppCoordinator {
    private let navigationController: UINavigationController
    private var locationsCoordinator: LocationsCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let locationsCoordinator = makeLocationsCoordinator()
        self.locationsCoordinator = locationsCoordinator
        locationsCoordinator.start()
    }

    // MARK: - Composition Root

    private func makeLocationsCoordinator() -> LocationsCoordinator {
        let httpClient = URLSessionHTTPClient()
        guard let url = URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json") else {
            fatalError("Invalid API URL configuration")
        }
        let loader = RemoteLocationsLoader(client: httpClient, url: url)
        let fetchUseCase = FetchLocationsUseCase(loader: loader)

        let urlOpener = UIApplicationURLOpener()
        let locationOpener = WikipediaLocationOpener(opener: urlOpener)
        let openUseCase = OpenLocationUseCase(opener: locationOpener)

        return LocationsCoordinator(
            navigationController: navigationController,
            fetchLocationsUseCase: fetchUseCase,
            openLocationUseCase: openUseCase
        )
    }
}
