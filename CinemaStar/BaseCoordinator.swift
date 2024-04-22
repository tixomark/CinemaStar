// BaseCoordinator.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Абстрактный класс координатора
class BaseCoordinator: NSObject, Coordinator {
    // MARK: - Public Properties

    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []

    // MARK: - Public Methods

    func start() {
        fatalError("Child should implement funcStart")
    }

    func setAsRoot(_ viewController: UIViewController) {}

    func childDidFinish(_ child: Coordinator) {
        remove(coordinator: child)
    }
}
