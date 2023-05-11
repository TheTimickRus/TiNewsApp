//
//  MainViewModel.swift
//  NewsApp
//
//  Created by Andrey Timofeev on 05.02.2023.
//

import Combine
import CombineExt
import Foundation

final class MainViewModel {
    // MARK: - Private Props

    private let router: MainRouter
    private let apiService: ApiService

    private var pagination = Pagination()

    private var newsSubject = CurrentValueSubject<[News], Error>([])
    private var combineStore = CombineStore()

    // MARK: - LifeCycle

    init(router: MainRouter, apiService: ApiService) {
        self.router = router
        self.apiService = apiService
    }
}

extension MainViewModel: ViewModel {
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let refresh: AnyPublisher<Void, Never>
        let loadMoreData: AnyPublisher<Void, Never>
        let didSelectRow: AnyPublisher<News, Never>
    }

    struct Output {
        let news: AnyPublisher<[News], Error>
    }

    func transform(input: Input, output: (Output) -> Void) {
        combineStore.clear()

        input.viewDidLoad
            .sink { [weak self] in
                self?.fetchNews(isResetData: true)
            }
            .store(in: &combineStore.cancellable)

        input.refresh
            .dropFirst()
            .sink { [weak self] in
                self?.fetchNews(isResetData: true)
            }
            .store(in: &combineStore.cancellable)

        input.loadMoreData
            .sink { [weak self] in
                self?.fetchNews()
            }
            .store(in: &combineStore.cancellable)

        input.didSelectRow
            .sink(receiveValue: { [weak self] in self?.showDetailNews(news: $0) })
            .store(in: &combineStore.cancellable)

        output(
            .init(
                news: newsSubject.eraseToAnyPublisher()
            )
        )
    }
}

extension MainViewModel {
    func updateCounterForNews(id: UUID) {
        guard let index = self.newsSubject.value.firstIndex(where: { $0.id == id }) else { return }
        var items = newsSubject.value
        items[index].counter += 1
        newsSubject.send(items)
    }

    func fetchNews(isResetData: Bool = false) {
        Task {
            do {
                if isResetData {
                    newsSubject.value = []
                    pagination.clear()
                }

                if pagination.hasMorePages == false {
                    return
                }

                let response = try await apiService.fetchNews(owner: .wsj, page: pagination.nextPage, pageSize: pagination.itemsPerPage)
                pagination.totalItems = response.totalResults ?? 20
                let items = response.articles?.map { $0.toNews() } ?? []

                var latest = newsSubject.value
                latest.append(contentsOf: items)
                newsSubject.send(latest)
            } catch {
                self.router.showError(error)
            }
        }
    }

    func showDetailNews(news: News) {
        updateCounterForNews(id: news.id)
        router.showDetailNews(news: news)
    }
}
