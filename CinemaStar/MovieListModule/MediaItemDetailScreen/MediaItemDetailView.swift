// MediaItemDetailView.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Вью с детальной иформацией по выбраннному медиа объекту
final class MediaItemDetailView: UIViewController {
    // MARK: - Constants

    private enum Constants {
        static let sectionHeaderTitles = ["Актеры и съемочная группа", "Язык", "Смотрите также"]
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

    private lazy var likeButton = {
        let button = UIButton()
        button.setImage(.heartIcon, for: .normal)
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var compositionalLayout =
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            guard let self, let section = self.viewModel?.mediaItemSections[sectionIndex] else { return nil }
            switch section {
            case .mainInfo:
                return self.createMainInfoLayoutSection()
            case .cast:
                return self.createCastLayoutSection()
            case .language:
                return self.createLanguageLayoutSection()
            case .watchAlso:
                return self.createWatchAlsoLayoutSection()
            }
        }

    private lazy var mediaCollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.delegate = self
        collection.register(MediaItemMainInfoCell.self, forCellWithReuseIdentifier: MediaItemMainInfoCell.description())
        collection.register(CastMemberCell.self, forCellWithReuseIdentifier: CastMemberCell.description())
        collection.register(LanguagesCell.self, forCellWithReuseIdentifier: LanguagesCell.description())
        collection.register(
            WatchAlsoMediaItemCell.self,
            forCellWithReuseIdentifier: WatchAlsoMediaItemCell.description()
        )
        collection.register(
            HeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderReusableView.description()
        )
        return collection
    }()

    // MARK: - Public Properties

    var viewModel: MediaItemDetalViewModelProtocol!

    // MARK: - Private Properties

    private lazy var mediaItemDataSource = createDataSource()

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
        navigationController?.navigationBar.isHidden = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    // MARK: - Private Properties

    private func configureUI() {
        gradientLayer.frame = view.bounds
        view.backgroundColor = .white
        view.layer.addSublayer(gradientLayer)
        view.addSubview(mediaCollectionView)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: likeButton)
        mediaCollectionView.dataSource = mediaItemDataSource
    }

    private func configureLayout() {
        UIView.doNotTAMIC(for: mediaCollectionView)
        collectionViewConfigureLayout()
    }

    private func collectionViewConfigureLayout() {
        [
            mediaCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mediaCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mediaCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mediaCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ].activate()
    }

    private func bindValues() {
        viewModel.state.bind { [weak self] state in
            var snapshot = NSDiffableDataSourceSnapshot<MediaItemDataSection, MediaItemType>()
            switch state {
            case .loading:
                snapshot.appendSections([])
                self?.mediaItemDataSource.apply(snapshot, animatingDifferences: true)
            case let .data(mediaItem):
                self?.viewModel.mediaItemSections.forEach { section in
                    var itemsToApply: [MediaItemType] = []
                    switch section {
                    case .mainInfo:
                        itemsToApply = [.main(mediaItem)]
                    case .cast:
                        itemsToApply = mediaItem.persons.map { MediaItemType.person($0) }
                    case .language:
                        if let language = mediaItem.language {
                            itemsToApply = [.language(language)]
                        }
                    case .watchAlso:
                        itemsToApply = mediaItem.similarMovies.map { .similarMovie($0) }
                    }
                    snapshot.appendSections([section])
                    snapshot.appendItems(itemsToApply, toSection: section)
                }
            case .noData, .error:
                break
            }
            Task { @MainActor in
                self?.mediaItemDataSource.apply(snapshot, animatingDifferences: true)
            }
        }
        viewModel.isWatching.bind { [weak self] isWatching in
            if isWatching {
                self?.showUnderDevelopmentAlert()
            }
        }
        viewModel.isFavourite.bind { [weak self] isFavourite in
            let image: UIImage = isFavourite ? .heartIconFilled : .heartIcon
            self?.likeButton.setImage(image, for: .normal)
        }
    }

    @objc private func likeButtonTapped() {
        viewModel.didTapLikeButton()
    }
}

// MARK: Diffable Datasource methods

extension MediaItemDetailView {
    typealias MediaItemDataSource = UICollectionViewDiffableDataSource<MediaItemDataSection, MediaItemType>

    private func createDataSource() -> MediaItemDataSource {
        let dataSource = MediaItemDataSource(collectionView: mediaCollectionView) { collectionView, indexPath, item in
            switch item {
            case let .main(mediaItem):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MediaItemMainInfoCell.description(),
                    for: indexPath
                ) as? MediaItemMainInfoCell
                else { return UICollectionViewCell() }

                cell.configure(with: mediaItem)
                cell.watchButtonTappedHandler = { [weak self] in
                    self?.viewModel.watchButtonTapped()
                }
                Task.detached(priority: .userInitiated) {
                    let (data, index) = await self.viewModel.getImage(atIndexPath: indexPath)
                    guard let data else { return }
                    let image = UIImage(data: data)
                    Task.detached { @MainActor in
                        if index == collectionView.indexPath(for: cell) {
                            cell.posterImage = image
                        }
                    }
                }
                return cell
            case let .person(person):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CastMemberCell.description(),
                    for: indexPath
                ) as? CastMemberCell
                else { return UICollectionViewCell() }

                cell.castMemberName = person.name
                Task.detached(priority: .userInitiated) {
                    let (data, index) = await self.viewModel.getImage(atIndexPath: indexPath)
                    guard let data else { return }
                    let image = UIImage(data: data)
                    Task.detached { @MainActor in
                        if index == collectionView.indexPath(for: cell) {
                            cell.castMemberImage = image
                        }
                    }
                }
                return cell
            case let .language(language):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: LanguagesCell.description(),
                    for: indexPath
                ) as? LanguagesCell
                else { return UICollectionViewCell() }
                cell.title = language
                return cell

            case let .similarMovie(similarMovie):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: WatchAlsoMediaItemCell.description(),
                    for: indexPath
                ) as? WatchAlsoMediaItemCell
                else { return UICollectionViewCell() }

                cell.title = similarMovie.name
                Task.detached(priority: .userInitiated) {
                    let (data, index) = await self.viewModel.getImage(atIndexPath: indexPath)
                    guard let data else { return }
                    let image = UIImage(data: data)
                    Task.detached { @MainActor in
                        if index == collectionView.indexPath(for: cell) {
                            cell.posterImage = image
                        }
                    }
                }
                return cell
            }
        }

        dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            guard let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: HeaderReusableView.description(),
                for: indexPath
            ) as? HeaderReusableView
            else { return UICollectionReusableView() }

            switch self.viewModel.mediaItemSections[indexPath.section] {
            case .mainInfo:
                break
            case .cast:
                view.title = Constants.sectionHeaderTitles[0]
            case .language:
                view.title = Constants.sectionHeaderTitles[1]
            case .watchAlso:
                view.title = Constants.sectionHeaderTitles[2]
            }
            return view
        }
        return dataSource
    }
}

extension MediaItemDetailView: UICollectionViewDelegateFlowLayout {}
