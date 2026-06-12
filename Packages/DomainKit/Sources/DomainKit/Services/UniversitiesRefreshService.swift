//
//  UniversitiesRefreshService.swift
//  DomainKit
//
//  Created by Salma Ashour on 11/06/2026.
//

import Foundation

public protocol UniversitiesRefreshService: AnyObject {

    func refresh()

    var onRefreshRequested: (() -> Void)? { get set }

}
