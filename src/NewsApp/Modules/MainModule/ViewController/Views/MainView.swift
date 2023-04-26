//
//  MainView.swift
//  NewsApp
//
//  Created by Andrey Timofeev on 04.02.2023.
//

import Combine
import CombineCocoa
import SnapKit
import SwifterSwift
import UIKit

final class MainView: UIView {
    // MARK: - Props

    struct MainViewProps: Equatable {
        let items: [News]
    }

    // MARK: - Public Props

    var refreshPublisher: AnyPublisher<Bool, Never> {
        refreshControl.isRefreshingPublisher
            .map { _ in true }
            .eraseToAnyPublisher()
    }

    var loadMoreDataPublisher: AnyPublisher<Bool, Never> {
        tableView.willDisplayCellPublisher
            .filter { [weak self] in
                $0.indexPath.row == (self?.items.count ?? 0) - 2
            }
            .map { _ in false }
            .eraseToAnyPublisher()
    }

    var didSelectRowPublisher: AnyPublisher<News, Never> {
        tableView.didSelectRowPublisher
            .compactMap { [weak self] in
                self?.items[$0.row]
            }
            .eraseToAnyPublisher()
    }

    // MARK: - Private Props

    private var mainViewProps: MainViewProps?
    private var items: [News] = []

    // MARK: - Views

    private lazy var tableView = UITableView()
    private lazy var refreshControl = UIRefreshControl()

    // MARK: - LifeCycle

    init() {
        super.init(frame: .zero)

        configure()
        setupConstaints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainView {
    func render(_ props: MainViewProps) {
        defer {
            refreshControl.endRefreshing()
        }

        guard self.mainViewProps != props else { return }
        self.mainViewProps = props
        self.items = props.items

        tableView.reloadData()
    }
}

private extension MainView {
    func configure() {
        backgroundColor = .white

        tableView.refreshControl = refreshControl

        tableView.separatorStyle = .none

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellWithClass: MainTableViewCell.self)

        addSubview(tableView)
    }

    func setupConstaints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension MainView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: MainTableViewCell.self)

        let item = self.items[indexPath.row]
        cell.render(.init(imageUrl: item.imageUrl, title: item.title, counter: item.counter))
        return cell
    }
}
