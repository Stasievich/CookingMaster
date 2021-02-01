//
//  IngredientsData.swift
//  CookingMaster
//
//  Created by Victor on 1/31/21.
//

import UIKit

struct Ingredients: Hashable {
    let category: String
    let itemsInCategory: [ItemInCategory]
}

struct ItemInCategory: Hashable {
    let item: String
}

class IngredientsData {
    static let data = IngredientsData()
    let ingredients : [Ingredients] = [
        Ingredients(category: "Dairy", itemsInCategory: [ItemInCategory(item: "milk"), ItemInCategory(item: "eggs")]),
        Ingredients(category: "Meat", itemsInCategory: [ItemInCategory(item: "pork"), ItemInCategory(item: "beef")])
    ]
}

enum ListItem: Hashable {
    case header(Ingredients)
    case item(ItemInCategory)
}
