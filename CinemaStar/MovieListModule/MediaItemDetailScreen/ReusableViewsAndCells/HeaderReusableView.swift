// HeaderReusableView.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Вью с заголовком для секции
final class HeaderReusableView: UICollectionReusableView {
    // MARK: - Visual Components

    private let headerLabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .interSemiBold(size: 14)
        return label
    }()

    // MARK: - Public Properties

    var title: String? {
        get {
            headerLabel.text
        }
        set(newTitle) {
            headerLabel.text = newTitle
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
        headerLabel.backgroundColor = .systemPink
        backgroundColor = .magenta
        addSubviews(headerLabel)
    }

    private func configureLayout() {
        UIView.doNotTAMIC(for: headerLabel)
        headerLabelConfigureLayout()
    }

    private func headerLabelConfigureLayout() {
        [
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ].activate()
    }
}
