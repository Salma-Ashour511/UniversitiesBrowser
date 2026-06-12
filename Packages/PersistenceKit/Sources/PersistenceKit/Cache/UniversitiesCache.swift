//
//  UniversitiesCache.swift
//  PersistenceKit
//
//  Created by Salma Ashour on 12/06/2026.
//

import DomainKit

public protocol UniversitiesCache: Sendable {
    func save(_ universities: [University]) async throws
    func loadUniversities() async throws -> [University]
}
