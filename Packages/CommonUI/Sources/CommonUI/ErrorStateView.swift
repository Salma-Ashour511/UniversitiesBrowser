//
//  ErrorStateView.swift
//  CommonUI
//
//  Created by Salma Ashour on 11/06/2026.
//

import SwiftUI

public struct ErrorStateView: View {
    private let title: String
    private let message: String
    private let retryTitle: String
    private let retryAction: () -> Void

    public init(
        title: String = "Something went wrong",
        message: String,
        retryTitle: String = "Try Again",
        retryAction: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.retryTitle = retryTitle
        self.retryAction = retryAction
    }

    public var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)

            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button(retryTitle, action: retryAction)
                .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
