// MovieListCoordinator.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Интерфейс взаимодействия с MovieListCoordinator
protocol MovieListCoordinatorProtocol: AnyObject {}

/// Координатор модуля списка фильмов
final class MovieListCoordinator: BaseCoordinator {
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
        let movieListScreen = builder.buildMovieListScreen(coordinator: self)
        rootController.setViewControllers([movieListScreen], animated: false)
    }
}

extension MovieListCoordinator: MovieListCoordinatorProtocol {}
