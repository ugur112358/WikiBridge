import UIKit
import SwiftUI
import Domain

final class LocationsCoordinator {
    private let navigationController: UINavigationController
    private let fetchLocationsUseCase: FetchLocationsUseCase
    private let openLocationUseCase: OpenLocationUseCase

    init(
        navigationController: UINavigationController,
        fetchLocationsUseCase: FetchLocationsUseCase,
        openLocationUseCase: OpenLocationUseCase
    ) {
        self.navigationController = navigationController
        self.fetchLocationsUseCase = fetchLocationsUseCase
        self.openLocationUseCase = openLocationUseCase
    }

    func start() {
        let viewModel = makeLocationsViewModel()
        let view = LocationsView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: view)
        navigationController.setViewControllers([hostingController], animated: false)
    }

    // MARK: - Factory

    private func makeLocationsViewModel() -> LocationsViewModel {
        let viewModel = LocationsViewModel(fetchLocationsUseCase: fetchLocationsUseCase)

        viewModel.onLocationSelected = { [weak self] latitude, longitude in
            self?.openLocation(latitude: latitude, longitude: longitude)
        }

        viewModel.onCustomCoordinatesTapped = { [weak self] in
            self?.showCustomCoordinates()
        }

        return viewModel
    }

    private func makeCustomCoordinatesViewModel() -> CustomCoordinatesViewModel {
        let viewModel = CustomCoordinatesViewModel()

        viewModel.onSubmit = { [weak self] latitude, longitude in
            self?.openLocation(latitude: latitude, longitude: longitude)
        }

        return viewModel
    }

    // MARK: - Navigation

    private func showCustomCoordinates() {
        let viewModel = makeCustomCoordinatesViewModel()
        let view = CustomCoordinatesView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: view)
        navigationController.pushViewController(hostingController, animated: true)
    }

    // MARK: - Actions

    private func openLocation(latitude: Double, longitude: Double) {
        do {
            let success = try openLocationUseCase.execute(latitude: latitude, longitude: longitude)
            if !success {
                showAlert(message: L10n.Errors.wikipediaUnavailable)
            }
        } catch {
            showAlert(message: L10n.Errors.invalidCoordinates)
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: L10n.Errors.alertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.General.ok, style: .default))
        navigationController.topViewController?.present(alert, animated: true)
    }
}
