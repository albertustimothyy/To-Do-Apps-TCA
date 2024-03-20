//
//  ShopDetail.swift
//  To Do App TCA
//
//  Created by Albertus Timothy on 18/03/24.
//

import SwiftUI

struct ShopDetail: View {
    var shopToDo: ShopToDo
    @State var image: Image?
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            Text("Shop's Details")
                .font(.title2)
                .fontWeight(.semibold)
            
            ForEach(shopToDo.shoppingList) { item in
                ShopDetailRow(item: item)
            }
        }
    }
}


struct ShopDetailRow: View {
    var item: ShoppingItem
    let numberFormatter: NumberFormatter = {
           let formatter = NumberFormatter()
           formatter.numberStyle = .currency
           formatter.currencySymbol = "Rp. "
           formatter.locale = Locale(identifier: "id_ID")
           return formatter
       }()
    
    var body: some View {
        HStack {
            ZStack {
                Rectangle()
                    .fill(.secondary)
                
                ImageHelper().decodeImage(photo: item.photo)?
                    .resizable()
                    .scaledToFit()
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .frame(width: 70, height: 70)
            
            Spacer()
            
            VStack (alignment: .trailing) {
                Text(item.productName).bold()
                Text(numberFormatter.string(from: NSNumber(value: item.budget)) ?? "")
            }
        }
        .padding(15)
        .background(Color(.systemGray6))
    }
}

#Preview {
    ShopDetail(
        shopToDo: ShopToDo(
            name: "Hedon",
            description: "Mau beli ini itu semoga bisa kebeli semua",
            done: true,
            deadline: Date(),
            shoppingList: [
            ShoppingItem(productName: "Barang 1", photo: "", budget: 10000),
            ShoppingItem(productName: "Barang 2", photo: "", budget: 20000)
            ]
        )
    )
}
