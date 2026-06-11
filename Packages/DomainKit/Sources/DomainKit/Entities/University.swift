//
//  University.swift
//  University
//
//  Created by Salma Ashour, Vodafone on 11/06/2026.
//

import Foundation

/// The core domain entity shared across all modules.
///
/// This is the single source of truth for what a "university" is in the app.
/// Feature modules pass instances of this type to each other (Listing → Details)
/// and the data layer maps both network DTOs and persisted records to/from it.
///
public struct University: Identifiable, Equatable, Sendable {
    public let id: String
    public let name: String
    public let country: String
    public let stateProvince: String?
    public let webPages: [String]
    
    public init(
        id: String,
        name: String,
        country: String,
        stateProvince: String?,
        webPages: [String]
    ) {
        self.id = id
        self.name = name
        self.country = country
        self.stateProvince = stateProvince
        self.webPages = webPages
    }
}
