// MediaItemCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка содержащая краткую информацию о медиа обьекте
final class MediaItemCell: UICollectionViewCell {
    // MARK: - Visual Components

    private let posterImageView = {
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

    private lazy var stackView = {
        let stack = UIStackView(arrangedSubviews: [posterImageView, titleLabel, ratingLabel])
        stack.axis = .vertical
        stack.setCustomSpacing(8, after: posterImageView)
        stack.setCustomSpacing(4, after: titleLabel)
        return stack
    }()

    // MARK: - Public Properties

    var posterImage: UIImage? {
        get {
            posterImageView.image
        }
        set(newImage) {
            posterImageView.image = newImage
        }
    }

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

    // MARK: - Public Methods

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

    func configure(title: String?, rating: Float?) {
        titleLabel.text = title
        if let rating {
            ratingLabel.text = "⭐️ \(rating)"
        }
    }

    // MARK: - Private Methods

    private func configureUI() {
        posterImageView.backgroundColor = .red
        titleLabel.backgroundColor = .blue
        ratingLabel.backgroundColor = .cyan
        contentView.addSubview(stackView)
    }

    private func configureLayout() {
        UIView.doNotTAMIC(for: stackView)
        stackViewConfigureLayout()
    }

    private func stackViewConfigureLayout() {
        [
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            posterImageView.widthAnchor.constraint(equalTo: posterImageView.heightAnchor, multiplier: 0.85)
        ].activate()
    }
}
