//
//  UniversitiesRepositoryImplTests.swift
//  UniversitiesBrowser
//
//  Created by Salma Ashour on 12/06/2026.
//


import XCTest
import DomainKit
import NetworkKit
import PersistenceKit
@testable import UniversitiesBrowser

final class UniversitiesRepositoryImplTests: XCTestCase {

    func testUniversities_whenAPISucceeds_savesCacheAndReturnsNetworkData() async throws {
        let university = University(
            name: "Test University",
            country: "United Arab Emirates",
            stateProvince: nil,
            webPages: ["https://example.com"]
        )

        let apiClient = MockAPIClient(
            result: .success([
                UniversityDTO(
                    name: university.name,
                    country: university.country,
                    stateProvince: university.stateProvince,
                    webPages: university.webPages
                )
            ])
        )

        let cache = MockUniversitiesCache()

        let repository = UniversitiesRepositoryImpl(
            apiClient: apiClient,
            cache: cache
        )

        let result = try await repository.universities(
            country: "United Arab Emirates"
        )

        XCTAssertEqual(result, [university])
        XCTAssertEqual(cache.savedUniversities, [university])
    }

    func testUniversities_whenAPIFails_returnsCachedData() async throws {
        let cachedUniversity = University(
            name: "Cached University",
            country: "United Arab Emirates",
            stateProvince: nil,
            webPages: ["https://cached.com"]
        )

        let apiClient = MockAPIClient(
            result: .failure(MockError.network)
        )

        let cache = MockUniversitiesCache(
            cachedUniversities: [cachedUniversity]
        )

        let repository = UniversitiesRepositoryImpl(
            apiClient: apiClient,
            cache: cache
        )

        let result = try await repository.universities(
            country: "United Arab Emirates"
        )

        XCTAssertEqual(result, [cachedUniversity])
    }

    func testUniversities_whenAPIFailsAndCacheIsEmpty_throwsError() async {
        let apiClient = MockAPIClient(
            result: .failure(MockError.network)
        )

        let cache = MockUniversitiesCache(
            cachedUniversities: []
        )

        let repository = UniversitiesRepositoryImpl(
            apiClient: apiClient,
            cache: cache
        )

        do {
            _ = try await repository.universities(
                country: "United Arab Emirates"
            )
            XCTFail("Expected repository to throw")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}

// MARK: - Mocks

private enum MockError: Error {
    case network
}

private final class MockAPIClient: APIClient, @unchecked Sendable {
    private let result: Result<Any, Error>

    init(result: Result<Any, Error>) {
        self.result = result
    }

    func perform<T: Decodable>(_ request: URLRequest) async throws -> T {
        switch result {
        case .success(let value):
            guard let typedValue = value as? T else {
                throw MockError.network
            }
            return typedValue

        case .failure(let error):
            throw error
        }
    }
}

private final class MockUniversitiesCache: UniversitiesCache, @unchecked Sendable {
    private let cachedUniversities: [University]
    private(set) var savedUniversities: [University] = []

    init(cachedUniversities: [University] = []) {
        self.cachedUniversities = cachedUniversities
    }

    func save(_ universities: [University]) async throws {
        savedUniversities = universities
    }

    func loadUniversities() async throws -> [University] {
        cachedUniversities
    }
}
