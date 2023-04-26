//
//  DetailView.swift
//  NewsApp
//
//  Created by Andrey Timofeev on 05.02.2023.
//

import Kingfisher
import SwiftDate
import SwifterSwift
import UIKit

final class DetailView: UIView {
    // MARK: - Props

    struct Props: Equatable {
        let news: News
    }

    // MARK: - Internal Props

    var isShowNews: ((String?) -> Void)?

    // MARK: - Private Props

    private var props: Props?

    // MARK: - Views

    private lazy var articleImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        return iv
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 0
        return label
    }()

    private lazy var dateAndAutorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .light)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    private lazy var showNewsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Открыть новость", for: .normal)
        return button
    }()

    // MARK: - LifeCycle

    init() {
        super.init(frame: .zero)

        configure()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailView {
    func render(_ props: Props) {
        guard self.props != props else { return }
        self.props = props

        articleImageView.kf.setImage(with: URL(string: props.news.imageUrl), placeholder: Assets.Images.placegolder)
        titleLabel.text = props.news.title
        dateAndAutorLabel.text = "\(props.news.publishedAt.toISODate()?.toString(.dateTime(.medium)) ?? "-"), \(props.news.author)"
        descriptionLabel.text = props.news.description
    }
}

private extension DetailView {
    func configure() {
        backgroundColor = .systemBackground

        addSubviews([
            articleImageView,
            titleLabel,
            dateAndAutorLabel,
            descriptionLabel,
            showNewsButton
        ])

        showNewsButton.addTarget(self, action: #selector(showNews), for: .touchUpInside)
    }

    func setupConstraints() {
        articleImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateAndAutorLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        showNewsButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            articleImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            articleImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12),
            articleImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12),
            articleImageView.heightAnchor.constraint(equalToConstant: 250),

            titleLabel.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 12),
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12),
            titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12),

            dateAndAutorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            dateAndAutorLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12),
            dateAndAutorLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12),

            descriptionLabel.topAnchor.constraint(equalTo: dateAndAutorLabel.bottomAnchor, constant: 12),
            descriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12),
            descriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12),

            showNewsButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            showNewsButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12),
            showNewsButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12)
        ])
    }

    @objc
    func showNews() {
        isShowNews?(self.props?.news.url)
    }
}
