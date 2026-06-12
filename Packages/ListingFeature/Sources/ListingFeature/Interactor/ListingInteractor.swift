//
//  ListingInteractor.swift
//  ListingFeature
//
//  Created by Salma Ashour on 11/06/2026.
//
import DomainKit

public protocol ListingInteractorInput: Sendable {
    func loadUniversities() async throws -> [University]
}

public final class ListingInteractor: ListingInteractorInput {
    private let repository: UniversitiesRepository
    private let country: String

    public init(
        repository: UniversitiesRepository,
        country: String = "United Arab Emirates"
    ) {
        self.repository = repository
        self.country = country
    }

    public func loadUniversities() async throws -> [University] {
        try await repository.universities(country: country)
    }
}
