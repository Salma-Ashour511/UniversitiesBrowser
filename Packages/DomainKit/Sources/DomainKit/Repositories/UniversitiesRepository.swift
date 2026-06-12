//
//  UniversitiesRepository.swift
//  UniversitiesRepository
//
//  Created by Salma Ashour on 11/06/2026.
//
import Foundation

public protocol UniversitiesRepository: Sendable {
    
    func universities(
        country: String
    ) async throws -> [University]

}
