//
//  World.swift
//  WeatherApp
//
//  Created by Ben Scheirman on 9/18/20.
//

import Foundation
import WeatherKit
import MapKit

struct World {
    var weatherAPI: OpenWeatherMapAPIClient
    var citiesStore: CitiesStore
    var weatherManager: WeatherManager
    var localSearch: LocalSearchCompleter
}

var Current = World(
    weatherAPI: OpenWeatherMapAPIClient(),
    citiesStore: CitiesStore.load(),
    weatherManager: WeatherManager(),
    localSearch: MapKitLocalSearchCompleter()
)
