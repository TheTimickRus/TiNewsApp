//
//  News.swift
//  NewsApp
//
//  Created by Kate on 04.02.2023.
//

import Foundation

struct News: Equatable, Codable {
    let imageUrl: String
    let title: String
    let author: String
    let publishedAt: String
    let description: String
    let url: String

    let id: UUID
    var counter: Int
}