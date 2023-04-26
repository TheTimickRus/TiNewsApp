//
//  Pagination.swift
//  NewsApp
//
//  Created by Andrey Timofeev on 04.02.2023.
//

final class Pagination {
    var page: Int
    var itemsPerPage: Int
    var totalItems: Int

    var hasMorePages: Bool {
        return (page * itemsPerPage) < totalItems
    }

    var nextPage: Int {
        page += 1
        return page
    }

    init(page: Int = 0, itemsPerPage: Int = 20, totalItems: Int = 20) {
        self.page = page
        self.itemsPerPage = itemsPerPage
        self.totalItems = totalItems
    }

    func clear() {
        page = 0
        itemsPerPage = 20
        totalItems = 20
    }
}
