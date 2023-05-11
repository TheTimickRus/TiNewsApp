//
//  ServicesAssembly.swift
//  NewsApp
//
//  Created by Andrey Timofeev on 11.05.2023.
//

import UIKit

final class ServicesAssembly: Assembly {
    var apiService: ApiService {
        define(scope: .lazySingleton, init: ApiService())
    }
}
