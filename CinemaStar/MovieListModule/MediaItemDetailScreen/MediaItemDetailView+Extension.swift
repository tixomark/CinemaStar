// MediaItemDetailView+Extension.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

extension MediaItemDetailView {
    func createMainInfoLayoutSection() -> NSCollectionLayoutSection {
        let item = createItem(width: .fractionalWidth(1), height: .estimated(410))

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(410))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
        return section
    }

    func createCastLayoutSection() -> NSCollectionLayoutSection {
        let item = createItem(width: .fractionalWidth(1), height: .estimated(90))

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.15), heightDimension: .estimated(90))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 10, leading: 16, bottom: 14, trailing: 16)
        section.interGroupSpacing = 8
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [createHeader()]
        return section
    }

    func createLanguageLayoutSection() -> NSCollectionLayoutSection {
        let item = createItem(width: .fractionalWidth(1), height: .fractionalHeight(1))

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 4, leading: 16, bottom: 10, trailing: 16)
        section.orthogonalScrollingBehavior = .none
        section.boundarySupplementaryItems = [createHeader()]
        return section
    }

    func createWatchAlsoLayoutSection() -> NSCollectionLayoutSection {
        let item = createItem(width: .fractionalWidth(1), height: .estimated(228))

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.44), heightDimension: .estimated(228))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 8, leading: 16, bottom: 16, trailing: 16)
        section.interGroupSpacing = 16
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [createHeader()]
        return section
    }

    private func createItem(
        width: NSCollectionLayoutDimension,
        height: NSCollectionLayoutDimension
    ) -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
        return NSCollectionLayoutItem(layoutSize: itemSize)
    }

    private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
        return header
    }
}

extension MediaItemDetailView {
    func showUnderDevelopmentAlert() {
        let alert = UIAlertController(title: "Упс!", message: "Функционал в разработке :(")
        let okAction = UIAlertAction(title: "Ок") { _ in
            self.viewModel.underDevelopmentMessageDidClose()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
