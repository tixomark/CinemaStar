// MovieCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

final class MovieCell: UICollectionViewCell {
    // MARK: - Visual Components

    private let movieImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()

    private let titleLabel = {
        let label = UILabel()
        label.font = .inter(size: 16)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    private let ratingLabel = {
        let label = UILabel()
        label.font = .inter(size: 16)
        label.textColor = .white
        return label
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
        configureLayout()
    }

    // MARK: - Private Methods

    override func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()

        let size = contentView.systemLayoutSizeFitting(
            layoutAttributes.size,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )

        layoutAttributes.frame.size.height = size.height.rounded()
        return layoutAttributes
    }

    func configure(title: String, rating: Float) {
        titleLabel.text = title
        ratingLabel.text = "⭐️ \(rating)"
    }

    // MARK: - Private Methods

    private func configureUI() {
        movieImageView.backgroundColor = .red
        titleLabel.backgroundColor = .blue
        ratingLabel.backgroundColor = .cyan
        contentView.addSubviews(movieImageView, titleLabel, ratingLabel)
    }

    private func configureLayout() {
        UIView.doNotTAMIC(for: movieImageView, titleLabel, ratingLabel)
        movieImageViewConfigureLayout()
        titleLabelConfigureLayout()
        ratingLabelConfigureLayout()
    }

    private func movieImageViewConfigureLayout() {
        [
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            movieImageView.widthAnchor.constraint(equalTo: movieImageView.heightAnchor, multiplier: 0.85)
        ].activate()
    }

    private func titleLabelConfigureLayout() {
        [
            titleLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ].activate()
    }

    private func ratingLabelConfigureLayout() {
        [
            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ratingLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ].activate()
    }
}
