//
//  Geocoder.swift
//  WeatherKit
//
//  Created by Yuriy Gudimov on 05.02.2023.
//

import Foundation
import CoreLocation
import Combine

public protocol Geocoder {
    func geocodeAddress(address: String) -> AnyPublisher<[CLPlacemark], Error>
}
