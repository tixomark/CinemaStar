// UIView+Extension.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Расширение `UIView`, позволяющее добавлять несколько дочерних представлений за раз.
extension UIView {
    /// Добавляет несколько сабвью на текущий экземпляр вью.
    /// - Parameter views: Представления, которые нужно добавить на текущее вью.
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }

    /// Добавляет несколько сабвью на текущий экземпляр вью.
    /// - Parameter views: Представления, которые нужно добавить на текущее вью.
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}

/// Расширение `UIView`, позволяющее переключать свойство `translatesAutoresizingMaskIntoConstraints` сразу у нескольких
/// представлений.
extension UIView {
    /// Устанавливает `translatesAutoresizingMaskIntoConstraints` в `false` для переданных представлений.
    /// - Parameter views: Представления, для которых нужно установить `translatesAutoresizingMaskIntoConstraints` в
    /// `false`.
    static func doNotTAMIC(for views: UIView...) {
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }

    /// Устанавливает `translatesAutoresizingMaskIntoConstraints` в `false` для переданных представлений.
    /// - Parameter views: Представления, для которых нужно установить `translatesAutoresizingMaskIntoConstraints` в
    /// `false`.
    static func doNotTAMIC(for views: [UIView]) {
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
}
