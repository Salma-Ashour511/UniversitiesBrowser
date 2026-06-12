//
//  DetailsPresenter.swift
//  DetailsFeature
//
//  Created by Salma Ashour, Vodafone on 12/06/2026.
//


import Foundation
import DomainKit

@MainActor
public final class DetailsPresenter: ObservableObject {
    @Published public private(set) var university: University

    private let interactor: DetailsInteractorInput
    private let router: DetailsRouterInput

    public init(
        university: University,
        interactor: DetailsInteractorInput,
        router: DetailsRouterInput
    ) {
        self.university = university
        self.interactor = interactor
        self.router = router
    }
}