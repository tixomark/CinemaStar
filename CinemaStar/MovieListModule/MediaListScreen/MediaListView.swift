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
        collection.delegate = self
        collection.register(MediaItemCell.self, forCellWithReuseIdentifier: MediaItemCell.description())
        return collection
    }()

    // MARK: - Public Properties

    var viewModel: MediaListViewModelProtocol!

    // MARK: - Private Properties

    private lazy var mediaDataSource = createDataSource()

    // MARK: - Life Cycle

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

        mediaCollectionView.dataSource = mediaDataSource
    }

    private func configureLayout() {
        UIView.doNotTAMIC(for: titleLabel, mediaCollectionView)
        titleLabelConfigureLayout()
        mediaCollectionViewConfigureLayout()
    }

    private func bindValues() {
        viewModel.state.bind { [weak self] state in
            Task { @MainActor in
                switch state {
                case .loading:
                    var snapshot = NSDiffableDataSourceSnapshot<Section, Doc>()
                    snapshot.appendSections([.first])
                    self?.mediaDataSource.apply(snapshot, animatingDifferences: true)
                case let .data(docs):
                    var snapshot = NSDiffableDataSourceSnapshot<Section, Doc>()
                    snapshot.appendSections([.first])
                    snapshot.appendItems(docs, toSection: .first)
                    self?.mediaDataSource.apply(snapshot, animatingDifferences: true)
                case .noData, .error:
                    break
                }
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

// MARK: Diffable Datasource methods

extension MediaListView {
    enum Section {
        case first
    }

    typealias MediaDataSource = UICollectionViewDiffableDataSource<Section, Doc>

    private func createDataSource() -> MediaDataSource {
        let dataSource = MediaDataSource(collectionView: mediaCollectionView) { collectionView, indexPath, doc in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MediaItemCell.description(),
                for: indexPath
            ) as? MediaItemCell
            else { return UICollectionViewCell() }
            cell.configure(withDoc: doc)
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
        }
        return dataSource
    }
}

extension MediaListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didTapItem(atIndex: indexPath.item)
    }
}
