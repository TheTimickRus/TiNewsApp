//
//  MainViewModel.swift
//  NewsApp
//
//  Created by Kate on 05.02.2023.
//

import Foundation

final class MainViewModel {
    // MARK: Internal Props

    var isNewsFetched: (([News]) -> Void)?

    // MARK: Private Props

    private let router: MainRouter
    private let api: ApiServiceProtocol = ApiService.shared
    private let storage: StorageServiceProtocol = StorageService()

    private var news: [News] = []
    private var pagination = Pagination()

    // MARK: - LifeCycle

    init(router: MainRouter) {
        self.router = router
    }
}

extension MainViewModel {
    func updateNews(id: UUID) {
        guard let index = self.news.firstIndex(where: { $0.id == id }) else { return }

        var item = news[index]
        item.counter += 1
        news[index] = item

        self.isNewsFetched?(self.news)
    }

    func fetchNews(isResetData: Bool = false) {
        Task {
            do {
                var isLoadedFromCache = false

                if news.isEmpty {
                    news = storage.loadData()
                    debugPrint("Loaded from Storage: \(news.count)")
                    isLoadedFromCache = true
                    DispatchQueue.main.async {
                        self.isNewsFetched?(self.news)
                    }
                }

                if isResetData {
                    news = []
                    pagination.clear()
                }

                if pagination.hasMorePages == false {
                    return
                }

                let response = try await api.fetchNews(owner: .wsj, page: pagination.nextPage, pageSize: pagination.itemsPerPage)
                pagination.totalItems = response.totalResults ?? 20
                let items = response.articles?.map { $0.toNews() } ?? []

                if isLoadedFromCache {
                    news = items
                } else {
                    news += items
                }

                storage.saveNews(news: news)

                DispatchQueue.main.async {
                    self.isNewsFetched?(self.news)
                }
            } catch(let error) {
                DispatchQueue.main.async {
                    self.router.showError(error)
                }
            }
        }
    }

    func showDetailNews(news: News) {
        router.showDetailNews(news: news)
    }
}
