// PersonDTO.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Описание члена сьемочной группы
struct PersonDTO: Decodable {
    /// Уникальный идентификатор
    let id: Int
    /// Путь к изображению
    let photoUrl: String?
    /// Имя
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id
        case photoUrl = "photo"
        case name
    }
}
