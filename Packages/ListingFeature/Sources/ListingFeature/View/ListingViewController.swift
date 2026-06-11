//
//  ListingViewController.swift
//  ListingFeature
//
//  Created by Salma Ashour on 11/06/2026.
//

import UIKit
import SwiftUI

public final class ListingViewController: UIViewController {
    private let presenter: ListingPresenter

    public init(presenter: ListingPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        title = "Universities"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        let hostingController = UIHostingController(
            rootView: ListingView(presenter: presenter)
        )

        addChild(hostingController)
        view.addSubview(hostingController.view)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        hostingController.didMove(toParent: self)
    }
}
