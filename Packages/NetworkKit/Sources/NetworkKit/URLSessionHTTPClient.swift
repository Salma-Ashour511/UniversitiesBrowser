import Foundation

/// `URLSession`-backed `HTTPClient`.
///
/// Responsibilities: build the request, perform it, validate the status code,
/// and decode the payload — translating every failure into a `NetworkError`.
public final class URLSessionHTTPClient: HTTPClient {

    private let baseURL: URL
    private let session: HTTPSession
    private let decoder: JSONDecoder

    public init(
        baseURL: URL,
        session: HTTPSession = URLSession.shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
    }

    public func send<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T {
        let request = try endpoint.urlRequest(baseURL: baseURL)

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw NetworkError.transport
        }

        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        guard (200..<300).contains(http.statusCode) else {
            throw NetworkError.unacceptableStatusCode(http.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decoding
        }
    }
}
