// UIFont+Extension.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Расширение для удобного получения пользовательских шрифтов.
extension UIFont {
    /// Возвращает пользовательский шрифт Inter указанного размера.
    /// - Parameter size: Размер шрифта.
    /// - Returns: Экземпляр шрифта Inter указанного размера, если доступен, иначе `nil`.
    static func inter(size: CGFloat) -> UIFont? {
        userFont(name: "Inter-Regular", size: size)
    }

    /// Возвращает жирный пользовательский шрифт Inter-SemiBold указанного размера.
    /// - Parameter size: Размер шрифта.
    /// - Returns: Экземпляр жирного шрифта Inter-SemiBold указанного размера, если доступен, иначе `nil`.
    static func interSemiBold(size: CGFloat) -> UIFont? {
        userFont(name: "Inter-SemiBold", size: size)
    }

    /// Возвращает жирный курсивный пользовательский шрифт Inter-Black указанного размера.
    /// - Parameter size: Размер шрифта.
    /// - Returns: Экземпляр жирного курсивного шрифта Inter-Black указанного размера, если доступен, иначе `nil`.
    static func interBlack(size: CGFloat) -> UIFont? {
        userFont(name: "Inter-Black", size: size)
    }

    /// Словарь уже инициализированных шрифтов
    private static var flyFontsMap: [String: UIFont] = [:]

    /// Возвращает пользовательский шрифт указанного имени и размера.
    /// - Parameters:
    ///   - name: Имя шрифта.
    ///   - size: Размер шрифта.
    /// - Returns: Экземпляр пользовательского шрифта указанного имени и размера, если доступен, иначе `nil`.
    static func userFont(name: String, size: CGFloat) -> UIFont? {
        let identifier = name + "\(size)"
        if let font = UIFont.flyFontsMap[identifier] {
            return font
        }
        let font = UIFont(name: name, size: size)
        UIFont.flyFontsMap[identifier] = font
        return font
    }
}
