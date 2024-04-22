// ModuleBuilder.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Описание доступных методов создания модулей приложения
protocol Builder: AnyObject {
    /// Собирает экран со списком фильмов
    func buildMovieListScreen(coordinator: MovieListCoordinatorProtocol) -> MovieListView
}

final class ModuleBuilder: Builder {
    // MARK: - Public Methods

    func buildMovieListScreen(coordinator: MovieListCoordinatorProtocol) -> MovieListView {
        let view = MovieListView()
        let viewModel = MovieListViewModel(coordinator: coordinator)
        view.viewModel = viewModel
        return view
    }
}
