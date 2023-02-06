//
//  MainRouter.swift
//  NewsApp
//
//  Created by Kate on 05.02.2023.
//

import UIKit

final class MainRouter {
    weak var viewController: UIViewController?
}

extension MainRouter {
    func showDetailNews(news: News) {
        let detailViewController = DetailAssembly.create(news: news)
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }

    func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        viewController?.navigationController?.present(alert, animated: true)
    }
}
