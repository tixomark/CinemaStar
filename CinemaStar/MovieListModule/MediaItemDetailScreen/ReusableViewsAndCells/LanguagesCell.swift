// LanguagesCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка содержащая информацию о доступных языках для конкретного медиа объекта
final class LanguagesCell: UICollectionViewCell {
    // MARK: - Visual Components

    private let languagesLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black.withAlphaComponent(0.41)
        label.font = .inter(size: 14)
        return label
    }()

    // MARK: - Public Properties

    var title: String? {
        get {
            languagesLabel.text
        }
        set(newTitle) {
            languagesLabel.text = newTitle
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

    // MARK: - Private Methods

    private func configureUI() {
        languagesLabel.backgroundColor = .blue
        contentView.backgroundColor = .green
        contentView.addSubviews(languagesLabel)
    }

    private func configureLayout() {
        UIView.doNotTAMIC(for: languagesLabel)
        languagesLabelConfigureLayout()
    }

    private func languagesLabelConfigureLayout() {
        [
            languagesLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            languagesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            languagesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            languagesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ].activate()
    }
}
