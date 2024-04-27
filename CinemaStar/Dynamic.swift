// Dynamic.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// `Dynamic` - универсальный класс, который позволяет создавать свойства, которые можно "привязать" к определенным
/// слушателям
final class Dynamic<T> {
    typealias Listener = (T) -> Void
    private var listener: Listener?

    func bind(_ listener: Listener?) {
        self.listener = listener
    }

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }
}
