//
//  APIStructures.swift
//  CookingMaster
//
//  Created by Victor on 1/21/21.
//

import Foundation
import UIKit

struct RecipeByIngredients: Codable {
    var id: Int
    var title: String
    var image: String
    var usedIngredientCount: Int
    var missedIngredientCount: Int
}

struct FoodInText: Codable {
    var annotations: [FoodAnnotation]
}

struct FoodAnnotation: Codable {
    var annotation: String
    var tag: String
}

struct RecipeDescription: Codable {
    var id: Int
    var title: String
    var readyInMinutes: Int
    var image: String
    var instructions: String?
    var sourceUrl: String
}
