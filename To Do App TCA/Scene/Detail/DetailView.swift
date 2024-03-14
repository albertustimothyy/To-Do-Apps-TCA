//
//  DetailView.swift
//  To Do App TCA
//
//  Created by Albertus Timothy on 15/03/24.
//

import SwiftUI
import ComposableArchitecture

struct DetailView: View {
    @Bindable var store: StoreOf<DetailFeature>
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                DetailTitle(
                    name: store.toDo.base.name,
                    type: store.toDo.typee
                )
                Deadline(
                    deadline: store.toDo.base.deadline,
                    done: store.toDo.base.done
                )
                
                DescriptionLabel(store.toDo.base.description)
                
                switch store.toDo.typee {
                case .general:
                    EmptyView()
                case .shop:
                    if let shopToDo = store.toDo.base as? ShopToDo { ShopDetail(shopToDo: shopToDo) }
                case .travel:
                    if let travelToDo = store.toDo.base as? TravelToDo {
                        TravelDetail(travelToDo: travelToDo)
                    }
                case .work:
                    if let workToDo = store.toDo.base as? WorkToDo {WorkDetail(workToDo: workToDo)}
                }
            }
        }
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack{
                    Text("To Do's Details")
                        .font(.title3)
                        .bold()
                    Spacer()
                    Button {
                        store.send(.editButtonTapped)
                    } label: {
                        Image(systemName: "square.and.pencil")       .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .font(Font.title.weight(.heavy))
                    }
                }
            }
        }
        .sheet(item: $store.scope(state: \.editToDo, action: \.editToDo)) { editToDoStore in
            NavigationStack {
                AddFormView(store: editToDoStore)
            }
           
        }
    }
    
    @ViewBuilder
    func DetailTitle(name: String, type: ToDoType) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.title)
                    .fontWeight(.bold)
                Text(type.rawValue.capitalized)
                    .foregroundStyle(.gray)
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    func Deadline(deadline: Date, done: Bool) -> some View {
        
        HStack {
            Spacer()
            Image(systemName: "calendar.circle.fill")
                .resizable()
                .foregroundStyle(.blue)
                .scaledToFit()
                .frame(width: 55, height: 55)
            VStack(alignment:.leading) {
                Text("Due date")
                    .foregroundStyle(.gray)
                
                Text(deadline.formatted(.dateTime.day().month().year()))
                    .bold()
            }
            Spacer()
            
            Divider()
                .frame(width: 1)
                .overlay(.gray)
            
            Spacer()
            Text(done ? "Done" : "In Progress")
                .foregroundStyle(.white)
                .padding(.horizontal)
                .padding(.vertical, 15)
                .background(done ? .green : .orange)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            Spacer()
            
        }
    }
    
    @ViewBuilder
    func DescriptionLabel(_ desc: String) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Description ")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(desc)
                    .foregroundStyle(.gray)
            }
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(
            store: Store(
                initialState: DetailFeature.State(
                    toDo:
                        AnyToDo(
                            TravelToDo(
                                name: "dsdsadsad",
                                description: "dsadsadasdasdasda",
                                done: false,
                                deadline: Date(timeIntervalSinceNow: 172800),
                                destination: TravelToDo.Coordinates(latitude: 0, longitude: 0),
                                startDate: Date(),
                                endDate: Date(timeIntervalSinceNow: 86400)
                            ),                            .travel
                        )
                    
                )
            ) {
                DetailFeature()
            }
        )
    }
}
