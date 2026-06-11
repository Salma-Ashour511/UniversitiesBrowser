//
//  ListingViewState.swift
//  ListingFeature
//
//  Created by Salma Ashour on 11/06/2026.
//

import Foundation
import DomainKit

public enum ListingViewState: Equatable {
    case idle
    case loading
    case loaded([University])
    case empty
    case error(String)
}
