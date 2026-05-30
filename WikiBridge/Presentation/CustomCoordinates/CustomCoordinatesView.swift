import SwiftUI

struct CustomCoordinatesView: View {
    @Bindable var viewModel: CustomCoordinatesViewModel

    var body: some View {
        Form {
            Section(L10n.CustomCoordinates.sectionTitle) {
                TextField(L10n.CustomCoordinates.latitudePlaceholder, text: $viewModel.latitudeText)
                    .keyboardType(.decimalPad)

                TextField(L10n.CustomCoordinates.longitudePlaceholder, text: $viewModel.longitudeText)
                    .keyboardType(.decimalPad)
            }

            if let error = viewModel.validationError {
                Section {
                    Text(error)
                        .foregroundStyle(.red)
                        .font(.caption)
                }
            }

            Section {
                Button(L10n.CustomCoordinates.submitButton) {
                    viewModel.submit()
                }
                .disabled(!viewModel.isInputValid)
            }
        }
        .navigationTitle(L10n.CustomCoordinates.title)
    }
}
