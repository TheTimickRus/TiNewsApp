//
//  DetailViewController.swift
//  NewsApp
//
//  Created by Andrey Timofeev on 05.02.2023.
//

import UIKit

final class DetailViewController: UIViewController {
    // MARK: - Private Props

    private let viewModel: DetailViewModel
    private let detailView = DetailView()
    private var store = CombineStore()

    // MARK: - LifeCycle

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

private extension DetailViewController {
    func bind() {
        viewModel.transform(
            input: .init(
                showNews: detailView.showNewsButtonTapPublisher
            ),
            output: { [weak self] output in
                guard let self else { return }

                output.news
                    .sink { [weak self] in
                        self?.detailView.render(.init(news: $0))
                    }
                    .store(in: &self.store.cancellable)
            }
        )
    }
}
