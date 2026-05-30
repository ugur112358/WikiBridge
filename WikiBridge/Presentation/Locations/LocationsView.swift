import SwiftUI

struct LocationsView: View {
    @Bindable var viewModel: LocationsViewModel

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle:
                Color.clear

            case .loading:
                ProgressView()

            case .loaded(let locations):
                locationsList(locations)

            case .error(let error):
                errorView(error)
            }
        }
        .navigationTitle("Locations")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Custom") {
                    viewModel.didTapCustomCoordinates()
                }
            }
        }
        .task {
            await viewModel.loadLocations()
        }
    }

    // MARK: - Subviews

    private func locationsList(_ locations: [LocationItem]) -> some View {
        List(locations, id: \.self) { location in
            Button {
                viewModel.didSelectLocation(location)
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text(location.name)
                        .font(.headline)
                    Text("Lat: \(location.latitude, specifier: "%.4f"), Lon: \(location.longitude, specifier: "%.4f")")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .buttonStyle(.plain)
        }
    }

    private func errorView(_ error: PresentationError) -> some View {
        VStack(spacing: 16) {
            Text(error.message)
                .multilineTextAlignment(.center)

            if error.isRetryable {
                Button("Try Again") {
                    Task { await viewModel.loadLocations() }
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
}
