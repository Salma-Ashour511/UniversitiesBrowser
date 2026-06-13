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
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
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
                    
                    HStack {
                        Text(presenter.university.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                        
                        Image(systemName: "graduationcap.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.blue)
                        
                    }
                    
                    Divider()
                    
                    infoRow(title: "Country", value: presenter.university.country)
                    
                    if let state = presenter.university.stateProvince,
                       !state.isEmpty {
                        infoRow(title: "State / Province", value: state)
                    }
                    
                    if let website = presenter.university.webPages.first,
                       let url = URL(string: website) {
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            
                            Text("WEBSITE")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                            
                            Link(destination: url) {
                                HStack {
                                    Text(website)
                                        .font(.body)
                                        .lineLimit(1)
                                        .truncationMode(.middle)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "arrow.up.right")
                                }
                                .foregroundStyle(.blue)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.15))
                )
                .shadow(
                    color: .black.opacity(0.05),
                    radius: 8
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
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
