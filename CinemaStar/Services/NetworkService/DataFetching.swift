// DataFetching.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

protocol DataFetching {
    func makeURLRequest<T: Decodable>(_ request: URLRequest) async -> T?
}

extension DataFetching {
    func makeURLRequest<T: Decodable>(_ request: URLRequest) async -> T? {
        guard let (data, responce) = try? await URLSession.shared.data(for: request),
              (responce as? HTTPURLResponse)?.statusCode == 200
        else { return nil }

        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch {
            return nil
        }
    }
}
