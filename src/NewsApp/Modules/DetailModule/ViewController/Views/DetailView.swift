//
//  DetailView.swift
//  NewsApp
//
//  Created by Andrey Timofeev on 05.02.2023.
//

import Combine
import CombineCocoa
import CombineExt
import Kingfisher
import SnapKit
import SwiftDate
import SwifterSwift
import Then
import UIKit

final class DetailView: UIView {
    // MARK: - Props

    struct Props: Equatable {
        let news: News
    }

    // MARK: - Internal Props

    var showNewsButtonTapPublisher: AnyPublisher<Void, Never> {
        showNewsButton.tapPublisher
    }

    // MARK: - Private Props

    private var props: Props?

    // MARK: - Views

    private lazy var articleImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layerCornerRadius = Constants.articleImageViewCornerRadius
    }

    private lazy var titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .bold)
        $0.numberOfLines = 0
    }

    private lazy var dateAndAutorLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 10, weight: .light)
    }

    private lazy var descriptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.numberOfLines = 0
    }

    private lazy var showNewsButton = UIButton(type: .system).then {
        $0.setTitle("Открыть новость", for: .normal)
    }

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
    }

    func setupConstraints() {
        articleImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview().inset(Constants.mainInset)
            $0.height.equalTo(Constants.articleImageViewHeight)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(articleImageView.snp.bottom).offset(Constants.mainInset)
            $0.leading.trailing.equalToSuperview().inset(Constants.mainInset)
        }

        dateAndAutorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.mainInset)
            $0.leading.trailing.equalToSuperview().inset(Constants.mainInset)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(dateAndAutorLabel.snp.bottom).offset(Constants.mainInset)
            $0.leading.trailing.equalToSuperview().inset(Constants.mainInset)
        }

        showNewsButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(Constants.mainInset)
            $0.leading.trailing.equalToSuperview().inset(Constants.mainInset)
        }
    }
}

private extension DetailView {
    enum Constants {
        static let articleImageViewCornerRadius = 20.0
        static let articleImageViewHeight = 250.0
        static let mainInset = 12.0
    }
}
