//
//  SearchLocationStore.swift
//  To Do App TCA
//
//  Created by Albertus Timothy on 21/03/24.
//

import Foundation
import ComposableArchitecture
import MapKit
import CoreLocation
import Combine

class DebouncedState<Value: Equatable>: ObservableObject, Equatable {
    static func == (lhs: DebouncedState<Value>, rhs: DebouncedState<Value>) -> Bool {
        return lhs.currentValue == rhs.currentValue && lhs.debouncedValue == rhs.debouncedValue
    }
    
    @Published var currentValue: Value
    @Published var debouncedValue: Value
    
    private var cancellable: AnyCancellable?
    
    init(initialValue: Value, delay: Double = 0.3) {
        self.currentValue = initialValue
        self.debouncedValue = initialValue
        self.cancellable = $currentValue
            .debounce(for: .seconds(delay), scheduler: RunLoop.main)
            .sink { [weak self] value in
                self?.debouncedValue = value
            }
    }
}

@Reducer
struct SearchLocationFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var mapSheet: MapsheetFeature.State?
        var mapView: MKMapView = .init()
        var manager: CLLocationManager = .init()
        var searchText = ""
        var cancellable: AnyCancellable?
        var fetchedPlaces: [CLPlacemark]?
        var userLocation: CLLocation?
        var pickedLocation: CLLocation?
        var pickedPlaceMark: CLPlacemark?
    }
    
    @Dependency(\.locationRepository) var locationRepository
    @Dependency(\.mainQueue) var mainQueue
    
    enum Action {
        case mapSheet(PresentationAction<MapsheetFeature.Action>)
        case setSearchText(String)
        case setFetchesPlaces([CLPlacemark]?)
        case locationSelected(CLLocationCoordinate2D)
        case setPickedPlacemark(CLPlacemark?)
        case setMapSheet
        case delegate(Delegate)
        enum Delegate {
            case saveLocation(CLLocationCoordinate2D)
        }
    }
    
    enum CancelID{
        case fetch
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .locationSelected(coordinate):
                let annotation = MKPointAnnotation()
                                
                state.pickedLocation = .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
                
                state.mapView.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                
                annotation.coordinate = coordinate
                annotation.title = "Choose Location"
                state.mapView.addAnnotation(annotation)
                
                return .run { send in
                    do {
                        try await send(
                            .setPickedPlacemark(
                                CLGeocoder().reverseGeocodeLocation(
                                    .init(
                                        latitude: coordinate.latitude,
                                        longitude: coordinate.longitude
                                    )
                                ).first
                            )
                        )
                        await send(.setMapSheet)
                    } catch {
                        throw error
                    }
                }
                
            case .setMapSheet:
                state.mapSheet = MapsheetFeature.State(
                    mapView: state.mapView,
                    pickedPlaceMark: state.pickedPlaceMark,
                    pickedLocation: state.pickedLocation
                )
                return .none
                
            case let .setSearchText(searchText):
                state.searchText = searchText
                return .run { send in
                    do {
                        try await mainQueue.sleep(for: 0.5)
                        try await send(.setFetchesPlaces(locationRepository.fetchPlaces(searchText)))
                    } catch {
                        await send(.setFetchesPlaces([]))
                    }
                }
                .cancellable(id: CancelID.fetch, cancelInFlight: true)
                
            case let .setPickedPlacemark(pickedPlacemark):
                state.pickedPlaceMark = pickedPlacemark
                return .none
                
            case let .setFetchesPlaces(fetchesPlaces):
                state.fetchedPlaces = fetchesPlaces
                return .none
                
                
            case let .mapSheet(.presented(.delegate(.saveLocation(destination)))):
                state.mapSheet = nil
                state.mapView.removeAnnotations(state.mapView.annotations)
                state.cancellable = nil
                state.fetchedPlaces = nil
                state.userLocation = nil
                state.pickedLocation = nil
                state.pickedPlaceMark = nil
                return .run{ send in
                    await send(.delegate(.saveLocation(destination)))
                    await dismiss()
                }
                
            case .mapSheet:
                return .none
                
            case .delegate:
                return .none
            }
        }
        .ifLet(\.$mapSheet, action: \.mapSheet) {
            MapsheetFeature()
        }
    }
    
}

