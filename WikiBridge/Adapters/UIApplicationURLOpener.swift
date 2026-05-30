import UIKit
import Infrastructure

final class UIApplicationURLOpener: URLOpening {
    func canOpenURL(_ url: URL) -> Bool {
        UIApplication.shared.canOpenURL(url)
    }

    func open(_ url: URL) {
        UIApplication.shared.open(url)
    }
}
