//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Yuriy Gudimov on 25.01.2023.
//

import Foundation
import WeatherKit
import Combine

class WeatherManager {
    private let cache: TimedCache<OneCallResult?> = TimedCache()
    private var cancellables: Set<AnyCancellable> = []
    private var subjects: [City: CurrentValueSubject<OneCallResult?, Never>] = [:]
    
    func weatherPublisher(for city: City) -> AnyPublisher<OneCallResult?, Never> {
        if let subject = subjects[city] {
            return subject.eraseToAnyPublisher()
        }
        let subject = CurrentValueSubject<OneCallResult?, Never>(nil)
        subjects[city] = subject
        fetchWeather(for: city, subject: subject)
        return subject.eraseToAnyPublisher()
        
    }
    
    private func fetchWeather(for city: City, subject: CurrentValueSubject<OneCallResult?, Never>) {
        if let cached = cache.get(cacheKey: city.cacheKey) {
            print("Returning cached value for \(city.name)...")
            subject.send(cached)
        } else {
            Current.weatherAPI.oneCallForecast(lat: city.latitude, long: city.longitude)
                .handleEvents(receiveSubscription: { _ in
                    print("Fetching weather for \(city.name)...")
                })
                .map { $0 as OneCallResult? }
                .catch { error -> Just<OneCallResult?> in
                    print("error fetching weather for city: \(city.name) --> \(error)")
                    return Just(nil)
                }
                .sink { [unowned self] weather in
                    if let weather = weather {
                        cache.set(cacheKey: city.cacheKey, model: weather, expires: Date().addingTimeInterval(60 * 60))
                    }
                    subject.send(weather)
                }
                .store(in: &cancellables)
        }
    }
}
