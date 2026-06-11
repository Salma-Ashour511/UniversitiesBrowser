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

    public init(
        interactor: ListingInteractorInput,
        router: ListingRouterInput
    ) {
        self.interactor = interactor
        self.router = router
    }

    public func onAppear() {
        guard state == .idle else { return }
        load()
    }

    public func retry() {
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
                state = .error("Unable to load universities. Please try again.")
            }
        }
    }
}
