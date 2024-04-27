// ResponceDTO.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Структура для декодирования JSON-ответа от сервера.
struct ResponseDTO: Decodable {
    /// Массив объектов типа `DocDTO`, содержащих информацию о медиа объектах.
    let docs: [DocDTO]
}
