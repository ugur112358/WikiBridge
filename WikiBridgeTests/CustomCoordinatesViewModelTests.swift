import XCTest
import Domain
@testable import WikiBridge

final class CustomCoordinatesViewModelTests: XCTestCase {
    // NOTE: Running the iOS 26 simulator on macOS 15.7 causes a runtime crash
    // when combining @MainActor test classes with @Observable objects.
    // As a workaround, MainActor isolation is applied per-test via
    // `await MainActor.run {}`. This should be re-evaluated on macOS 26.
    func test_isInputValid_returnsTrueForValidNumericInput() async {
        await MainActor.run {
            let sut = makeSUT()
            sut.latitudeText = "52.3676"
            sut.longitudeText = "4.9041"
            XCTAssertTrue(sut.isInputValid)
        }

    }

    func test_submit_setsValidationErrorForNonNumericInput() async {
        await MainActor.run {
            let sut = makeSUT()
            sut.latitudeText = "abc"
            sut.longitudeText = "4.9"
            
            sut.submit()
            
            XCTAssertNotNil(sut.validationError)
        }
    }

    func test_submit_clearsValidationErrorOnValidInput() async {
        await MainActor.run {
            let sut = makeSUT()
            sut.latitudeText = "52.3676"
            sut.longitudeText = "4.9041"
            
            sut.submit()
            
            XCTAssertNil(sut.validationError)
        }
    }

    // MARK: - Helpers

    @MainActor
    private func makeSUT(opener: LocationOpenerSpy = LocationOpenerSpy(result: true)) -> CustomCoordinatesViewModel {
        let openUseCase = OpenLocationUseCase(opener: opener)
        return CustomCoordinatesViewModel(openLocationUseCase: openUseCase)
    }
}
