import SwiftUI

struct CustomCoordinatesView: View {
    @Bindable var viewModel: CustomCoordinatesViewModel

    var body: some View {
        Form {
            Section("Coordinates") {
                TextField("Latitude (-90 to 90)", text: $viewModel.latitudeText)
                    .keyboardType(.decimalPad)

                TextField("Longitude (-180 to 180)", text: $viewModel.longitudeText)
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
                Button("Open in Wikipedia") {
                    viewModel.submit()
                }
                .disabled(!viewModel.isInputValid)
            }
        }
        .navigationTitle("Custom Location")
    }
}
