//
//  UniversitiesRepositoryImpl.swift
//  UniversitiesBrowser
//
//  Created by Salma Ashour on 12/06/2026.
//


import DomainKit
import NetworkKit

final class UniversitiesRepositoryImpl: UniversitiesRepository {
    
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func universities(country: String) async throws -> [University] {
        let request = try UniversitiesEndpoint.search(country: country)
        let dto: [UniversityDTO] = try await apiClient.perform(request)
        return dto.map { $0.toDomain() }
    }
    
    func refresh(country: String) async throws -> [DomainKit.University] { return []}
}
