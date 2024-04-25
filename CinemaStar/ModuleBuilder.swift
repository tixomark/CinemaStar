// ModuleBuilder.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Описание доступных методов создания модулей приложения
protocol Builder: AnyObject {
    /// Собирает экран со списком фильмов
    func buildMovieListScreen(coordinator: MediaListCoordinatorProtocol) -> MediaListView
    /// Собирает экран детальной информации о фильме
    func buildMovieDetailScreen(coordinator: MediaListCoordinatorProtocol) -> MediaItemDetailView
}

/// Класс сборщик экранов
final class ModuleBuilder: Builder {
    // MARK: - Public Methods

    func buildMovieListScreen(coordinator: MediaListCoordinatorProtocol) -> MediaListView {
        let view = MediaListView()
        let viewModel = MediaListViewModel(coordinator: coordinator)
        view.viewModel = viewModel
        return view
    }

    func buildMovieDetailScreen(coordinator: MediaListCoordinatorProtocol) -> MediaItemDetailView {
        let view = MediaItemDetailView()
        let viewModel = MediaItemDetailViewModel(coordinator: coordinator)
        view.viewModel = viewModel
        return view
    }
}
