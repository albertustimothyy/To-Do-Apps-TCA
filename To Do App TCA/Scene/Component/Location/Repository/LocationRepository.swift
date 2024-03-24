//
//  LocationRepository.swift
//  To Do App TCA
//
//  Created by Albertus Timothy on 21/03/24.
//

import Foundation
import MapKit
import Dependencies

struct LocationRepository: DependencyKey {
    var fetchPlaces: (String) async throws -> [CLPlacemark]
    var updatePlacemark: (CLLocation) async throws -> CLPlacemark?
    
    static var liveValue: LocationRepository {
        return Self(
            fetchPlaces: { value in
                do {
                    let request = MKLocalSearch.Request()
                    request.naturalLanguageQuery = value.lowercased()
                    
                    let response = try await MKLocalSearch(request: request).start()
                    
                    return response.mapItems.compactMap({ item -> CLPlacemark? in
                        return item.placemark
                    })
                } catch {
                    throw error
                }
            },
            
            updatePlacemark: { value in
                do {
                     let place = try await CLGeocoder().reverseGeocodeLocation(value).first
                    
                    return place
                }
                catch {
                    throw error
                }
            }
        )
    }
}

extension DependencyValues {
    var locationRepository: LocationRepository {
        get { self[LocationRepository.self] }
        set { self[LocationRepository.self] = newValue }
    }
}
