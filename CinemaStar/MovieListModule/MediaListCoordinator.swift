// MediaListCoordinator.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Интерфейс взаимодействия с MediaListCoordinator
protocol MediaListCoordinatorProtocol: AnyObject {
    /// Показфвает экран детальной информации по медиа объекту
    func showMediaItemDetailScreen()
}

/// Координатор модуля списка медиа
final class MediaListCoordinator: BaseCoordinator {
    // MARK: - Visual Components

    private var rootController: UINavigationController

    // MARK: - Private Properties

    private var builder: Builder

    // MARK: - Initializers

    init(rootController: UINavigationController, builder: Builder) {
        self.rootController = rootController
        self.builder = builder
    }

    // MARK: - Public Methods

    override func start() {
        let movieListView = builder.buildMovieListScreen(coordinator: self)
        rootController.setViewControllers([movieListView], animated: false)
    }
}

extension MediaListCoordinator: MediaListCoordinatorProtocol {
    func showMediaItemDetailScreen() {
        let movieDetailView = builder.buildMovieDetailScreen(coordinator: self)
        rootController.pushViewController(movieDetailView, animated: true)
    }
}
