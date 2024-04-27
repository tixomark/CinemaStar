// Person.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Описание члена сьемочной группы
struct Person {
    /// Путь к изображению
    let photoUrl: String?
    /// Имя
    let name: String?
}

extension Person {
    init(_ dto: PersonDTO) {
        name = dto.name
        photoUrl = dto.photoUrl
    }
}
