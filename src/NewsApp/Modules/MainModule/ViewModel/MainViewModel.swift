//
//  MainViewModel.swift
//  NewsApp
//
//  Created by Andrey Timofeev on 05.02.2023.
//

import Combine
import Foundation

final class MainViewModel {
    // MARK: - Private Props

    private let router: MainRouter
    private let api = ApiService.shared
    private let storage: StorageServiceProtocol = StorageService()

    private var pagination = Pagination()

    private var newsSubject = CurrentValueSubject<[News], Error>([])
    private var combineStore = CombineStore()

    // MARK: - LifeCycle

    init(router: MainRouter) {
        self.router = router
    }
}

extension MainViewModel: ViewModel {
    struct Input {
        let viewDidLoad: AnyPublisher<Bool, Never>
        let refresh: AnyPublisher<Bool, Never>
        let loadMoreData: AnyPublisher<Bool, Never>
        let didSelectRow: AnyPublisher<News, Never>
    }

    struct Output {
        let news: AnyPublisher<[News], Error>
    }

    func transform(input: Input, output: (Output) -> Void) {
        combineStore.clear()

        Publishers.Merge3(
            input.viewDidLoad,
            input.refresh,
            input.loadMoreData
        )
        .sink(
            receiveValue: { [weak self] isResetData in
                self?.fetchNews(isResetData: isResetData)
            }
        )
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

                let response = try await api.fetchNews(owner: .wsj, page: pagination.nextPage, pageSize: pagination.itemsPerPage)
                pagination.totalItems = response.totalResults ?? 20
                let items = response.articles?.map { $0.toNews() } ?? []

                newsSubject.send(items)
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
