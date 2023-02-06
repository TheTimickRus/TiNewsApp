//
//  StorageService.swift
//  NewsApp
//
//  Created by Kate on 05.02.2023.
//

import Foundation

protocol StorageServiceProtocol {
    func saveNews(news: [News])
    func loadData() -> [News]
}

struct StorageService: StorageServiceProtocol {
    // MARK: Nested

    enum Keys: String {
        case news
    }

    // MARK: - StorageServiceProtocol

    func saveNews(news: [News]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(news) {
            UserDefaults.standard.set(data, forKey: Keys.news.rawValue)
        }
    }

    func loadData() -> [News] {
        if let data = UserDefaults.standard.data(forKey: Keys.news.rawValue),
           let news = try? JSONDecoder().decode([News].self, from: data) {
            return news
        }

        return []
    }
}
