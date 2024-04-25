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
            guard let self,
                  self.collectionViewSections.indices.contains(sectionIndex)
            else { return nil }

            switch self.collectionViewSections[sectionIndex] {
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

    var viewModel: MediaItemDetalViewModelProtocol?

    // MARK: - Private Properties

    private let collectionViewSections: [MediaItemDetailCollectionViewSection] = [
        .mainInfo,
        .cast,
        .language,
        .watchAlso
    ]

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
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

    @objc private func likeButtonTapped() {}
}

extension MediaItemDetailView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        collectionViewSections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionViewSections[section] {
        case .mainInfo:
            1
        case .cast:
            10
        case .language:
            1
        case .watchAlso:
            5
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch collectionViewSections[indexPath.section] {
        case .mainInfo:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MediaItemMainInfoCell.description(),
                for: indexPath
            ) as? MediaItemMainInfoCell
            else { return UICollectionViewCell() }
            cell.configure(
                title: "Демон революции sadfasdfads",
                rating: 6.2,
                plot:
                """
                1915 год. Европа охвачена огнем Первой мировой войны.
                В это время теоретик революции, политический эмигрант и авантюрист
                Александр Парвус проводит переговоры с министром иностранных дел ...
                """,
                metadata: "2017 / Россия / Сериал"
            )
            return cell
        case .cast:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CastMemberCell.description(),
                for: indexPath
            ) as? CastMemberCell
            else { return UICollectionViewCell() }
            cell.castMemberName = "namename surnameeeee"
            return cell
        case .language:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LanguagesCell.description(),
                for: indexPath
            ) as? LanguagesCell
            else { return UICollectionViewCell() }
            cell.title = "Русский"
            return cell
        case .watchAlso:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WatchAlsoMediaItemCell.description(),
                for: indexPath
            ) as? WatchAlsoMediaItemCell
            else { return UICollectionViewCell() }
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

        view.title = Constants.sectionHeaderTitles[indexPath.section - 1]
        return view
    }
}

extension MediaItemDetailView: UICollectionViewDelegateFlowLayout {}
