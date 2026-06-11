//
//  UniversitiesRepository.swift
//  UniversitiesRepository
//
//  Created by Salma Ashour, Vodafone on 11/06/2026.
//
import Foundation

/// Use-case boundary consumed by the feature Interactors.
///
/// Implementations orchestrate the remote source and the local cache. Feature
/// modules depend only on this protocol and `University`, never on the concrete
/// network/persistence packages.
public protocol UniversitiesRepository: Sendable {
    func fetchUniversities() async throws -> [University]
}
