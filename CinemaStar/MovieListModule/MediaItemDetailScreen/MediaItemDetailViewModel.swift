// MediaItemDetailViewModel.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

protocol MediaItemDetalViewModelProtocol: AnyObject {}

final class MediaItemDetailViewModel {
    // MARK: - Private Properties

    private weak var coordinator: MediaListCoordinatorProtocol?

    // MARK: - Life Cycle

    init(coordinator: MediaListCoordinatorProtocol) {
        self.coordinator = coordinator
    }
}

extension MediaItemDetailViewModel: MediaItemDetalViewModelProtocol {}
