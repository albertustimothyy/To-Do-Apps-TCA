//
//  MapSheetStore.swift
//  To Do App TCA
//
//  Created by Albertus Timothy on 21/03/24.
//

import Foundation
import ComposableArchitecture
import MapKit

extension CLLocationCoordinate2D: Equatable {
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

@Reducer
struct MapsheetFeature {
    @ObservableState
    struct State: Equatable {
        var mapView: MKMapView
        var pickedPlaceMark: CLPlacemark?
        var pickedLocation: CLLocation?
        var inputDestination: CLLocationCoordinate2D?
    }
    @Dependency(\.dismiss) var dismiss
    enum Action {
        case backButtonTapped
        case saveDestination
        case delegate(Delegate)
        enum Delegate {
            case saveLocation(CLLocationCoordinate2D)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                state.pickedPlaceMark = nil
                state.pickedLocation = nil
                state.inputDestination = nil
                state.mapView.removeAnnotations(state.mapView.annotations)
                return .run { _ in
                    await self.dismiss()
                }
                
            case .saveDestination:
                let coordinate = state.pickedLocation?.coordinate
                state.pickedPlaceMark = nil
                state.inputDestination = nil
                state.pickedLocation = nil
                state.mapView.removeAnnotations(state.mapView.annotations)
                return .send(.delegate(.saveLocation(coordinate ?? CLLocationCoordinate2D())))
                
            case .delegate:
                return .none
            }
        }
    }
}
