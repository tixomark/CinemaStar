// Coordinator.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Интерфейс стандартного координатора
protocol Coordinator: AnyObject {
    /// Родительский координатор
    var parentCoordinator: Coordinator? { get set }
    /// Массив дочерних координаторов
    var childCoordinators: [Coordinator] { get set }
    /// Метод запуска координатора
    func start()
    /// Далает переданный контроллер рутовым для текущего координатора
    func setAsRoot(_ viewController: UIViewController)
    /// Сообщает что дочерний координатор завершил работу
    func childDidFinish(_ child: Coordinator)
}

extension Coordinator {
    /// Добавление переданного координатора в массив дочерних координаторов
    /// - Parameter coordinator: Координатор который требуется добавить
    func add(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
    }

    /// Удаление переданного координатора из массива дочерних координаторов
    /// - Parameter coordinator: Координатор который требуется удалить
    func remove(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
