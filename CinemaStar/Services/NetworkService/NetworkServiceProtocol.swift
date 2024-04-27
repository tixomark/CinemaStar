// NetworkServiceProtocol.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол коммуникации с NetworkService
protocol NetworkServiceProtocol: AnyObject {
    /// Получить список медиа обхектов
    func getListOfMediaItems() async -> [Doc]
    /// Получить медиа объект по идентификатору
    func getMovieById(_ id: Int) async -> MediaItem?
}

extension NetworkServiceProtocol where Self: URLRequestBuilding & DataFetching {
    func getListOfMediaItems() async -> [Doc] {
        guard let request = createSearchMovieURLRequest(),
              let result: ResponseDTO = await makeURLRequest(request) else { return [] }
        let docs = result.docs.map { Doc($0) }
        return docs
    }

    func getMovieById(_ id: Int) async -> MediaItem? {
        guard let request = createGetMovieByIdURLRequest(id),
              let result: MediaItemDTO = await makeURLRequest(request) else { return nil }
        let mediaItem = MediaItem(result)
        return mediaItem
    }
}
