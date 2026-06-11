//
//  ListingView.swift
//  ListingFeature
//
//  Created by Salma Ashour on 11/06/2026.
//

import SwiftUI
import CommonUI
import DomainKit

public struct ListingView: View {
    @ObservedObject private var presenter: ListingPresenter

    public init(presenter: ListingPresenter) {
        self.presenter = presenter
    }

    public var body: some View {
        content
            .onAppear {
                presenter.onAppear()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch presenter.state {
        case .idle, .loading:
            LoadingView(title: "Loading universities...")

        case .empty:
            EmptyStateView(
                title: "No Universities",
                message: "No universities were found for this country."
            )

        case .error(let message):
            ErrorStateView(
                message: message,
                retryAction: {
                    presenter.retry()
                }
            )

        case .loaded(let universities):
            List(universities) { university in
                Button {
                    presenter.didSelect(university)
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(university.name)
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(university.country)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 6)
                }
            }
            .listStyle(.plain)
        }
    }
}
