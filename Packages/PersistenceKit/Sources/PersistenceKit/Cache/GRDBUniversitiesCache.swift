//
//  GRDBUniversitiesCache.swift
//  PersistenceKit
//
//  Created by Salma Ashour on 12/06/2026.
//

import DomainKit
import GRDB

public final class GRDBUniversitiesCache: UniversitiesCache {
    private let databaseManager: DatabaseManager

    public init(databaseManager: DatabaseManager) {
        self.databaseManager = databaseManager
    }

    public func save(_ universities: [University]) async throws {
        try await databaseManager.databaseQueue.write { db in
            try UniversityRecord.deleteAll(db)

            for university in universities {
                try UniversityRecord
                    .fromDomain(university)
                    .insert(db)
            }
        }
    }

    public func loadUniversities() async throws -> [University] {
        try await databaseManager.databaseQueue.read { db in
            try UniversityRecord
                .fetchAll(db)
                .map { $0.toDomain() }
        }
    }
}
