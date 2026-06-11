//
//  EmptyStateView.swift
//  CommonUI
//
//  Created by Salma Ashour on 11/06/2026.
//

import SwiftUI

public struct EmptyStateView: View {
    private let title: String
    private let message: String

    public init(
        title: String = "No Results",
        message: String = "There is no data to display."
    ) {
        self.title = title
        self.message = message
    }

    public var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)

            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
