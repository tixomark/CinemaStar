// ImageLoadService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол абстрактного сервиса по загрузке картинок из сети
protocol ImageLoadServiceProtocol: ServiceProtocol {
    /// Пытается скачать данные по заданному URL
    func loadImage(atURL url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ())
    /// Пытается скачать данные по заданному URL
    func loadImage(atURL url: URL) async -> Data?
}

/// Сервис для загрузки картинок из сети
final class ImageLoadService: ImageLoadServiceProtocol {
    // MARK: - Public Properties

    var description: String {
        "ImageLoadService"
    }

    // MARK: - Public Methods

    func loadImage(atURL url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        session.dataTask(with: url, completionHandler: completion).resume()
    }

    func loadImage(atURL url: URL) async -> Data? {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        let data = try? await session.data(from: url).0
        return data
    }
}
