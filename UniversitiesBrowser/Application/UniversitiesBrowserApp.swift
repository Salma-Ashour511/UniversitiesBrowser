//
//  UniversitiesBrowserApp.swift
//  UniversitiesBrowser
//
//  Created by Salma Ashour on 11/06/2026.
//

import SwiftUI

@main
struct UniversitiesBrowserApp: App {
    private let appContainer = AppContainer()

    var body: some Scene {
        WindowGroup {
            RootViewControllerRepresentable(
                viewController: appContainer.makeRootViewController()
            )
            .ignoresSafeArea()
        }
    }
}

private struct RootViewControllerRepresentable: UIViewControllerRepresentable {
    let viewController: UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        viewController
    }

    func updateUIViewController(
        _ uiViewController: UIViewController,
        context: Context
    ) {}
}
