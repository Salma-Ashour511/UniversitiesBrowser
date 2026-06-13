//
//  DetailsViewController.swift
//  DetailsFeature
//
//  Created by Salma Ashour on 12/06/2026.
//


import UIKit
import SwiftUI

public final class DetailsViewController: UIViewController {
    private let presenter: DetailsPresenter

    public init(presenter: DetailsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        title = "University Details"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.clockwise"),
            style: .plain,
            target: self,
            action: #selector(refreshTapped)
        )

        let hostingController = UIHostingController(
            rootView: DetailsView(presenter: presenter)
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
    
    @objc
    private func refreshTapped() {
        presenter.refresh()
    }
}
