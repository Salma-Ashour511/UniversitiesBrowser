import XCTest
@testable import DomainKit

final class DefaultUniversitiesRepositoryTests: XCTestCase {

    private let country = "United Arab Emirates"

    func test_load_onNetworkSuccess_returnsRemoteAndRefreshesCache() async throws {
        let remote = StubRemote(result: .success([.fixture(name: "UAEU")]))
        let local = SpyLocalStore()
        let sut = DefaultUniversitiesRepository(remote: remote, local: local)

        let result = try await sut.loadUniversities(country: country)

        XCTAssertEqual(result.source, .remote)
        XCTAssertEqual(result.universities.map(\.name), ["UAEU"])
        XCTAssertEqual(local.saved?.map(\.name), ["UAEU"], "cache should be refreshed on success")
    }

    func test_load_onNetworkFailureWithCache_returnsCache() async throws {
        let remote = StubRemote(result: .failure(AppError.network))
        let local = SpyLocalStore()
        local.stored = [.fixture(name: "Cached University")]
        let sut = DefaultUniversitiesRepository(remote: remote, local: local)

        let result = try await sut.loadUniversities(country: country)

        XCTAssertEqual(result.source, .cache)
        XCTAssertEqual(result.universities.map(\.name), ["Cached University"])
    }

    func test_load_onNetworkFailureWithEmptyCache_throws() async {
        let remote = StubRemote(result: .failure(AppError.network))
        let local = SpyLocalStore()
        let sut = DefaultUniversitiesRepository(remote: remote, local: local)

        do {
            _ = try await sut.loadUniversities(country: country)
            XCTFail("expected an error")
        } catch {
            XCTAssertEqual(error as? AppError, .network)
        }
    }

    func test_refresh_onSuccess_returnsRemoteAndUpdatesCache() async throws {
        let remote = StubRemote(result: .success([.fixture(name: "Fresh")]))
        let local = SpyLocalStore()
        let sut = DefaultUniversitiesRepository(remote: remote, local: local)

        let universities = try await sut.refreshUniversities(country: country)

        XCTAssertEqual(universities.map(\.name), ["Fresh"])
        XCTAssertEqual(local.saved?.map(\.name), ["Fresh"])
    }

    func test_refresh_onFailure_throwsAndDoesNotTouchCache() async {
        let remote = StubRemote(result: .failure(AppError.network))
        let local = SpyLocalStore()
        let sut = DefaultUniversitiesRepository(remote: remote, local: local)

        do {
            _ = try await sut.refreshUniversities(country: country)
            XCTFail("expected an error")
        } catch {
            XCTAssertEqual(error as? AppError, .network)
            XCTAssertNil(local.saved)
        }
    }
}

// MARK: - Test Doubles

private extension University {
    static func fixture(name: String) -> University {
        University(name: name, country: "United Arab Emirates")
    }
}

private final class StubRemote: RemoteUniversitiesDataSource, @unchecked Sendable {
    let result: Result<[University], Error>
    init(result: Result<[University], Error>) { self.result = result }
    func fetch(country: String) async throws -> [University] {
        try result.get()
    }
}

private final class SpyLocalStore: LocalUniversitiesStore, @unchecked Sendable {
    var stored: [University] = []
    var saved: [University]?
    func save(_ universities: [University], country: String) async throws {
        saved = universities
        stored = universities
    }
    func load(country: String) async throws -> [University] {
        stored
    }
}
