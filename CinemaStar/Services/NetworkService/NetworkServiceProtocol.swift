// NetworkServiceProtocol.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол коммуникации с NetworkService
protocol NetworkServiceProtocol: AnyObject {
    func getListOfMediaItems() async -> [Doc]
    func getMovieById(_ id: Int) async -> MediaItem?
}

extension NetworkServiceProtocol where Self: URLRequestBuilding & DataFetching {
    func getListOfMediaItems() async -> [Doc] {
//        guard let request = createSearchMovieURLRequest(),
//              let result: ResponseDTO = await makeURLRequest(request) else { return [] }
        guard let moviesDataURL = Bundle.main.url(forResource: "Movies", withExtension: "json"),
              let data = try? Data(contentsOf: moviesDataURL),
              let result = try? JSONDecoder().decode(ResponseDTO.self, from: data)
        else { return [] }

        let docs = result.docs.map { Doc($0) }
        return docs
    }

    func getMovieById(_ id: Int) async -> MediaItem? {
//        guard let request = createGetMovieByIdURLRequest(id),
//              let result: MediaItemDTO = await makeURLRequest(request) else { return nil }
        guard let movieDataURL = Bundle.main.url(forResource: "Movie", withExtension: "json"),
              let data = try? Data(contentsOf: movieDataURL),
              let result = try? JSONDecoder().decode(MediaItemDTO.self, from: data)
        else { return nil }
        let mediaItem = MediaItem(result)
        return mediaItem
    }
}
