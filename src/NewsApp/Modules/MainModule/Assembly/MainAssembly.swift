//
//  MainAssembly.swift
//  NewsApp
//
//  Created by Andrey Timofeev on 05.02.2023.
//

import UIKit

enum MainAssembly {
    static func create() -> UIViewController {
        let router = MainRouter()
        let viewModel = MainViewModel(router: router)
        let viewController = MainViewController(viewModel: viewModel)
        router.viewController = viewController

        return viewController
    }
}
