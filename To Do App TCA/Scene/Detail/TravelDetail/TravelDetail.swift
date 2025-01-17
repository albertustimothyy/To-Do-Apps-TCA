//
//  TravelDetail.swift
//  To Do App TCA
//
//  Created by Albertus Timothy on 19/03/24.
//

import SwiftUI
import MapKit
struct TravelDetail: View {
    var travelToDo: TravelToDo
    var mapView: MKMapView = .init()

    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Travel's Details")
                .font(.title2)
                .fontWeight(.semibold)
            
            ZStack {
                Rectangle()
                    .fill(.secondary)
                
                MapViewHelper(mapView: mapView)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .frame(width: 300, height: 180)
            .onAppear {
                let annotation = MKPointAnnotation()
                let coordinate = CLLocationCoordinate2D(latitude: travelToDo.destination.latitude, longitude: travelToDo.destination.longitude)
                
                mapView.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                
                annotation.coordinate = coordinate
                mapView.addAnnotation(annotation)
            }
            
            HStack {
                Image(systemName: "timer.circle.fill")
                    .resizable()
                    .foregroundStyle(.blue)
                    .scaledToFit()
                    .frame(width: 55, height: 55)
                
                VStack(alignment: .leading) {
                    Text("Travel's Date:")
                        .font(.headline)
                    
                    Text("\(travelToDo.startDate.formatted(.dateTime.weekday().day().month().year())) - \(travelToDo.endDate.formatted(.dateTime.weekday().day().month().year()))")
                        .font(.callout)
                }
            }
        }
    }
}

#Preview {
    TravelDetail(
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
}
