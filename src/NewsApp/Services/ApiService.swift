//
//  ApiService.swift
//  NewsApp
//
//  Created by Kate on 04.02.2023.
//

import Foundation

enum ApiError: Error {
    case badUrl
}

enum NewsOwner {
    case wsj

    var url: String {
        switch self {
        case .wsj:
            return "wsj.com"
        }
    }
}

protocol ApiServiceProtocol {
    func fetchNews(owner: NewsOwner, page: Int, pageSize: Int) async throws -> NewsResponse
}

struct ApiService {
    // MARK: Shared

    static let shared = ApiService()

    // MARK: - Private Props

    let baseUrl = "https://newsapi.org"
    let apiKey = "4edb6d26115144a3b09dd7e9500bb19d"
}

// MARK: - ApiServiceProtocol

extension ApiService: ApiServiceProtocol {
    func fetchNews(owner: NewsOwner = .wsj, page: Int = 1, pageSize: Int = 20) async throws -> NewsResponse {
        var urlComponens = URLComponents(string: "\(baseUrl)/v2/everything")
        urlComponens?.queryItems = [
            .init(name: "domains", value: owner.url),
            .init(name: "page", value: String(page)),
            .init(name: "pageSize", value: String(pageSize)),
            .init(name: "apiKey", value: apiKey)
        ]

        guard let url = urlComponens?.url else { throw ApiError.badUrl }
        debugPrint(url.absoluteURL)

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, _) = try await URLSession.shared.data(for: request)

        return try JSONDecoder().decode(NewsResponse.self, from: data)
    }
}
