//
//  Pagination.swift
//  NewsApp
//
//  Created by Kate on 04.02.2023.
//

class Pagination {
    var page: Int
    var itemsPerPage: Int
    var totalItems: Int

    init(page: Int = 0, itemsPerPage: Int = 20, totalItems: Int = 20) {
        self.page = page
        self.itemsPerPage = itemsPerPage
        self.totalItems = totalItems
    }

    var hasMorePages: Bool {
        return (page * itemsPerPage) < totalItems
    }

    var nextPage: Int {
        page += 1
        return page
    }

    func clear() {
        page = 0
        itemsPerPage = 20
        totalItems = 20
    }
}
