// PersonDTO.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Описание члена сьемочной группы
struct PersonDTO: Decodable {
    /// Путь к изображению
    let photoUrl: String?
    /// Имя
    let name: String?
}
