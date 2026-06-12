//
//  DatabaseManager.swift
//  PersistenceKit
//
//  Created by Salma Ashour on 12/06/2026.
//

import Foundation
import GRDB

public final class DatabaseManager: @unchecked Sendable {
    private let dbQueue: DatabaseQueue

    public init(databaseURL: URL? = nil) throws {
        let url = try databaseURL ?? Self.defaultDatabaseURL()
        dbQueue = try DatabaseQueue(path: url.path)
        try migrator.migrate(dbQueue)
    }

    var databaseQueue: DatabaseQueue {
        dbQueue
    }

    private static func defaultDatabaseURL() throws -> URL {
        let folder = try FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )

        return folder.appendingPathComponent("universities.sqlite")
    }

    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()

        migrator.registerMigration("createUniversities") { db in
            try db.create(table: UniversityRecord.databaseTableName, ifNotExists: true) { table in
                table.column("id", .text).primaryKey()
                table.column("name", .text).notNull()
                table.column("country", .text).notNull()
                table.column("stateProvince", .text)
                table.column("webPages", .text).notNull()
            }
        }

        return migrator
    }
}
