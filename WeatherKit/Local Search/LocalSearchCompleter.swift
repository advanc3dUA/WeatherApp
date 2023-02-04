//
//  LocalSearchCompleter.swift
//  WeatherKit
//
//  Created by Yuriy Gudimov on 04.02.2023.
//

import Foundation
import Combine

public protocol LocalSearchCompleter {
    func search(with query: String)
    var results: AnyPublisher<[LocalSearchCompletion], Never> { get }
}
