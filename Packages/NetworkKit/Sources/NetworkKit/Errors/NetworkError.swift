//
//  NetworkError.swift
//  NetworkKit
//
//  Created by Salma Ashour on 11/06/2026.
//

public enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case unacceptableStatusCode(Int)
    case decodingFailed
}
