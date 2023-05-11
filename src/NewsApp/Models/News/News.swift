//
//  News.swift
//  NewsApp
//
//  Created by Andrey Timofeev on 04.02.2023.
//

import Foundation

struct News: Equatable, Codable {
    let imageUrl: String
    let title: String
    let author: String
    let publishedAt: String
    let description: String
    let url: String
    let content: String

    let id: UUID
    var counter: Int
}
