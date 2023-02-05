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
import CoreLocation
import MapKit
@testable import WeatherApp

class AddCityViewModelCityTests: CombineTestCase {
    var viewModel: AddCityViewModel!
    var localSearch: TestLocalSearch!
    var geocoder: TestGeocoder!
    
    override func setUp() {
        super.setUp()
        localSearch = TestLocalSearch()
        geocoder = TestGeocoder()
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
    
    func testGeocodesResultIntoCity() {
        viewModel.results = [LocalSearchCompletion(title: "Houston, TX", subTitle: "")]
        let pub = viewModel.geolocate(selectedIndex: 0)
            .assertNoFailure()
        let exprectedCity = City(name: "Houston", locality: "TX", latitude: 29, longitude: -95)
        let houstonPlacemark = TestPlacemark(coordinate: CLLocationCoordinate2D(latitude: 29, longitude: -95), name: "Houston", locality: "TX")
        
        assertPublisher(pub, produces: exprectedCity) {
            geocoder.subject.send([houstonPlacemark])
            geocoder.subject.send(completion: .finished)
        }
        
    }
    
    func testGeocodingFails() {
        viewModel.results = [LocalSearchCompletion(title: "Houston, TX", subTitle: "")]
        let pub = viewModel.geolocate(selectedIndex: 0)
        
        struct SomeError: Error { }
        assertPublisher(pub, failsWithError: AddCityViewModel.Errors.geolocationFailed) {
            geocoder.subject.send(completion: .failure(SomeError()))
        }
    }
    
    func testGeocodingProducesNoResults() {
        viewModel.results = [LocalSearchCompletion(title: "Houston, TX", subTitle: "")]
        let pub = viewModel.geolocate(selectedIndex: 0)
            .assertNoFailure()
        
        assertPublisher(pub.count(), producesExactly: 0) {
            geocoder.subject.send([])
            geocoder.subject.send(completion: .finished)
        }
    }
}

class TestPlacemark: CLPlacemark {
    private var _name: String
    private var _locality: String
    
    init(coordinate: CLLocationCoordinate2D, name: String, locality: String) {
        let mkPlacemark = MKPlacemark(coordinate: coordinate)
        _name = name
        _locality = locality
        super.init(placemark: mkPlacemark as CLPlacemark)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var name: String? { _name }
    override var administrativeArea: String? { _locality }
}
