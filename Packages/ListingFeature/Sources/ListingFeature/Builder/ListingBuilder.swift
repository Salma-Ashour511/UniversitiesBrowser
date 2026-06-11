//
//  ListingBuilder.swift
//  ListingFeature
//
//  Created by Salma Ashour on 11/06/2026.
//
import UIKit
import DomainKit

public enum ListingBuilder {
    @MainActor public static func build(
        navigationController: UINavigationController,
        repository: UniversitiesRepository,
        detailsBuilder: @escaping (University) -> UIViewController
    ) -> UIViewController {
        let interactor = ListingInteractor(repository: repository)
        let router = ListingRouter(
            navigationController: navigationController,
            detailsBuilder: detailsBuilder
        )
        let presenter = ListingPresenter(
            interactor: interactor,
            router: router
        )

        return ListingViewController(presenter: presenter)
    }
}
