// URLRequestBuilding.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

protocol URLRequestBuilding {
    var baseUrlComponents: URLComponents { get }
    func createSearchMovieURLRequest() -> URLRequest?
    func createGetMovieByIdURLRequest(_ id: Int) -> URLRequest?
}
