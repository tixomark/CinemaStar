// MediaListView.swift
// Copyright © RoadMap. All rights reserved.

import AdvancedNSAttributedStringPKJ
import UIKit

/// Экран со списком медиа объектов
class MediaListView: UIViewController, UICollectionViewDelegate {
    // MARK: - Constants

    private enum Constants {
        static let headerText = "Смотри исторические фильмы на "
        static let nameText = "CINEMA STAR"
    }

    // MARK: - Visual Components

    private let gradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.userBrown.cgColor,
            UIColor.userDarkGreen.cgColor
        ]
        layer.locations = [0, 1]
        return layer
    }()

    private let titleLabel = {
        let label = UILabel()
        let text = Constants.headerText
            .attributed()
            .withColor(.label)
            .withFont(.inter(size: 20))
        text.append(
            Constants.nameText
                .attributed()
                .withColor(.label)
                .withFont(.interBlack(size: 20))
        )
        label.backgroundColor = .clear
        label.attributedText = text
        label.numberOfLines = 2
        return label
    }()

    private let mediaCollectionLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 14
        layout.minimumInteritemSpacing = 18
        layout.sectionInset = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16)
        return layout
    }()

    private lazy var mediaCollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: mediaCollectionLayout)
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(MediaItemCell.self, forCellWithReuseIdentifier: MediaItemCell.description())
        return collection
    }()

    // MARK: - Public Properties

    var viewModel: MediaListViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
        bindValues()
        viewModel.viewLoaded()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    // MARK: - Private Methods

    private func configureUI() {
        gradientLayer.frame = view.bounds
        view.backgroundColor = .white
        view.layer.addSublayer(gradientLayer)
        view.addSubviews(titleLabel, mediaCollectionView)

        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .white

        let avalibleWidth = view.bounds.width
            - mediaCollectionLayout.minimumInteritemSpacing
            - mediaCollectionLayout.sectionInset.left
            - mediaCollectionLayout.sectionInset.right
        let itemWidth = avalibleWidth / 2
        mediaCollectionLayout.estimatedItemSize = CGSize(width: itemWidth - 1, height: 300)
    }

    private func configureLayout() {
        UIView.doNotTAMIC(for: titleLabel, mediaCollectionView)
        titleLabelConfigureLayout()
        mediaCollectionViewConfigureLayout()
    }

    private func bindValues() {
        viewModel.state.bind { [weak self] _ in
            Task { @MainActor in
                self?.mediaCollectionView.reloadData()
            }
        }
    }

    private func titleLabelConfigureLayout() {
        [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ].activate()
    }

    private func mediaCollectionViewConfigureLayout() {
        [
            mediaCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            mediaCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mediaCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mediaCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ].activate()
    }
}

extension MediaListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewModel.state.value {
        case .loading:
            0
        case let .data(data):
            data.count
        case .noData, .error:
            0
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch viewModel.state.value {
        case .loading:
            return UICollectionViewCell()
        case let .data(data):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MediaItemCell.description(),
                for: indexPath
            ) as? MediaItemCell
            else {
                return UICollectionViewCell()
            }
            cell.configure(withDoc: data[indexPath.item])
            Task.detached(priority: .userInitiated) {
                let (data, index) = await self.viewModel.getImage(atIndex: indexPath.item)
                guard let data else { return }
                let image = UIImage(data: data)
                Task.detached { @MainActor in
                    if index == collectionView.indexPath(for: cell)?.item {
                        cell.posterImage = image
                    }
                }
            }
            return cell
        case .noData, .error:
            return UICollectionViewCell()
        }
    }
}

extension MediaListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didTapItem(atIndex: indexPath.item)
    }
}
