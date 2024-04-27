// SimilarMovie.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Структура, представляющая краткую информацию о схожем медиа объекте
struct SimilarMovie: Decodable {
    /// Иниальный идентификатор
    let id: Int
    /// Название
    let name: String?
    /// Адрес постера
    let posterURL: String?
}

extension SimilarMovie {
    init(_ dto: SimilarMovieDTO) {
        id = dto.id
        name = dto.name
        posterURL = dto.posterURL
    }
}
