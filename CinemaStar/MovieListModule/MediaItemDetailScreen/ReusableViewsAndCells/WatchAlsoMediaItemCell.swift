// WatchAlsoMediaItemCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка содержащая краткую информацию о медиа обьекте в разделе "Смотрите также"
final class WatchAlsoMediaItemCell: UICollectionViewCell {
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
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()

    private lazy var stackView = {
        let stack = UIStackView(arrangedSubviews: [posterImageView, titleLabel])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()

    // MARK: - Public Properties

    var title: String? {
        get {
            titleLabel.text
        }
        set(newTitle) {
            titleLabel.text = newTitle
        }
    }

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

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImage = nil
    }

    // MARK: - Private Methods

    private func configureUI() {
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
