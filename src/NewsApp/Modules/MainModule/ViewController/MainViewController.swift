//
//  MainViewController.swift
//  NewsApp
//
//  Created by Andrey Timofeev on 04.02.2023.
//

import Combine
import CombineCocoa
import UIKit

final class MainViewController: UIViewController {
    // MARK: - Private Props

    private let viewModel: MainViewModel
    private let mainView = MainView()

    private var viewDidLoadSubject = PassthroughSubject<Void, Never>()
    private var combineStore = CombineStore()

    // MARK: - LifeCycle

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()

        viewDidLoadSubject.send()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "NewsApp"
    }

    // MARK: - Private Methods

    func configure() {
        viewModel.transform(
            input: .init(
                viewDidLoad: viewDidLoadSubject.eraseToAnyPublisher(),
                refresh: mainView.refreshPublisher,
                loadMoreData: mainView.loadMoreDataPublisher,
                didSelectRow: mainView.didSelectRowPublisher
            )
        ) { [weak self] output in
            guard let self else { return }
            self.combineStore.clear()

            output.news
                .receive(on: RunLoop.main)
                .sink { completion in
                    debugPrint(completion)
                } receiveValue: { [weak self] in
                    self?.mainView.render(.init(items: $0))
                }
                .store(in: &self.combineStore.cancellable)
        }
    }
}
