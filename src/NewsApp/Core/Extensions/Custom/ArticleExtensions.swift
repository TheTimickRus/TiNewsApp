//
//  ArticleExtensions.swift
//  NewsApp
//
//  Created by Andrey Timofeev on 04.02.2023.
//

import Foundation

extension Article {
    func toNews() -> News {
        .init(
            imageUrl: self.urlToImage ?? "",
            title: self.title ?? "n\n",
            author: self.author ?? "n\n",
            publishedAt: self.publishedAt ?? "n\n",
            description: self.description ?? "n\n",
            url: self.url ?? "",
            content: self.content ?? "",

            id: UUID(),
            counter: 0
        )
    }
}
