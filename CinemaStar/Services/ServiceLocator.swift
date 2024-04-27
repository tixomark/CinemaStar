// ServiceLocator.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол взаимодействия с ServiceDistributor
protocol ServiceLocatorProtocol: AnyObject {
    /// Региструрует переданный сервис
    func registerService<T: ServiceProtocol>(service: T)
    /// Выдает сервис указанного типа
    func getService<T: ServiceProtocol>(_ type: T.Type) -> T?
}

/// Обьект занимающийся управлением и выдачей сервисов
final class ServiceDistributor {
    // MARK: - Private Properties

    private var servicesMap: [String: ServiceProtocol] = [:]
}

extension ServiceDistributor: ServiceLocatorProtocol {
    func registerService<T: ServiceProtocol>(service: T) {
        let key = String(describing: T.Type.self)
        guard servicesMap[key] == nil else { return }
        servicesMap[key] = service
    }

    func getService<T: ServiceProtocol>(_ type: T.Type) -> T? {
        let key = String(describing: T.Type.self)
        return servicesMap[key] as? T
    }
}
