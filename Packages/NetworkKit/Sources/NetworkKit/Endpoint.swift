import Foundation

/// A declarative description of an HTTP request.
///
/// Endpoints are value types that know how to build a `URLRequest` against a
/// base URL. Callers describe *what* they want; `HTTPClient` decides *how* to
/// send it. This keeps request construction testable and free of side effects.
public struct Endpoint: Sendable {
    public let path: String
    public let method: HTTPMethod
    public let queryItems: [URLQueryItem]
    public let headers: [String: String]
    public let body: Data?

    public init(
        path: String,
        method: HTTPMethod = .get,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        body: Data? = nil
    ) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.headers = headers
        self.body = body
    }

    /// Builds a `URLRequest` by resolving this endpoint against `baseURL`.
    /// - Throws: `NetworkError.invalidURL` if the components cannot form a URL.
    func urlRequest(baseURL: URL) throws -> URLRequest {
        let resolved = baseURL.appendingPathComponent(path)
        guard var components = URLComponents(url: resolved, resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidURL
        }
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        return request
    }
}
