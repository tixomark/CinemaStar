// MovieListViewModel.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

protocol MovieListViewModelProtocol: AnyObject {}

final class MovieListViewModel {
    private var coordinator: MovieListCoordinatorProtocol

    init(coordinator: MovieListCoordinatorProtocol) {
        self.coordinator = coordinator
    }
}

extension MovieListViewModel: MovieListViewModelProtocol {}
