//
//  ListingRouter.swift
//  ListingFeature
//
//  Created by Salma Ashour on 11/06/2026.
//

import UIKit
import DomainKit

public protocol ListingRouterInput: AnyObject {
    func showDetails(for university: University)
}

public final class ListingRouter: ListingRouterInput {
    private weak var navigationController: UINavigationController?
    private let detailsBuilder: (University) -> UIViewController

    public init(
        navigationController: UINavigationController,
        detailsBuilder: @escaping (University) -> UIViewController
    ) {
        self.navigationController = navigationController
        self.detailsBuilder = detailsBuilder
    }

    public func showDetails(for university: University) {
        let viewController = detailsBuilder(university)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
