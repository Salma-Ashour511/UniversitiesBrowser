//
//  GetUniversitiesUseCase.swift
//  DomainKit
//
//  Created by Salma Ashour on 12/06/2026.
//


import Foundation

public protocol GetUniversitiesUseCase {

    func execute(
        country: String
    ) async throws -> [University]

}
