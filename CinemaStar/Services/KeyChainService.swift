// KeyChainService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import KeyChainPKJ

/// Обертка для создания и удаления колючей из KeyChain
struct KeyChainService {
    /// Сохраняет строковое значение в Keychain.
    static func save(_ value: String, byKey key: String) {
        KeyChain.save(value, forKey: key)
    }

    /// Получает сохраненное строковое значение из Keychain.
    static func getValue(byKey key: String) -> String? {
        KeyChain.getValue(forKey: key)
    }
}
