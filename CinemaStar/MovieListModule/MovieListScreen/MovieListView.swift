// MovieListView.swift
// Copyright © RoadMap. All rights reserved.

import AdvancedNSAttributedStringPKJ
import UIKit

/// Экран со списком фильмов
class MovieListView: UIViewController, UICollectionViewDelegate {
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

    private let moviesCollectionLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 14
        layout.minimumInteritemSpacing = 18
        layout.sectionInset = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16)
        return layout
    }()

    private lazy var moviesCollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: moviesCollectionLayout)
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.description())
        return collection
    }()

    // MARK: - Private Properties

    var viewModel: MovieListViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
    }

    // MARK: - Private Methods

    private func configureUI() {
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
        view.addSubviews(titleLabel, moviesCollectionView)
        navigationController?.navigationBar.isHidden = true

        let avalibleWidth = view.bounds.width
            - moviesCollectionLayout.minimumInteritemSpacing
            - moviesCollectionLayout.sectionInset.left
            - moviesCollectionLayout.sectionInset.right
        let itemWidth = avalibleWidth / 2
        moviesCollectionLayout.estimatedItemSize = CGSize(width: itemWidth - 1, height: 300)
    }

    private func configureLayout() {
        UIView.doNotTAMIC(for: moviesCollectionView, titleLabel)
        titleLabelConfigureLayout()
        moviesCollectionViewConfigureLayout()
    }

    private func titleLabelConfigureLayout() {
        [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ].activate()
    }

    private func moviesCollectionViewConfigureLayout() {
        [
            moviesCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            moviesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            moviesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            moviesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ].activate()
    }
}

extension MovieListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieCell.description(),
            for: indexPath
        ) as? MovieCell
        else {
            return UICollectionViewCell()
        }

        let text = indexPath.item % 3 == 0 ? "MOview asf  \n asdf" : "Hello"
        cell.configure(title: text, rating: 8.9)

        return cell
    }
}

extension MovieListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected item ", indexPath.item)
    }

//    func collectionView(
//        _ collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        sizeForItemAt indexPath: IndexPath
//    ) -> CGSize {
//        let avalibleWidth = view.frame.width
//            - moviesCollectionLayout.minimumInteritemSpacing
//            - moviesCollectionLayout.sectionInset.left
//            - moviesCollectionLayout.sectionInset.right
//        let itemWidth = avalibleWidth / 2
//
//        return CGSize(width: itemWidth, height: UIView.layoutFittingCompressedSize.height)
//    }
}
