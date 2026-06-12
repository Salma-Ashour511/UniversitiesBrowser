//
//  UniversitiesRefreshServiceImpl.swift
//  UniversitiesBrowser
//
//  Created by Salma Ashour on 12/06/2026.
//


import DomainKit

final class UniversitiesRefreshServiceImpl: UniversitiesRefreshService {

    var onRefreshRequested: (() -> Void)?

    func refresh() {
        onRefreshRequested?()
    }

}
