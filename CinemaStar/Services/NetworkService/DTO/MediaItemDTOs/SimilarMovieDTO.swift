// SimilarMovieDTO.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Структура, представляющая краткую информацию о схожем медиа объекте
struct SimilarMovieDTO: Decodable {
    /// Иниальный идентификатор
    let id: Int
    /// Название
    let name: String?
    /// Адрес постера
    let posterURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case posterURL = "poster"
    }

    enum PosterCodingKeys: String, CodingKey {
        case previewUrl
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)

        let posterContainer = try container.nestedContainer(keyedBy: PosterCodingKeys.self, forKey: .posterURL)
        posterURL = try posterContainer.decodeIfPresent(String.self, forKey: .previewUrl)
    }
}
