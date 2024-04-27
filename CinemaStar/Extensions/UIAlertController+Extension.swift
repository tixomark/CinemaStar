// UIAlertController+Extension.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Расширение для создания экземпляра `UIAlertController` с возможностью упрощения инициализации.
extension UIAlertController {
    /// Создает экземпляр `UIAlertController` с возможностью опускания некоторых параметров для упрощения инициализации.
    /// - Parameters:
    ///   - title: Заголовок алерта. Опциональный параметр, по умолчанию `nil`.
    ///   - message: Сообщение алерта. Опциональный параметр, по умолчанию `nil`.
    ///   - style: Стиль алерта, который может быть `.alert` или `.actionSheet`. По умолчанию `.alert`.
    convenience init(
        title: String? = nil,
        message: String? = nil,
        style: UIAlertController.Style = .alert
    ) {
        self.init(title: title, message: message, preferredStyle: style)
    }
}

/// Расширение для создания экземпляра `UIAlertAction` с возможностью упрощения инициализации.
extension UIAlertAction {
    /// Создает экземпляр `UIAlertAction` с возможностью опускания некоторых параметров для упрощения инициализации.
    /// - Parameters:
    ///   - title: Текст, отображаемый на кнопке действия.
    ///   - style: Стиль действия, который может быть `.default`, `.cancel` или `.destructive`.
    ///            По умолчанию `.default`, что подразумевает стандартное действие без особой стилизации.
    ///   - completionHandler: Блок кода, который выполнится после выбора данного действия пользователем.
    ///                        Опциональный параметр, по умолчанию пустая функция, что означает отсутствие
    ///                        дополнительных действий после нажатия.
    convenience init(
        title: String,
        style: UIAlertAction.Style = .default,
        completionHandler: ((UIAlertAction) -> Void)? = { _ in }
    ) {
        self.init(title: title, style: style, handler: completionHandler)
    }
}
