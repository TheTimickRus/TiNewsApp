//
//  DetailRouter.swift
//  NewsApp
//
//  Created by Andrey Timofeev on 05.02.2023.
//

import UIKit

final class DetailRouter {
    weak var viewController: UIViewController?
}

extension DetailRouter {
    func showNews(url: String) {
        let webViewController = WebViewController()
        webViewController.urlString = url
        self.viewController?.navigationController?.pushViewController(webViewController, animated: true)
    }
}
