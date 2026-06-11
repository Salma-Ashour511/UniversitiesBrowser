//
//  APIClient.swift
//  NetworkKit
//
//  Created by Salma Ashour on 11/06/2026.
//

import Foundation

public protocol APIClient: Sendable {
    func perform<T: Decodable>(_ request: URLRequest) async throws -> T
}
