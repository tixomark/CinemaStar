// NetworkService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Сервис для работы с Recipe Search API
final class NetworkService: ServiceProtocol, NetworkServiceProtocol, DataFetching {
    // MARK: - Constants

    enum Constants {
        static let scheme = "https"
        static let host = "api.kinopoisk.dev"
        static let basePath = "/v1.4/movie"
        static let searchPathComponent = "search"
        static let queryParam = "query"
        static let apiKeyHeader = "X-API-KEY"
    }

    // MARK: - Private Properties

    private var apiKey: String? {
        KeyChainService.getValue(byKey: Constants.apiKeyHeader)
    }

    // MARK: - Public Properties

    var description: String {
        "Network service"
    }
}

extension NetworkService: URLRequestBuilding {
    var baseUrlComponents: URLComponents {
        var component = URLComponents()
        component.scheme = Constants.scheme
        component.host = Constants.host
        component.path = Constants.basePath
        return component
    }

    func createSearchMovieURLRequest() -> URLRequest? {
        var components = baseUrlComponents
        components.queryItems = [.init(name: Constants.queryParam, value: "История")]
        guard var url = components.url, let apiKey else { return nil }
        url.append(path: Constants.searchPathComponent)
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: Constants.apiKeyHeader)
        return request
    }

    func createGetMovieByIdURLRequest(_ id: Int) -> URLRequest? {
        guard var url = baseUrlComponents.url, let apiKey else { return nil }
        url.append(path: id.description)
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: Constants.apiKeyHeader)
        return request
    }
}
