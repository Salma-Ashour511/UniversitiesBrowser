import XCTest
@testable import NetworkKit

private struct Sample: Decodable, Equatable {
    let name: String
}

final class URLSessionHTTPClientTests: XCTestCase {

    private let baseURL = URL(string: "https://example.com")!

    func test_send_decodesSuccessfulResponse() async throws {
        let json = #"[{"name":"UAEU"}]"#.data(using: .utf8)!
        let sut = makeSUT(result: .success((json, http(200))))

        let result = try await sut.send(Endpoint(path: "search"), as: [Sample].self)

        XCTAssertEqual(result, [Sample(name: "UAEU")])
    }

    func test_send_onNon2xx_throwsUnacceptableStatusCode() async {
        let sut = makeSUT(result: .success((Data(), http(500))))
        await assertThrows(sut, expected: .unacceptableStatusCode(500))
    }

    func test_send_onTransportError_throwsTransport() async {
        let sut = makeSUT(result: .failure(URLError(.notConnectedToInternet)))
        await assertThrows(sut, expected: .transport)
    }

    func test_send_onMalformedJSON_throwsDecoding() async {
        let sut = makeSUT(result: .success(("not json".data(using: .utf8)!, http(200))))
        await assertThrows(sut, expected: .decoding)
    }

    func test_endpoint_buildsURLWithQueryItems() throws {
        let endpoint = Endpoint(path: "search", queryItems: [URLQueryItem(name: "country", value: "United Arab Emirates")])
        let request = try endpoint.urlRequest(baseURL: baseURL)
        XCTAssertEqual(request.url?.absoluteString, "https://example.com/search?country=United%20Arab%20Emirates")
    }

    // MARK: - Helpers

    private func makeSUT(result: Result<(Data, URLResponse), Error>) -> URLSessionHTTPClient {
        URLSessionHTTPClient(baseURL: baseURL, session: StubSession(result: result))
    }

    private func http(_ code: Int) -> HTTPURLResponse {
        HTTPURLResponse(url: baseURL, statusCode: code, httpVersion: nil, headerFields: nil)!
    }

    private func assertThrows(
        _ sut: URLSessionHTTPClient,
        expected: NetworkError,
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        do {
            _ = try await sut.send(Endpoint(path: "search"), as: [Sample].self)
            XCTFail("expected to throw \(expected)", file: file, line: line)
        } catch {
            XCTAssertEqual(error as? NetworkError, expected, file: file, line: line)
        }
    }
}

private struct StubSession: HTTPSession {
    let result: Result<(Data, URLResponse), Error>
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try result.get()
    }
}
