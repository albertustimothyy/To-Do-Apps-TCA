//
//  ShopItemView.swift
//  To Do App TCA
//
//  Created by Albertus Timothy on 17/03/24.
//
import PhotosUI
import SwiftUI
import ComposableArchitecture

struct ShopItemView: View {
    @Bindable var store: StoreOf<ShopItemFeature>
    @State var photosPickerItem: PhotosPickerItem?
    var body: some View {
        HStack {
            HStack {
                PhotosPicker(selection: $photosPickerItem) {
                    ZStack {
                        Rectangle()
                            .fill(.gray)
                        
                        Text("Select Image")
                            .foregroundStyle(.white)
                            .bold()
                        
                        store.image?
                            .resizable()
                            .scaledToFit()
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(width: 80, height: 80)
                .onChange(of: photosPickerItem) {
                    Task {
                        if let photosPickerItem {
                            let data = try await photosPickerItem.loadTransferable(type: Data.self)
                            if let image = UIImage(data: data!) {
                                store.send(.setImage(image))
                            }
                        }
                        photosPickerItem = nil
                    }
                }
            }
            .onAppear() {
                store.send(.decodeImage)
            }
            .onChange(of: store.inputImage) {
                store.send(.loadImage)
                store.send(.encodeImage)
            }
            
            VStack(alignment: .leading) {
                TextField("Enter Name", text: $store.item.productName.sending(\.setName))
                HStack {
                    Text("Rp. ")
                    TextField(
                        "Enter Budget",
                        value: $store.item.budget.sending(\.setBudget),
                        format: .number
                    )
                    .keyboardType(.numberPad)
                }
            }
            
            HStack(alignment: .center) {
                Button {
                    store.send(.deleteButtonTapped)
                } label: {
                    Image(systemName: "trash.fill")
                        .imageScale(.large)
                }
                .foregroundStyle(.red)
                .buttonStyle(PlainButtonStyle())
                
            }
        }
        
    }
    
}

//#Preview {
//    ShopItemView()
//}
