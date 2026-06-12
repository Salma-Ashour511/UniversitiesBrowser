//
//  ListingPresenter.swift
//  ListingFeature
//
//  Created by Salma Ashour on 11/06/2026.
//

import Foundation
import DomainKit

@MainActor
public final class ListingPresenter: ObservableObject {
    @Published public private(set) var state: ListingViewState = .idle

    private let interactor: ListingInteractorInput
    private let router: ListingRouterInput
    private let refreshService: UniversitiesRefreshService

    public init(
        interactor: ListingInteractorInput,
        router: ListingRouterInput,
        refreshService: UniversitiesRefreshService
    ) {

        self.interactor = interactor
        self.router = router
        self.refreshService = refreshService

        refreshService.onRefreshRequested = { [weak self] in
            Task { @MainActor in
                self?.retry()
            }
        }

    }

    public func onAppear() {
        guard state == .idle else { return }
        load()
    }

    public func retry() {
        print("ListingPresenter retry triggered")
        load()
    }

    public func didSelect(_ university: University) {
        router.showDetails(for: university)
    }

    private func load() {
        state = .loading

        Task {
            do {
                let universities = try await interactor.loadUniversities()
                state = universities.isEmpty ? .empty : .loaded(universities)
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
}
