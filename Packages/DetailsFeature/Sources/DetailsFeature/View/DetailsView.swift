//
//  DetailsView.swift
//  DetailsFeature
//
//  Created by Salma Ashour on 12/06/2026.
//


import SwiftUI
import DomainKit

public struct DetailsView: View {
    @ObservedObject private var presenter: DetailsPresenter

    public init(presenter: DetailsPresenter) {
        self.presenter = presenter
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if presenter.isRefreshing {
                    HStack(spacing: 8) {
                        ProgressView()
                        Text("Refreshing...")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                if let refreshMessage = presenter.refreshMessage {
                    Text(refreshMessage)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Text(presenter.university.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .fixedSize(horizontal: false, vertical: true)

                infoRow(title: "Country", value: presenter.university.country)

                if let state = presenter.university.stateProvince,
                   !state.isEmpty {
                    infoRow(title: "State / Province", value: state)
                }

                if !presenter.university.webPages.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Websites")
                            .font(.headline)

                        ForEach(presenter.university.webPages, id: \.self) { website in
                            Text(website)
                                .font(.body)
                                .foregroundStyle(.blue)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .toolbar {
            Button("Refresh") {
                presenter.refresh()
            }
        }
    }

    private func infoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)

            Text(value)
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
