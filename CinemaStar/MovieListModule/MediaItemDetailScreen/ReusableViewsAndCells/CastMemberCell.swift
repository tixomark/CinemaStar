// CastMemberCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка содержащая информацию о члене сьемочной группы
final class CastMemberCell: UICollectionViewCell {
    // MARK: - Visual Components

    private let castMemberImageView = UIImageView()

    private let castMemberNameLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.font = .inter(size: 8)
        return label
    }()

    private lazy var stackView = {
        let stack = UIStackView(arrangedSubviews: [castMemberImageView, castMemberNameLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 2
        return stack
    }()

    // MARK: - Public Properties

    var castMemberImage: UIImage? {
        get {
            castMemberImageView.image
        }
        set(newImage) {
            castMemberImageView.image = newImage
        }
    }

    var castMemberName: String? {
        get {
            castMemberNameLabel.text
        }
        set(newName) {
            castMemberNameLabel.text = newName
        }
    }

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

    // MARK: - Public Methods

    override func prepareForReuse() {
        super.prepareForReuse()
        castMemberImage = nil
    }

    // MARK: - Private Methods

    private func configureUI() {
        contentView.addSubviews(stackView)
    }

    private func configureLayout() {
        UIView.doNotTAMIC(for: stackView)
        stackViewConfigureLayout()
    }

    private func stackViewConfigureLayout() {
        [
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            castMemberImageView.widthAnchor.constraint(equalTo: castMemberImageView.heightAnchor, multiplier: 0.64),
            castMemberImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.76)
        ].activate()
    }
}
