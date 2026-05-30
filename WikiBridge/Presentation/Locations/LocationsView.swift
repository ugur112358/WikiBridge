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
                if locations.isEmpty {
                    emptyView
                } else {
                    locationsList(locations)
                }

            case .error(let error):
                errorView(error)
            }
        }
        .navigationTitle(L10n.Locations.title)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(L10n.Locations.customButton) {
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
        List(locations) { location in
            Button {
                viewModel.didSelectLocation(location)
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text(location.name)
                        .font(.headline)
                    Text(location.formattedCoordinates)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .buttonStyle(.plain)
            .accessibilityElement(children: .combine)
            .accessibilityLabel(location.accessibilityLabel)
            .accessibilityHint(L10n.Accessibility.locationRowHint)
        }
        .refreshable {
            await viewModel.loadLocations()
        }
    }

    private func errorView(_ error: PresentationError) -> some View {
        VStack(spacing: 16) {
            Text(error.message)
                .multilineTextAlignment(.center)

            if error.isRetryable {
                Button(L10n.Errors.retryButton) {
                    Task { await viewModel.loadLocations() }
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
    
    private var emptyView: some View {
        ContentUnavailableView(
            L10n.Locations.empty,
            systemImage: "map",
            description: nil
        )
    }
}
