//
//  CoreLocationGeocoder.swift
//  WeatherKit
//
//  Created by Yuriy Gudimov on 05.02.2023.
//

import Foundation
import CoreLocation
import Combine

public class CoreLocationGeocoder: Geocoder {
    private let geocoder = CLGeocoder()
    
    public init() {
        
    }
    
    public func geocodeAddress(address: String) -> AnyPublisher<[CLPlacemark], Error> {
        geocoder.cancelGeocode()
        return Future { promise in
            self.geocoder.geocodeAddressString(address) { (placemarks, error) in
                if let placemarks = placemarks {
                    promise(.success(placemarks))
                } else {
                    promise(.failure(error!))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
