//
//  TravelFormStore.swift
//  To Do App TCA
//
//  Created by Albertus Timothy on 19/03/24.
//

import Foundation
import ComposableArchitecture
import MapKit

@Reducer
struct TravelFormFeature {
    @ObservableState
    struct State: Equatable {
        var travelToDo: TravelToDo
        var mapView: MKMapView?
        @Presents var searchLocation: SearchLocationFeature.State?
    }
    
    enum Action {
        case openMapTapped
        case setStartDate(Date)
        case setEndDate(Date)
        case searchLocation(PresentationAction<SearchLocationFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .openMapTapped:
                state.searchLocation = SearchLocationFeature.State()
                return .none
                
            case var .setStartDate(startDate):
                if startDate > state.travelToDo.endDate {
                    state.travelToDo.endDate = startDate
                }
                if startDate > state.travelToDo.deadline {
                    startDate = state.travelToDo.deadline
                }
                state.travelToDo.startDate = startDate
                return .none
                
            case var .setEndDate(endDate):
                if endDate < state.travelToDo.startDate {
                    state.travelToDo.startDate = endDate
                }
                if endDate > state.travelToDo.deadline {
                    endDate = state.travelToDo.deadline
                }
                state.travelToDo.endDate = endDate
                return .none
                
                
            case let .searchLocation(.presented(.delegate(.saveLocation(destination)))):
                state.travelToDo.destination = TravelToDo.Coordinates(latitude: destination.latitude, longitude: destination.longitude)
                state.mapView = .init()
                let annotation = MKPointAnnotation()
                let coordinate = CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude)
                
                state.mapView?.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                
                annotation.coordinate = coordinate
                state.mapView?.addAnnotation(annotation)
                
                return .none
                
            case .searchLocation:
                return .none
            }
        }
        .ifLet(\.$searchLocation, action: \.searchLocation) {
            SearchLocationFeature()
        }
    }
}
