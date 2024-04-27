// MediaListViewModel.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол взаимодествия с MediaListViewModel
protocol MediaListViewModelProtocol: AnyObject {
    /// Состояние загрузки данных по медиа обьектам
    var state: Dynamic<ViewState<[Doc]>> { get }
    /// Сообщает о том что вью загрузилась
    func viewLoaded()
    /// Сооющает о нажатии пользователем на ячейку по индексу
    func didTapItem(atIndex index: Int)
    /// Просит загрузить картинку для ячейки по индексу
    func getImage(atIndex index: Int) async -> (Data?, Int)
}

/// Вью модель экрана списка медиа объектов
final class MediaListViewModel {
    // MARK: - Public Properties

    private(set) var state = Dynamic<ViewState<[Doc]>>(.loading)

    // MARK: - Private Properties

    private weak var coordinator: MediaListCoordinatorProtocol?
    private weak var networkService: NetworkServiceProtocol?
    private weak var imageLoadService: ImageLoadServiceProtocol?

    // MARK: - Initializers

    init(
        coordinator: MediaListCoordinatorProtocol,
        networkService: NetworkServiceProtocol?,
        imageLoadService: ImageLoadServiceProtocol?
    ) {
        self.coordinator = coordinator
        self.networkService = networkService
        self.imageLoadService = imageLoadService
    }

    // MARK: - Private Methods
}

extension MediaListViewModel: MediaListViewModelProtocol {
    func viewLoaded() {
        Task(priority: .userInitiated) {
            guard let docs = await networkService?.getListOfMediaItems() else { return }
            state.value = .data(docs)
        }
    }

    func didTapItem(atIndex index: Int) {
        guard case let .data(docs) = state.value else { return }
        coordinator?.showMediaDetailScreenForItem(withId: docs[index].id)
    }

    func getImage(atIndex index: Int) async -> (Data?, Int) {
        guard case let .data(docs) = state.value,
              let urlString = docs[index].posterURL,
              let url = URL(string: urlString)
        else { return (nil, index) }
        let data = await imageLoadService?.loadImage(atURL: url)
        return (data, index)
    }
}
