//
//  DetailViewController.swift
//  NewsApp
//
//  Created by Kate on 05.02.2023.
//

import UIKit

final class DetailViewController: UIViewController {
    // MARK: Private Props

    private let viewModel: DetailViewModel
    
    private let detailView = DetailView()

    // MARK: - LifeCycle

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
}

private extension DetailViewController {
    func configure() {
        detailView.isShowNews = {
            guard let url = $0 else { return }
            self.viewModel.showNews(url: url)
        }

        let currentNews = viewModel.currentNews
        detailView.render(.init(news: currentNews))
    }
}
