//
//  UniversitiesRepositoryImpl.swift
//  UniversitiesBrowser
//
//  Created by Salma Ashour on 12/06/2026.
//

import DomainKit
import NetworkKit
import PersistenceKit

final class UniversitiesRepositoryImpl: UniversitiesRepository {
    
    private let apiClient: APIClient
    private let cache: UniversitiesCache

    init(
        apiClient: APIClient,
        cache: UniversitiesCache
    ) {
        self.apiClient = apiClient
        self.cache = cache
    }

    func universities(country: String) async throws -> [University] {
        do {
            let request = try UniversitiesEndpoint.search(country: country)
            let dto: [UniversityDTO] = try await apiClient.perform(request)
            let universities = dto.map { $0.toDomain() }

            try await cache.save(universities)

            return universities
        } catch {
            let cachedUniversities = try await cache.loadUniversities()

            guard !cachedUniversities.isEmpty else {
                throw error
            }

            return cachedUniversities
        }
    }
    
    func refresh(country: String) async throws -> [DomainKit.University] {
        return []
    }
    
}
