//
//  AddCityViewModelTests.swift
//  WeatherAppTests
//
//  Created by Yuriy Gudimov on 04.02.2023.
//

import Foundation
import Combine
import XCTest
import WeatherKit
@testable import WeatherApp

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

class AddCityViewModelCityTests: CombineTestCase {
    var viewModel: AddCityViewModel!
    var localSearch: TestLocalSearch!
    
    override func setUp() {
        super.setUp()
        localSearch = TestLocalSearch()
        TestEnvironment.push()
        Current.localSearch = localSearch
        
        viewModel = AddCityViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
        TestEnvironment.pop()
    }
    
    func testSetSearchTerm() {
        viewModel.searchTerm = "Houston"
        viewModel.searchTerm = "Dallas"
        XCTAssertEqual(localSearch.queries, ["Houston", "Dallas"])
    }
    
    func testFiltersOutResultsThatDontLookLikeCities() {
        let houstonResult = LocalSearchCompletion(title: "Houston, TX", subTitle: "")
        let houstonRestaurantResult = LocalSearchCompletion(title: "Houston's Restaurant", subTitle: "")
        localSearch.subject.send([houstonResult, houstonRestaurantResult])
        XCTAssertEqual(viewModel.results, [houstonResult])
    }
}
