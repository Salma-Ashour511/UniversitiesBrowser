//
//  UniversityDTO.swift
//  NetworkKit
//
//  Created by Salma Ashour on 11/06/2026.
//

import DomainKit

public struct UniversityDTO: Decodable, Sendable {
    public let name: String
    public let country: String
    public let stateProvince: String?
    public let webPages: [String]

    private enum CodingKeys: String, CodingKey {
        case name
        case country
        case stateProvince = "state-province"
        case webPages = "web_pages"
    }

    public func toDomain() -> University {
        University(
            id: name + "-" + country,
            name: name,
            country: country,
            stateProvince: stateProvince,
            webPages: webPages
        )
    }
}
