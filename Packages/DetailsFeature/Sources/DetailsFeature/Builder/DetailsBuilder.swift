//
//  DetailsBuilder.swift
//  DetailsFeature
//
//  Created by Salma Ashour, Vodafone on 12/06/2026.
//


import UIKit
import DomainKit

public enum DetailsBuilder {
    @MainActor public static func build(
        university: University
    ) -> UIViewController {
        let interactor = DetailsInteractor()
        let router = DetailsRouter()
        let presenter = DetailsPresenter(
            university: university,
            interactor: interactor,
            router: router
        )

        return DetailsViewController(presenter: presenter)
    }
}
