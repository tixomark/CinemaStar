// AppCoordinator.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Основной координатор приложения
final class AppCoordinator: BaseCoordinator {
    // MARK: - Private Properties

    private var builder: Builder

    // MARK: - Visual Components

    private var window: UIWindow?

    // MARK: - Initializers

    init(window: UIWindow?, builder: Builder) {
        self.window = window
        self.builder = builder
    }

    // MARK: - Public Methods

    override func start() {
        showMovieListModule()
    }

    override func setAsRoot(_ viewController: UIViewController) {
        super.setAsRoot(viewController)
        window?.rootViewController = viewController
    }

    // MARK: - Private Methods

    private func showMovieListModule() {
        let navigationController = UINavigationController()
        let movieListCoordinator = MovieListCoordinator(rootController: navigationController, builder: builder)
        add(coordinator: movieListCoordinator)
        setAsRoot(navigationController)
        movieListCoordinator.start()
    }
}
