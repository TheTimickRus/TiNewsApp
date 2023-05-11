//
//  ApiService.swift
//  NewsApp
//
//  Created by Andrey Timofeev on 04.02.2023.
//

import Alamofire
import Foundation

enum NewsOwner {
    case wsj

    var url: String {
        switch self {
        case .wsj:
            return "wsj.com"
        }
    }
}

// MARK: - ApiService

struct ApiService { }

// MARK: - ApiServiceProtocol

extension ApiService {
    func fetchNews(owner: NewsOwner = .wsj, page: Int = 1, pageSize: Int = 20) async throws -> NewsResponse {
        try await AF.request(
            "\(Preferences.baseUrl)/v2/everything",
            parameters: [
                "domains": owner.url,
                "page": page,
                "pageSize": pageSize,
                "apiKey": Preferences.apiKey
            ]
        )
        .serializingDecodable(NewsResponse.self)
        .value
    }
}
