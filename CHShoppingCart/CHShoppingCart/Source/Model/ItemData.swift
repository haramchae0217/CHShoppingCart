//
//  ItemData.swift
//  CHShoppingCart
//
//  Created by Chae_Haram on 2022/06/05.
//

import Foundation

struct ItemData {
    let itemName: String
    let itemPrice: Int
    let itemManufacture: String
    let itemType: String
    
    static let ItemList: [ItemData] = [
        ItemData(itemName: "비타오백", itemPrice: 900, itemManufacture: "광동", itemType: "음료"),
        ItemData(itemName: "펩시제로콜라", itemPrice: 1400, itemManufacture: "롯데칠성", itemType: "음료"),
        ItemData(itemName: "코카콜라", itemPrice: 1600, itemManufacture: "코카콜라", itemType: "음료"),
        ItemData(itemName: "소고기", itemPrice: 39900, itemManufacture: "고깃간", itemType: "육류"),
        ItemData(itemName: "돼지고기", itemPrice: 12900, itemManufacture: "고깃간", itemType: "육류")
    ]
    
    static var AppendItem: [ItemData] = []
}
