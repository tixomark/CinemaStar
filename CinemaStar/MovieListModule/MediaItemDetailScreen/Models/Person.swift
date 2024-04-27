// Person.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Описание члена сьемочной группы
struct Person {
    /// Уникальный идентификатор
    let id: Int
    /// Путь к изображению
    let photoUrl: String?
    /// Имя
    let name: String?
}

extension Person {
    init(_ dto: PersonDTO) {
        id = dto.id
        name = dto.name
        photoUrl = dto.photoUrl?
            .replacingOccurrences(of: "//", with: "/")
            .replacingOccurrences(of: "https:/", with: "https://")
    }
}

extension Person: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Person, rhs: Person) -> Bool {
        lhs.id == rhs.id
    }
}
