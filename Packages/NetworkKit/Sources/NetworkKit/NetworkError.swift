import Foundation

/// Transport- and decoding-level failures surfaced by `HTTPClient`.
///
/// The repository maps these into domain `AppError`s; UI never sees them
/// directly.
public enum NetworkError: Error, Equatable {
    case invalidURL
    case transport          // connectivity / URLSession failure
    case invalidResponse    // non-HTTP response
    case unacceptableStatusCode(Int)
    case decoding

    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.transport, .transport),
             (.invalidResponse, .invalidResponse),
             (.decoding, .decoding):
            return true
        case let (.unacceptableStatusCode(l), .unacceptableStatusCode(r)):
            return l == r
        default:
            return false
        }
    }
}
