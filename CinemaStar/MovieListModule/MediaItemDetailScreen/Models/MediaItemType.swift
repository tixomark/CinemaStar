// MediaItemType.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Тип секции по которым разбито отображение информации о медиа объекте
enum MediaItemType: Hashable {
    case main(MediaItem)
    case person(Person)
    case language(String)
    case similarMovie(SimilarMovie)
}
