// MovieListView.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Экран со списком фильмов
class MovieListView: UIViewController {
    // MARK: - Private Properties

    var viewModel: MovieListViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }
}
