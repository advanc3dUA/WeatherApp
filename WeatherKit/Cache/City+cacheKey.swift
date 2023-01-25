//
//  City+cacheKey.swift
//  WeatherKit
//
//  Created by Yuriy Gudimov on 25.01.2023.
//

import Foundation

public extension City {
    var cacheKey: String {
        String(format: "lat:%.2f|lon:%.2f", latitude, longitude)
    }
}
