//
//  TestLocalSearch.swift
//  WeatherAppTests
//
//  Created by Yuriy Gudimov on 05.02.2023.
//

import Foundation
import Combine
import WeatherKit

class TestLocalSearch: LocalSearchCompleter {
    var queries: [String] = []
    
    func search(with query: String) {
        queries.append(query)
    }
    
    var subject = PassthroughSubject<[LocalSearchCompletion], Never>()
    var results: AnyPublisher<[LocalSearchCompletion], Never> {
        subject.eraseToAnyPublisher()
    }
}
