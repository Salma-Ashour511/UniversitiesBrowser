//
//  DetailsPresenter.swift
//  DetailsFeature
//
//  Created by Salma Ashour on 12/06/2026.
//


import Foundation
import DomainKit

@MainActor
public final class DetailsPresenter: ObservableObject {
    @Published public private(set) var university: University
    @Published public private(set) var isRefreshing = false
    @Published public private(set) var refreshMessage: String?

    private let interactor: DetailsInteractorInput
    private let router: DetailsRouterInput
    private let refreshService: UniversitiesRefreshService

    public init(
        university: University,
        interactor: DetailsInteractorInput,
        router: DetailsRouterInput,
        refreshService: UniversitiesRefreshService
    ) {
        self.university = university
        self.interactor = interactor
        self.router = router
        self.refreshService = refreshService
    }

    public func refresh() {
        isRefreshing = true
        refreshMessage = nil

        refreshService.refresh()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.isRefreshing = false
            self.refreshMessage = nil
        }
    }
}
