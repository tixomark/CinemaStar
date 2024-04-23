// NSLayoutConstraint+Extension.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Расширение для удобной работы с констрейнтами.
extension NSLayoutConstraint {
    /// Активирует текущую констрейнту.
    func activate() {
        isActive = true
    }

    /// Деактивирует текущую констрейнту.
    func deactivate() {
        isActive = false
    }

    /// Модифицирует текущую констрейнту указанным приоритетом.
    /// - Parameter priority: Приоритет, который нужно применить к констрейнте.
    /// - Returns: Текущая констрейнта с новым приоритетом.
    func priority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }

    /// Модифицирует текущую констрейнту указанным приоритетом.
    /// - Parameter priority: Приоритет, который нужно применить к констрейнте.
    /// - Returns: Текущая констрейнта с новым приоритетом.
    func priority(_ priority: Float) -> NSLayoutConstraint {
        self.priority = .init(rawValue: priority)
        return self
    }
}
