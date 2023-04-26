//
//  MainTableViewCell.swift
//  NewsApp
//
//  Created by Andrey Timofeev on 04.02.2023.
//

import Kingfisher
import SnapKit
import SwifterSwift
import Then
import UIKit

final class MainTableViewCell: UITableViewCell {
    // MARK: - Props

    struct Props: Equatable {
        let imageUrl: String
        let title: String
        let counter: Int
    }

    // MARK: - Private Props

    private var props: Props?

    // MARK: - Views

    private lazy var mainView = UIView().then {
        $0.backgroundColor = .secondarySystemBackground
        $0.layerCornerRadius = Constants.mainCornerRadius
        $0.addShadow(ofColor: .black, radius: 12, opacity: 0.25)
    }

    private lazy var articleImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layerCornerRadius = Constants.mainCornerRadius
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    private lazy var titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .bold)
        $0.numberOfLines = 0
    }

    private lazy var counterLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 10, weight: .light)
    }

    private lazy var labelsStackView = UIStackView(
        arrangedSubviews: [
            titleLabel,
            counterLabel
        ],
        axis: .vertical,
        spacing: Constants.vStackLabelsSpacing,
        alignment: .leading
    )

    // MARK: - LifeCycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configure()
        setupConstaints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainTableViewCell {
    func render(_ props: Props) {
        guard self.props != props else { return }
        self.props = props

        articleImageView.kf.setImage(with: URL(string: props.imageUrl), placeholder: Assets.Images.placegolder)

        titleLabel.text = props.title

        counterLabel.text = "Вы переходили к данной новости (раз): \(props.counter)"
        counterLabel.isHidden = props.counter == 0
    }
}

private extension MainTableViewCell {
    func configure() {
        backgroundColor = .clear
        selectionStyle = .none

        mainView.addSubviews([
            articleImageView,
            labelsStackView
        ])

        contentView.addSubview(mainView)
    }

    func setupConstaints() {
        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Constants.mainInset)
        }

        articleImageView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(Constants.articleImageHeight)
        }

        labelsStackView.snp.makeConstraints {
            $0.top.equalTo(articleImageView.snp.bottom).offset(Constants.mainInset.top)
            $0.left.right.bottom.equalToSuperview().inset(Constants.mainInset)
        }
    }
}

private extension MainTableViewCell {
    enum Constants {
        static let mainCornerRadius = 20.0
        static let vStackLabelsSpacing = 8.0
        static let articleImageHeight = 225.0
        static let mainInset = UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
    }
}
