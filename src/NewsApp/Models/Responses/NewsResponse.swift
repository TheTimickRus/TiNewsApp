//
//  NewsResponse.swift
//  NewsApp
//
//  Created by Andrey Timofeev on 03.02.2023.
//

import Foundation

// swiftlint:disable type_contents_order

public struct NewsResponse: Codable {
    public let status: String?
    public let totalResults: Int?
    public let articles: [Article]?

    enum CodingKeys: String, CodingKey {
        case status
        case totalResults
        case articles
    }

    public init(status: String?, totalResults: Int?, articles: [Article]?) {
        self.status = status
        self.totalResults = totalResults
        self.articles = articles
    }
}

// MARK: - Article

public struct Article: Codable {
    public let source: Source?
    public let author: String?
    public let title: String?
    public let description: String?
    public let url: String?
    public let urlToImage: String?
    public let publishedAt: String?
    public let content: String?

    enum CodingKeys: String, CodingKey {
        case source
        case author
        case title
        case description
        case url
        case urlToImage
        case publishedAt
        case content
    }

    public init(
        source: Source?,
        author: String?,
        title: String?,
        description: String?,
        url: String?,
        urlToImage: String?,
        publishedAt: String?,
        content: String?
    ) {
        self.source = source
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
}

// MARK: - Source

public struct Source: Codable {
    public let id: String?
    public let name: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
    }

    public init(id: String?, name: String?) {
        self.id = id
        self.name = name
    }
}
