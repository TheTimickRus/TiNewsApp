//
//  DetailViewModel.swift
//  NewsApp
//
//  Created by Andrey Timofeev on 05.02.2023.
//

import Combine
import CombineExt

final class DetailViewModel {
    // MARK: - Private Props

    private let router: DetailRouter
    private let currentNews: News

    private lazy var currentNewsSubject = CurrentValueSubject<News, Never>(currentNews)

    private var store = CombineStore()

    // MARK: - LifeCycle

    init(router: DetailRouter, currentNews: News) {
        self.router = router
        self.currentNews = currentNews
    }
}

extension DetailViewModel: ViewModel {
    struct Input {
        let showNews: AnyPublisher<Void, Never>
    }

    struct Output {
        let news: AnyPublisher<News, Never>
    }

    func transform(input: Input, output: (Output) -> Void) {
        input.showNews
            .compactMap { [weak self] in
                self?.currentNews.url
            }
            .sink { [weak self] url in
                self?.router.showNews(url: url)
            }
            .store(in: &store.cancellable)

        output(
            Output(
                news: currentNewsSubject.eraseToAnyPublisher()
            )
        )
    }
}

// MARK: - Internal Props

extension DetailViewModel {
    func showNews(url: String) {
        router.showNews(url: url)
    }
}
