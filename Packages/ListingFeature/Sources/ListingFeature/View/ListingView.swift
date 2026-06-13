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
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Universities")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.horizontal, 20)
                            .padding(.top, 12)

                        LazyVStack(spacing: 0) {
                            ForEach(universities) { university in
                                Button {
                                    presenter.didSelect(university)
                                } label: {
                                    UniversityCardRow(university: university)
                                }
                                .buttonStyle(.plain)

                                if university.id != universities.last?.id {
                                    Divider()
                                        .padding(.leading, 116)
                                }
                            }
                        }
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 24)
                }
            }
        }
    }
}

private struct UniversityCardRow: View {
    let university: University

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(.blue.opacity(0.15))
                    .frame(width: 42, height: 42)

                Image(systemName: "graduationcap.fill")
                    .foregroundStyle(.blue)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(university.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)

                Text(university.country)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            }

            Spacer(minLength: 8)

            Image(systemName: "chevron.right")
                .font(.headline)
                .foregroundStyle(.tertiary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .contentShape(Rectangle())
    }
}
