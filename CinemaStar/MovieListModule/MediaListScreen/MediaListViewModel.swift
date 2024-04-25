// MediaListViewModel.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол взаимодествия с MediaListViewModel
protocol MediaListViewModelProtocol: AnyObject {
    /// Сооющает о нажатии пользователем на ячейку по индексу
    func didTapItem(atIndex index: Int)
}

/// Вью модель экрана списка медиа объектов
final class MediaListViewModel {
    private weak var coordinator: MediaListCoordinatorProtocol?

    init(coordinator: MediaListCoordinatorProtocol) {
        self.coordinator = coordinator
    }
}

extension MediaListViewModel: MediaListViewModelProtocol {
    func didTapItem(atIndex index: Int) {
        coordinator?.showMediaItemDetailScreen()
    }
}
