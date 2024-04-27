// ImageLoadProxy.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Прокси сервис, занимающийся кешированием и загрузкой изображений
final class ImageLoadProxy: ImageLoadServiceProtocol {
    // MARK: - Constants

    private enum Constants {
        static let cachedImagesURL = FileManager.default.getDirectory(
            withName: "CachedImages",
            inUserDomain: .cachesDirectory
        )
    }

    // MARK: - Public Properties

    var description: String {
        "ImageLoadProxy"
    }

    // MARK: - Private Properties

    private weak var imageLoadService: ImageLoadServiceProtocol?

    // MARK: - Initializers

    init(imageLoadService: ImageLoadServiceProtocol) {
        self.imageLoadService = imageLoadService
    }

    // MARK: - Public Methods

    func loadImage(atURL url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        DispatchQueue.global(qos: .background).async {
            let imageName = url.pathComponents.dropFirst().joined()
            if let imageData = self.fetchImage(withName: imageName) {
                completion(imageData, nil, nil)
            } else {
                self.imageLoadService?.loadImage(atURL: url) { [weak self] data, responce, error in
                    self?.saveImage(withName: imageName, imageData: data)
                    completion(data, responce, error)
                }
            }
        }
    }

    func loadImage(atURL url: URL) async -> Data? {
        let imageName = url.pathComponents.dropFirst().joined()
        if let imageData = fetchImage(withName: imageName) {
            return imageData
        } else {
            guard let imageData = await imageLoadService?.loadImage(atURL: url) else { return nil }
            saveImage(withName: imageName, imageData: imageData)
            return imageData
        }
    }

    // MARK: - Private Methods

    private func fetchImage(withName imageName: String) -> Data? {
        guard let imageURL = Constants.cachedImagesURL?.appending(path: imageName),
              let imageData = FileManager.default.contents(atPath: imageURL.path())
        else { return nil }
        return imageData
    }

    @discardableResult
    private func saveImage(withName name: String, imageData data: Data?) -> Bool {
        guard let data,
              let imageURL = Constants.cachedImagesURL?
              .appending(path: name),
              FileManager.default.createFile(atPath: imageURL.path(), contents: data)
        else { return false }
        return true
    }
}
