// FileManager+Extension.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Расширение для управления файловой системой.
extension FileManager {
    /// Получает URL-адрес для указанной директории в домене пользователя.
    /// Если директория не существует, она будет создана.
    /// - Parameters:
    ///   - name: Имя целевой директории.
    ///   - directory: Каталог, в котором будет создана директория.
    /// - Returns: URL-адрес целевой директории, либо `nil`, если не удалось получить URL-адрес или создать директорию.
    func getDirectory(withName name: String, inUserDomain directory: FileManager.SearchPathDirectory) -> URL? {
        guard let targetURL = FileManager.default
            .urls(for: directory, in: .userDomainMask)
            .first?
            .appendingPathComponent(name)
        else { return nil }

        let targetPath = targetURL.path
        if !FileManager.default.fileExists(atPath: targetPath) {
            do {
                try FileManager.default.createDirectory(
                    atPath: targetPath,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
                print("Successfully created \"\(name)\"")
            } catch {
                print("Error creating folder: \(error)")
            }
        }
        return targetURL
    }
}
