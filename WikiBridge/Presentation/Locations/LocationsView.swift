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
                Button {
                    viewModel.didTapCustomCoordinates()
                } label: {
                    Image(systemName: "location.magnifyingglass")
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
                HStack(spacing: 12) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.blue)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(location.name)
                            .font(.headline)
                        Text(location.formattedCoordinates)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "arrow.up.right.square")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
            }
            .buttonStyle(.plain)
            .accessibilityElement(children: .combine)
            .accessibilityLabel(location.accessibilityLabel)
            .accessibilityHint(L10n.Accessibility.locationRowHint)
        }
        .refreshable {
            await viewModel.refreshLocations()
        }
    }

    private func errorView(_ error: PresentationError) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundStyle(.orange)
            
            Text(error.message)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            
            if error.isRetryable {
                Button {
                    Task { await viewModel.loadLocations() }
                } label: {
                    Label(L10n.Errors.retryButton, systemImage: "arrow.clockwise")
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
