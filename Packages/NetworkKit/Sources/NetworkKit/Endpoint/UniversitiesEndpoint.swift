//
//  UniversitiesEndpoint.swift
//  NetworkKit
//
//  Created by Salma Ashour on 11/06/2026.
//

import Foundation

public enum UniversitiesEndpoint {
    private static let baseURL = "http://universities.hipolabs.com"

    public static func search(country: String) throws -> URLRequest {
        var components = URLComponents(string: baseURL + "/search")
        components?.queryItems = [
            URLQueryItem(name: "country", value: country)
        ]

        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }

        return URLRequest(url: url)
    }
}
