//
//  ViewModel.swift
//  NewsApp
//
//  Created by Andrey Timofeev on 26.04.2023.
//

public protocol ViewModel {
    associatedtype Input
    associatedtype Output

    func transform(input: Input, output: (Output) -> Void)
}
