//
//  SearchLocationView.swift
//  To Do App TCA
//
//  Created by Albertus Timothy on 21/03/24.
//

import SwiftUI
import ComposableArchitecture
import MapKit

struct SearchLocationView: View {
    @Bindable var store: StoreOf<SearchLocationFeature>

    var body: some View {
        VStack {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray)
                
                TextField("Find Location", text: $store.searchText.sending(\.setSearchText))
            }
            .padding(.vertical, 14)
            .padding(.horizontal)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(.gray)
            }

            if let places = store.fetchedPlaces, !places.isEmpty {
                List {
                    ForEach(places, id: \.self) { place in
                        HStack(spacing: 15) {
                            Image(systemName: "map.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.gray)
                            
                            Button {
                                store.send(.locationSelected(place.location?.coordinate ?? CLLocationCoordinate2D()))
                            } label: {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(place.name ?? "")
                                        .font(.title3.bold())
                                        .foregroundStyle(.primary)
                                    
                                    Text(place.locality ?? "")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                }
                            }
                        }
                    }
                }
                .sheet(item: $store.scope(state: \.mapSheet, action: \.mapSheet)) { mapSheetStore in
                    MapSheetView(store: mapSheetStore)
                }
            }
        }

    }
}
    
    #Preview {
        return Group {
            NavigationStack {
                SearchLocationView(
                    store: Store(
                        initialState: SearchLocationFeature.State(
                            //                        locationHelper: LocationHelper.init()
                        )
                    ) {
                        SearchLocationFeature()
                    }
                    
                    
                )
            }
        }
    }
