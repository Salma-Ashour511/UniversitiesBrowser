//
//  AppContainer.swift
//  UniversitiesBrowser
//
//  Created by Salma Ashour on 12/06/2026.
//

import UIKit
import DomainKit
import NetworkKit
import PersistenceKit
import ListingFeature
import DetailsFeature

final class AppContainer {
    private let navigationController = UINavigationController()
    let refreshService = UniversitiesRefreshServiceImpl()

    func makeRootViewController() -> UIViewController {
        let apiClient = URLSessionAPIClient()
        let databaseManager = try! DatabaseManager()
        let cache = GRDBUniversitiesCache(databaseManager: databaseManager)

        let repository = UniversitiesRepositoryImpl(
            apiClient: apiClient,
            cache: cache
        )

        let listingViewController = ListingBuilder.build(
            navigationController: navigationController,
            repository: repository,
            refreshService: refreshService,
            detailsBuilder: { university in
                DetailsBuilder.build(
                    university: university,
                    refreshService: self.refreshService
                )
            }
        )
        
        navigationController.setViewControllers(
            [listingViewController],
            animated: false
        )

        return navigationController
    }
}
