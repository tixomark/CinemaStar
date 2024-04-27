// DocDTO.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Структура, представляющая краткую информацию о конкретном медиа объекте
struct DocDTO: Decodable {
    /// Иниальный идентификатор
    let id: Int
    /// Название
    let name: String?
    /// Адрес постера
    let posterURL: String?
    /// Рейтинг
    let rating: Float?

    enum CodingKeys: String, CodingKey {
        case name
        case id
        case posterURL = "poster"
        case rating
    }

    enum PosterCodingKeys: String, CodingKey {
        case url
    }

    enum RatingCodingKeys: String, CodingKey {
        case kp
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)

        let posterContainer = try container.nestedContainer(keyedBy: PosterCodingKeys.self, forKey: .posterURL)
        posterURL = try posterContainer.decodeIfPresent(String.self, forKey: .url)

        let ratingContainer = try container.nestedContainer(keyedBy: RatingCodingKeys.self, forKey: .rating)
        rating = try ratingContainer.decodeIfPresent(Float.self, forKey: .kp)
    }
}
