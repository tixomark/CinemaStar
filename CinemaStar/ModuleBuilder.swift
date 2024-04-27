// ModuleBuilder.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Описание доступных методов создания модулей приложения
protocol Builder: AnyObject {
    /// Собирает экран со списком фильмов
    func buildMovieListScreen(coordinator: MediaListCoordinatorProtocol) -> MediaListView
    /// Собирает экран детальной информации о фильме
    func buildMovieDetailScreen(itemId: Int, coordinator: MediaListCoordinatorProtocol) -> MediaItemDetailView
}

/// Класс сборщик экранов
final class ModuleBuilder: Builder {
    // MARK: - Private Properties

    private let serviceLocator: ServiceLocatorProtocol

    // MARK: - Initializers

    init(serviceLocator: ServiceLocatorProtocol) {
        self.serviceLocator = serviceLocator
    }

    // MARK: - Public Methods

    func buildMovieListScreen(coordinator: MediaListCoordinatorProtocol) -> MediaListView {
        let view = MediaListView()
        let viewModel = MediaListViewModel(
            coordinator: coordinator,
            networkService: serviceLocator.getService(NetworkService.self)
        )
        view.viewModel = viewModel
        return view
    }

    func buildMovieDetailScreen(itemId: Int, coordinator: MediaListCoordinatorProtocol) -> MediaItemDetailView {
        let view = MediaItemDetailView()
        let viewModel = MediaItemDetailViewModel(
            itemId: itemId,
            coordinator: coordinator,
            networkService: serviceLocator.getService(NetworkService.self)
        )
        view.viewModel = viewModel
        return view
    }
}
