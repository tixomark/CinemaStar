// MediaItem.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Описание датального медиа обьекта
struct MediaItem {
    /// Иниальный идентификатор
    let id: Int
    /// Адрес постера
    let posterURL: String?
    /// Название
    let name: String
    /// Рейтинг
    let rating: Float?
    /// Описание конрчепции сюжета
    let description: String
    /// Год производства
    let year: Int?
    /// Страна производства
    let country: String?
    /// Тип медиа обьекта
    let type: String?
    /// Список членов съемочной группы
    let persons: [Person]
    /// Язык
    let language: String?
    /// Список похожих медиа
    let similarMovies: [SimilarMovie]
}

extension MediaItem {
    init(_ dto: MediaItemDTO) {
        id = dto.id
        posterURL = dto.posterURL
        name = dto.name
        rating = dto.rating
        description = dto.description ?? ""
        year = dto.year
        country = dto.country
        type = dto.type
        persons = dto.persons?.compactMap { Person($0) } ?? []
        language = dto.language
        similarMovies = dto.similarMovies?.compactMap { SimilarMovie($0) } ?? []
    }
}
