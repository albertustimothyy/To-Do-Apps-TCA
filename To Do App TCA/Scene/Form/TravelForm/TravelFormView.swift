//
//  TravelFormView.swift
//  To Do App TCA
//
//  Created by Albertus Timothy on 19/03/24.
//

import SwiftUI
import ComposableArchitecture

struct TravelFormView: View {
    @Bindable var store: StoreOf<TravelFormFeature>
    var body: some View {
        Section(header: Text("Travel To do")) {
            VStack(spacing: 15) {
                HStack {
                    Button {
                        store.send(.openMapTapped)
                    } label: {
                        Text("Search location")
                    }
                    Spacer()
                }
                
                ZStack {
                    Rectangle()
                        .fill(.secondary)
                    
                    if let mapView = store.mapView {
                        MapViewHelper(mapView: mapView)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(width: 300, height: 180)
            }
            
            HStack {
                Spacer()
                
                DatePicker(
                    selection: $store.travelToDo.startDate.sending(\.setStartDate),
                    in: Date.now...,
                    displayedComponents: .date,
                    label: { Text("Start Date") }
                )
                .labelsHidden()
                
                Text("-")
                    .font(.title3)
                
                DatePicker(
                    selection: $store.travelToDo.endDate.sending(\.setEndDate),
                    in: Date()...,
                    displayedComponents: .date,
                    label: { Text("End Date") }
                )
                .labelsHidden()
                
                Spacer()
            }
        }
        .sheet(item: $store.scope(state: \.searchLocation, action: \.searchLocation)) { searchLocationStore in
            NavigationStack {
                SearchLocationView(store: searchLocationStore)
            }
        }
    }
}

#Preview {
    TravelFormView(
        store: Store(
            initialState: TravelFormFeature.State(
                travelToDo: TravelToDo(
                    name: "",
                    description: "",
                    done: false,
                    deadline: Date(timeIntervalSinceNow: 172800),
                    destination: TravelToDo.Coordinates(latitude: 0, longitude: 0),
                    startDate: Date(),
                    endDate: Date(timeIntervalSinceNow: 86400)
                )
            )
        ) {
            TravelFormFeature()
        }
    )
}
