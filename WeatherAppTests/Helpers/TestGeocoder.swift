//
//  TestGeocoder.swift
//  WeatherAppTests
//
//  Created by Yuriy Gudimov on 05.02.2023.
//

import Foundation
import CoreLocation
import Combine
import WeatherKit

class TestGeocoder: Geocoder {
    var subject = PassthroughSubject<[CLPlacemark], Error>()
    func geocodeAddress(address: String) -> AnyPublisher<[CLPlacemark], Error> {
        return subject.eraseToAnyPublisher()
    }
}
