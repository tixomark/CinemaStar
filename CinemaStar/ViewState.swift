// ViewState.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Состояние данных.
enum ViewState<Model> {
    /// Загрузка
    case loading
    /// Есть данные
    case data(_ model: Model)
    /// Нет данных
    case noData
    /// Ошибка
    case error(_ error: Error)
}
