//
//  AddCityViewModel.swift
//  WeatherApp
//
//  Created by Ben Scheirman on 9/18/20.
//

import UIKit
import Combine
import WeatherKit
import CoreLocation

class AddCityViewModel: NSObject {
    enum Errors: Error {
        case geolocationFailed
    }
    
    @Published
    var results: [LocalSearchCompletion] = []
    
    @Published
    var showSpinner: Bool = false
    
    private var localSearch: LocalSearchCompleter { Current.localSearch }
    private var geocoder = CLGeocoder()
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        
        localSearch.results
            .map { completions in
            completions
                .filter { $0.title.contains(",") }
        }
        .assign(to: &$results)
    }
    
    var searchTerm: String? {
        didSet {
            localSearch.search(with: searchTerm ?? "")
        }
    }
    
    var snapshotPublisher: AnyPublisher<NSDiffableDataSourceSnapshot<AddCityViewController.Section, LocalSearchCompletion>, Never> {
        $results
            .map { results in
                var snapshot = NSDiffableDataSourceSnapshot<AddCityViewController.Section, LocalSearchCompletion>()
                snapshot.appendSections([.results])
                snapshot.appendItems(results)
                return snapshot
            }
            .eraseToAnyPublisher()
    }
    
    func geolocate(selectedIndex index: Int) -> AnyPublisher<City, Error> {
        assert(index < results.count)
        let result = results[index]
        showSpinner = true
        geocoder.cancelGeocode()

        return Future { promise in
            self.geocoder.geocodeAddressString(result.title) { (placemarks, error) in
                assert(Thread.isMainThread)
                self.showSpinner = false
                if let placemark = placemarks?.first {
                    promise(.success(placemark))
                } else {
                    promise(.failure(Errors.geolocationFailed))
                }
            }
        }
        .map { (placemark: CLPlacemark) -> City in
            City(
                name: placemark.name ?? placemark.locality ?? "(unknown city)",
                locality: placemark.administrativeArea ?? placemark.country ?? "",
                latitude: placemark.location?.coordinate.latitude ?? 0,
                longitude: placemark.location?.coordinate.longitude ?? 0)
        }
        .eraseToAnyPublisher()
    }
}
