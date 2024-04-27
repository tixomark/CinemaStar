// MediaItemDTO.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Структура, представляющая детальную информацию о конкретном медиа объекте
struct MediaItemDTO: Decodable {
    /// Иниальный идентификатор
    let id: Int
    /// Адрес постера
    let posterURL: String?
    /// Название
    let name: String
    /// Рейтинг
    let rating: Float?
    /// Описание конрчепции сюжета
    let description: String?
    /// Год производства
    let year: Int?
    /// Страна производства
    let country: String?
    /// Тип медиа обьекта
    let type: String?
    /// Список членов съемочной группы
    let persons: [PersonDTO]?
    /// Язык
    let language: String?
    /// Список похожих медиа
    let similarMovies: [SimilarMovieDTO]?

    enum CodingKeys: String, CodingKey {
        case id
        case posterURL = "poster"
        case name
        case rating
        case description
        case year
        case country = "countries"
        case type
        case persons
        case language = "spokenLanguages"
        case similarMovies
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
        name = try container.decode(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        year = try container.decodeIfPresent(Int.self, forKey: .year)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        persons = try container.decodeIfPresent([PersonDTO].self, forKey: .persons)
        similarMovies = try container.decodeIfPresent([SimilarMovieDTO].self, forKey: .similarMovies)

        let posterContainer = try container.nestedContainer(keyedBy: PosterCodingKeys.self, forKey: .posterURL)
        posterURL = try posterContainer.decodeIfPresent(String.self, forKey: .url)

        let ratingContainer = try container.nestedContainer(keyedBy: RatingCodingKeys.self, forKey: .rating)
        rating = try ratingContainer.decodeIfPresent(Float.self, forKey: .kp)

        let countries = try container.decodeIfPresent([CountryDTO].self, forKey: .country)
        country = countries?.first?.name

        let languages = try container.decodeIfPresent([LanguageDTO].self, forKey: .language)
        language = languages?.first?.name
    }
}
