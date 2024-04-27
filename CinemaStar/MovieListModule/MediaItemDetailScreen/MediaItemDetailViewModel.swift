// MediaItemDetailViewModel.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

protocol MediaItemDetalViewModelProtocol: AnyObject {
    /// Состояние загрузки данных по объекту
    var state: Dynamic<ViewState<MediaItem>> { get }
    /// Сообщает о том что вью загрузилась
    func viewLoaded()
}

final class MediaItemDetailViewModel {
    // MARK: - Public Properties

    private(set) var state = Dynamic<ViewState<MediaItem>>(.loading)

    // MARK: - Private Properties

    private let itemId: Int
    private weak var coordinator: MediaListCoordinatorProtocol?
    private weak var networkService: NetworkServiceProtocol?

    // MARK: - Initializers

    init(itemId: Int, coordinator: MediaListCoordinatorProtocol, networkService: NetworkServiceProtocol?) {
        self.itemId = itemId
        self.coordinator = coordinator
        self.networkService = networkService
    }
}

extension MediaItemDetailViewModel: MediaItemDetalViewModelProtocol {
    func viewLoaded() {
        Task(priority: .userInitiated) {
            guard let mediaItem = await networkService?.getMovieById(itemId) else { return }
            state.value = .data(mediaItem)
        }
    }
}
