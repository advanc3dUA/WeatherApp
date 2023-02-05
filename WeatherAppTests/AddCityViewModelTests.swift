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

class AddCityViewModelCityTests: CombineTestCase {
    var viewModel: AddCityViewModel!
    var localSearch: TestLocalSearch!
    var geocoder: TestGeocoder!
    
    override func setUp() {
        super.setUp()
        localSearch = TestLocalSearch()
        TestEnvironment.push()
        Current.localSearch = localSearch
        Current.geocoder = geocoder
        
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
