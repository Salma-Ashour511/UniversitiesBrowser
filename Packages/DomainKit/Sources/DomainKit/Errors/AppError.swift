import Foundation

/// A domain-level error used to drive UI state.
///
/// The data/network layers throw their own granular errors; the repository
/// translates them into these user-facing cases so feature modules never have
/// to import `NetworkKit` or `PersistenceKit` just to read an error.
public enum AppError: Error, Equatable, Sendable {

    /// Both the network request and the local cache failed to produce data.
    case noData

    /// A connectivity / transport problem occurred and no cache was available.
    case network

    /// Any other unexpected failure.
    case unknown

    public var userMessage: String {
        switch self {
        case .noData:
            return "No universities found. Please try again."
        case .network:
            return "We couldn't reach the server. Check your connection and try again."
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}
