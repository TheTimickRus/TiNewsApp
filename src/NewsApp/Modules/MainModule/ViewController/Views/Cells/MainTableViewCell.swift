//
//  MainTableViewCell.swift
//  NewsApp
//
//  Created by Kate on 04.02.2023.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
    // MARK: Props

    struct Props: Equatable {
        let imageUrl: String
        let title: String
        let counter: Int
    }

    // MARK: - Private Props

    private var props: Props?

    // MARK: - Views

    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 20

        view.addShadow(ofColor: .black, radius: 12, opacity: 0.25)
        return view
    }()

    private lazy var articleImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        iv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return iv
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 0
        return label
    }()

    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .light)
        return label
    }()

    private lazy var labelsStackView = UIStackView(
        arrangedSubviews: [
            titleLabel,
            counterLabel
        ],
        axis: .vertical,
        spacing: 8,
        alignment: .leading
    )

    // MARK: - LifeCycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configure()
        setupConstaints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainTableViewCell {
    func render(_ props: Props) {
        guard self.props != props else { return }
        self.props = props

        articleImageView.loadImage(from: URL(string: props.imageUrl))

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
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            mainView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12),
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])


        articleImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            articleImageView.leftAnchor.constraint(equalTo: mainView.leftAnchor),
            articleImageView.topAnchor.constraint(equalTo: mainView.topAnchor),
            articleImageView.rightAnchor.constraint(equalTo: mainView.rightAnchor),
            articleImageView.heightAnchor.constraint(equalToConstant: 225)
        ])


        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelsStackView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 12),
            labelsStackView.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -12),
            labelsStackView.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 12),
            labelsStackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -12)
        ])

    }
}
