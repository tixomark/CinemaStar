// MediaItemDetailViewModel.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

protocol MediaItemDetalViewModelProtocol: AnyObject {
    var mediaItemSections: [MediaItemDataSection] { get }
    /// Состояние загрузки данных по объекту
    var state: Dynamic<ViewState<MediaItem>> { get }
    /// Состояние просмотра
    var isWatching: Dynamic<Bool> { get }
    /// Сообщает о том что вью загрузилась
    func viewLoaded()
    /// Просит загрузить картинку для ячейки по индексу
    func getImage(atIndexPath indexPath: IndexPath) async -> (Data?, IndexPath)
    /// Сообщает о нажатии на кноку просметра
    func watchButtonTapped()
    /// Сообщает о закрытии уведомления о разработке функционала
    func underDevelopmentMessageDidClose()
}

final class MediaItemDetailViewModel {
    // MARK: - Public Properties

    private(set) var state = Dynamic<ViewState<MediaItem>>(.loading)
    private(set) var isWatching = Dynamic(false)

    // MARK: - Private Properties

    private let itemId: Int
    private weak var coordinator: MediaListCoordinatorProtocol?
    private weak var networkService: NetworkServiceProtocol?
    private weak var imageLoadService: ImageLoadServiceProtocol?

    private(set) var mediaItemSections: [MediaItemDataSection] = [.mainInfo]

    // MARK: - Initializers

    init(
        itemId: Int,
        coordinator: MediaListCoordinatorProtocol,
        networkService: NetworkServiceProtocol?,
        imageLoadService: ImageLoadServiceProtocol?
    ) {
        self.itemId = itemId
        self.coordinator = coordinator
        self.networkService = networkService
        self.imageLoadService = imageLoadService
    }
}

extension MediaItemDetailViewModel: MediaItemDetalViewModelProtocol {
    func viewLoaded() {
        Task.detached(priority: .userInitiated) {
            guard let mediaItem = await self.networkService?.getMovieById(self.itemId) else { return }
            self.mediaItemSections = [.mainInfo]
            if !mediaItem.persons.isEmpty {
                self.mediaItemSections.append(.cast)
            }
            if mediaItem.language != nil {
                self.mediaItemSections.append(.language)
            }
            if !mediaItem.similarMovies.isEmpty {
                self.mediaItemSections.append(.watchAlso)
            }
            self.state.value = .data(mediaItem)
        }
    }

    func getImage(atIndexPath indexPath: IndexPath) async -> (Data?, IndexPath) {
        var result: (data: Data?, indexPath: IndexPath) = (nil, indexPath)
        var urlString: String?

        guard case let .data(mediaItem) = state.value else { return result }
        switch mediaItemSections[indexPath.section] {
        case .mainInfo:
            urlString = mediaItem.posterURL
        case .cast:
            urlString = mediaItem.persons[indexPath.item].photoUrl
        case .language:
            break
        case .watchAlso:
            urlString = mediaItem.similarMovies[indexPath.item].posterURL
        }

        guard let urlString, let url = URL(string: urlString) else { return result }
        let data = await imageLoadService?.loadImage(atURL: url)
        result.data = data
        return result
    }

    func watchButtonTapped() {
        isWatching.value = true
    }

    func underDevelopmentMessageDidClose() {
        isWatching.value = false
    }
}
