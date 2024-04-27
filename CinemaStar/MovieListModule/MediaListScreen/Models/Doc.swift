// Doc.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Структура, представляющая краткую информацию о конкретном медиа объекте
struct Doc {
    /// Иниальный идентификатор
    let id: Int
    /// Название
    let name: String?
    /// Адрес постера
    let posterURL: String?
    /// Рейтинг
    let rating: Float?
}

extension Doc {
    init(_ dto: DocDTO) {
        id = dto.id
        name = dto.name
        posterURL = dto.posterURL
        rating = dto.rating
    }
}
