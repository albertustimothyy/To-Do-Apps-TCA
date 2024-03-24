//
//  MapSheetView.swift
//  To Do App TCA
//
//  Created by Albertus Timothy on 21/03/24.
//

import SwiftUI
import MapKit
import ComposableArchitecture

struct MapSheetView: View {
    @Bindable var store: StoreOf<MapsheetFeature>
    
    var body: some View {
        ZStack {
            MapViewHelper(mapView: store.mapView)
            if let place = store.pickedPlaceMark {
                VStack {
                    Text("Confirm Location")
                        .font(.title2.bold())
                        .padding(.bottom, 12)
                    
                    HStack (spacing: 15) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.gray)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text(place.name ?? "")
                                .font(.title3.bold())
                            
                            Text(place.locality ?? "")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                    }
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button {
                        store.send(.saveDestination)
                    } label: {
                        Text("Confirm Location")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.green)
                            }
                            .overlay(alignment: .trailing) {
                                Image(systemName: "arrow.right")
                                    .font(.title3.bold())
                                    .padding(.trailing)
                            }
                            .foregroundStyle(.white)
                    }
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white)
                }
                .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .bottom)
            } else{
                Text(store.pickedPlaceMark?.name ?? "")
            }
        }
        .overlay {
            VStack {
                HStack {
                    Button {
                        store.send(.backButtonTapped)
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.title2)
                            .fontWeight(.medium)
                        Text("Back")
                            .font(.title2.bold())
                    }.tint(.blue)
                    Spacer()
                }
                Spacer()
            }.padding()
        }
        
    }
}

struct MapViewHelper: UIViewRepresentable {
    var mapView: MKMapView
    
    func makeUIView(context: Context) -> MKMapView {
        return mapView
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

//#Preview {
//    MapSheetView(store: Store(initialState: MapsheetFeature.State()) {
//        MapsheetFeature()
//    })
//}
//
//
