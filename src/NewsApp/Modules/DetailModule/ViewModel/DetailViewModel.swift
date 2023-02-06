//
//  DetailViewModel.swift
//  NewsApp
//
//  Created by Kate on 05.02.2023.
//

final class DetailViewModel {
    // MARK: Internal Props

    let currentNews: News

    // MARK: Private Props

    private let router: DetailRouter

    // MARK: - LifeCycle

    init(router: DetailRouter, currentNews: News) {
        self.router = router
        self.currentNews = currentNews
    }
}

// MARK: - Internal Props

extension DetailViewModel {
    func showNews(url: String) {
        router.showNews(url: url)
    }
}
