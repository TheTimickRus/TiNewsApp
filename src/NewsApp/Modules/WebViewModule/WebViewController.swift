//
//  WebViewController.swift
//  NewsApp
//
//  Created by Andrey Timofeev on 05.02.2023.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    // MARK: - Internal Props

    var urlString: String?

    // MARK: - Views

    private lazy var webView = WKWebView()

    // MARK: - LifeCycle

    override func loadView() {
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
}

private extension WebViewController {
    func configure() {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }

        let request = URLRequest(url: url)
        self.webView.load(request)
    }
}
