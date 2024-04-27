// Array+Extension.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Расширение для удобной активации и деактивации массива констрейнт.
extension Array where Element == NSLayoutConstraint {
    /// Активирует все констрейнты из текущего массива.
    func activate() {
        NSLayoutConstraint.activate(self)
    }

    /// Деактивирует все констрейнты из текущего массива.
    func deactivate() {
        NSLayoutConstraint.deactivate(self)
    }
}
