//
//  LoadingView.swift
//  CommonUI
//
//  Created by Salma Ashour on 11/06/2026.
//

import SwiftUI

public struct LoadingView: View {
    private let title: String

    public init(title: String = "Loading...") {
        self.title = title
    }

    public var body: some View {
        VStack(spacing: 12) {
            ProgressView()
            Text(title)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
