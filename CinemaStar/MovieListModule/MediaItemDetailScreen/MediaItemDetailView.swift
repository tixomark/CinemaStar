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

    private lazy var collectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.dataSource = self
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
        view.addSubview(collectionView)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: likeButton)
    }

    private func configureLayout() {
        UIView.doNotTAMIC(for: collectionView)
        collectionViewConfigureLayout()
    }

    private func collectionViewConfigureLayout() {
        [
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ].activate()
    }

    private func bindValues() {
        viewModel.state.bind { [weak self] _ in
            Task.detached { @MainActor in
                self?.collectionView.reloadData()
            }
        }
        viewModel.isWatching.bind { [weak self] isWatching in
            if isWatching {
                self?.showUnderDevelopmentAlert()
            }
        }
    }

    @objc private func likeButtonTapped() {}
}

extension MediaItemDetailView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel?.mediaItemSections.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard case let .data(mediaItem) = viewModel?.state.value else { return 0 }
        let section = viewModel.mediaItemSections[section]
        switch section {
        case .mainInfo:
            return 1
        case .cast:
            return mediaItem.persons.count
        case .language:
            return 1
        case .watchAlso:
            return mediaItem.similarMovies.count
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard case let .data(mediaItem) = viewModel?.state.value,
              let section = viewModel?.mediaItemSections[indexPath.section]
        else { return UICollectionViewCell() }

        switch section {
        case .mainInfo:
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

        case .cast:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CastMemberCell.description(),
                for: indexPath
            ) as? CastMemberCell
            else { return UICollectionViewCell() }

            cell.castMemberName = mediaItem.persons[indexPath.item].name
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

        case .language:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LanguagesCell.description(),
                for: indexPath
            ) as? LanguagesCell
            else { return UICollectionViewCell() }
            cell.title = mediaItem.language
            return cell

        case .watchAlso:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WatchAlsoMediaItemCell.description(),
                for: indexPath
            ) as? WatchAlsoMediaItemCell
            else { return UICollectionViewCell() }

            cell.title = mediaItem.similarMovies[indexPath.item].name
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

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderReusableView.description(),
            for: indexPath
        ) as? HeaderReusableView
        else { return UICollectionReusableView() }

        switch viewModel.mediaItemSections[indexPath.section] {
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
}

extension MediaItemDetailView: UICollectionViewDelegateFlowLayout {}
