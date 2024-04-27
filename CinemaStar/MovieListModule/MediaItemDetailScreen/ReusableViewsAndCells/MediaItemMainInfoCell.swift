// MediaItemMainInfoCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка содержащая основную информацию о медиа объекте
final class MediaItemMainInfoCell: UICollectionViewCell {
    // MARK: - Constants

    private enum Constants {
        static let watchText = "Смотреть"
    }

    // MARK: - Visual Components

    private let posterImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.cornerCurve = .continuous
        return view
    }()

    private let titleLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .interSemiBold(size: 18)
        return label
    }()

    private let ratingLabel = {
        let label = UILabel()
        label.font = .inter(size: 16)
        label.textColor = .white
        return label
    }()

    private let plotLabel = {
        let label = UILabel()
        label.numberOfLines = 5
        label.font = .inter(size: 14)
        label.textColor = .white
        return label
    }()

    private let metadataLabel = {
        let label = UILabel()
        label.font = .inter(size: 14)
        label.textColor = .black.withAlphaComponent(0.41)
        return label
    }()

    private lazy var titleRatingStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, ratingLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        return stack
    }()

    private lazy var movieStackView = {
        let stack = UIStackView(arrangedSubviews: [posterImageView, titleRatingStackView])
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 16
        return stack
    }()

    private lazy var watchButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .inter(size: 16)
        button.setTitle(Constants.watchText, for: .normal)
        button.backgroundColor = .userDarkGreen
        button.layer.cornerRadius = 12
        button.layer.cornerCurve = .continuous
        return button
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
        configureLayout()
    }

    func configure(with item: MediaItem) {
        titleLabel.text = item.name
        if let rating = item.rating {
            ratingLabel.text = "⭐️ \(rating)"
        }
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 4
        plotLabel.attributedText = item.description.attributed()
            .withParagraphStyle(paragraph)
            .withFont(.inter(size: 14))
            .withColor(.white)
        let metadataParams = [item.year?.description, item.country, item.type].compactMap { $0 }
        metadataLabel.text = metadataParams.joined(separator: " / ")
    }

    // MARK: - Private Methods

    private func configureUI() {
        posterImageView.backgroundColor = .red
        titleLabel.backgroundColor = .blue
        ratingLabel.backgroundColor = .magenta
        plotLabel.backgroundColor = .purple
        metadataLabel.backgroundColor = .orange
        contentView.backgroundColor = .lightGray
        contentView.addSubviews(movieStackView, watchButton, plotLabel, metadataLabel)
    }

    private func configureLayout() {
        UIView.doNotTAMIC(for: movieStackView, watchButton, plotLabel, metadataLabel)
        movieStackViewConfigureLayout()
        watchButtonConfigureLayout()
        plotLabelConfigureLayout()
        metadataLabelConfigureLayout()
    }

    private func movieStackViewConfigureLayout() {
        [
            movieStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.widthAnchor.constraint(equalTo: posterImageView.heightAnchor, multiplier: 0.85),
            posterImageView.heightAnchor.constraint(equalTo: movieStackView.heightAnchor)
        ].activate()
    }

    private func watchButtonConfigureLayout() {
        [
            watchButton.topAnchor.constraint(equalTo: movieStackView.bottomAnchor, constant: 16),
            watchButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            watchButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            watchButton.heightAnchor.constraint(equalToConstant: 48)
        ].activate()
    }

    private func plotLabelConfigureLayout() {
        [
            plotLabel.topAnchor.constraint(equalTo: watchButton.bottomAnchor, constant: 16),
            plotLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            plotLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ].activate()
    }

    private func metadataLabelConfigureLayout() {
        [
            metadataLabel.topAnchor.constraint(equalTo: plotLabel.bottomAnchor, constant: 10),
            metadataLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            metadataLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            metadataLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ].activate()
    }
}
