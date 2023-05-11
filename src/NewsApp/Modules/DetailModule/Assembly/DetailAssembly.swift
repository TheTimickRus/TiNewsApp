//
//  DetailAssembly.swift
//  NewsApp
//
//  Created by Andrey Timofeev on 05.02.2023.
//

import UIKit

enum DetailAssembly {
    static func create(news: News) -> UIViewController {
        let router = DetailRouter()
        let viewModel = DetailViewModel(router: router, currentNews: news)
        let viewController = DetailViewController(viewModel: viewModel)
        router.viewController = viewController

        return viewController
    }
}
