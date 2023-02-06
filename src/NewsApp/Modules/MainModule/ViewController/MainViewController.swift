//
//  MainViewController.swift
//  NewsApp
//
//  Created by Kate on 04.02.2023.
//

import UIKit

final class MainViewController: UIViewController {
    // MARK: Private Props

    private let viewModel: MainViewModel
    private let mainView = MainView()

    // MARK: - LifeCycle

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Загружаем новости
        self.viewModel.fetchNews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configure()
    }

    // MARK: - Private Methods

    func configure() {
        title = "NewsApp"

        viewModel.isNewsFetched = {
            self.mainView.render(.init(items: $0))
        }

        mainView.isRefreshCallBack = {
            self.viewModel.fetchNews(isResetData: true)
        }

        mainView.isLoadMoreData = {
            self.viewModel.fetchNews()
        }

        mainView.isShowDetail = {
            self.viewModel.updateNews(id: $0.id)
            self.viewModel.showDetailNews(news: $0)
        }
    }
}
