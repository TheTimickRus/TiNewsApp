//
//  MainView.swift
//  NewsApp
//
//  Created by Andrey Timofeev on 04.02.2023.
//

import UIKit

final class MainView: UIView {
    // MARK: - Props

    struct MainViewProps: Equatable {
        let items: [News]
    }

    // MARK: - Public Props

    var isRefreshCallBack: (() -> Void)?
    var isLoadMoreData: (() -> Void)?
    var isShowDetail: ((News) -> Void)?

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
        guard self.mainViewProps != props else { return }
        self.mainViewProps = props
        self.items = props.items

        tableView.reloadData()
    }
}

private extension MainView {
    func configure() {
        backgroundColor = .white

        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)

        tableView.refreshControl = refreshControl

        tableView.separatorStyle = .none

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "MainCell")

        addSubview(tableView)
    }

    func setupConstaints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

    @objc
    private func handleRefresh() {
        isRefreshCallBack?()
        refreshControl.endRefreshing()
    }
}

extension MainView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as? MainTableViewCell
        else {
            return UITableViewCell()
        }

        let item = self.items[indexPath.row]
        cell.render(.init(imageUrl: item.imageUrl, title: item.title, counter: item.counter))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        self.isShowDetail?(item)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == items.count - 2 {
            isLoadMoreData?()
        }
    }
}
