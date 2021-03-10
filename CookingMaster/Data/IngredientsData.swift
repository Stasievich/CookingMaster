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
    var ingredients = [Ingredients]()
}

enum ListItem: Hashable {
    case header(Ingredients)
    case item(ItemInCategory)
}
