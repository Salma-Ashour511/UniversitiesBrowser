//
//  UniversityRecord.swift
//  PersistenceKit
//
//  Created by Salma Ashour on 12/06/2026.
//

import Foundation
import GRDB
import DomainKit

struct UniversityRecord: Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName = "universities"

    var id: String
    var name: String
    var country: String
    var stateProvince: String?
    var webPages: String

    func toDomain() -> University {
        University(
            name: name,
            country: country,
            stateProvince: stateProvince,
            webPages: webPages
                .split(separator: "|")
                .map(String.init)
        )
    }

    static func fromDomain(_ university: University) -> UniversityRecord {
        UniversityRecord(
            id: university.id,
            name: university.name,
            country: university.country,
            stateProvince: university.stateProvince,
            webPages: university.webPages.joined(separator: "|")
        )
    }
}
