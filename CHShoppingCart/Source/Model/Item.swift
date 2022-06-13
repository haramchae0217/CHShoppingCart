//
//  ItemData.swift
//  CHShoppingCart
//
//  Created by Chae_Haram on 2022/06/05.
//

import Foundation

struct Item: Decodable {
    let title: String
    let lprice: String
    let maker: String
    let category1: String
}

struct ItemList: Decodable {
    let items: [Item]
}

struct MyDB {
    static var appendItem: [Item] = []
}
