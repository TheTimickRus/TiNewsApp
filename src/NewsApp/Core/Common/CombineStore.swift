//
//  CombineStore.swift
//  NewsApp
//
//  Created by Andrey Timofeev on 26.04.2023.
//

import Combine

public struct CombineStore {
    public var cancellable = Set<AnyCancellable>()

    public mutating func clear() {
        cancellable.forEach { $0.cancel() }
        cancellable.removeAll()
    }
}
