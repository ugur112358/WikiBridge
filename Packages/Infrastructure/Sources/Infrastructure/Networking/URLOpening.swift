import Foundation

public protocol URLOpening {
    func canOpenURL(_ url: URL) -> Bool
    func open(_ url: URL)
}
