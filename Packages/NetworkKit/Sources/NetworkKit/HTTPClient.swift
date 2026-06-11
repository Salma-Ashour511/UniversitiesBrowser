import Foundation

/// Abstraction over an HTTP transport that fetches and decodes a `Decodable`.
///
/// Depending on the protocol (rather than a concrete `URLSession` wrapper) lets
/// the data layer be unit-tested with a stub client.
public protocol HTTPClient: Sendable {
    func send<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T
}

/// Seam over `URLSession` so tests can inject a fake transport.
public protocol HTTPSession: Sendable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: HTTPSession {}
