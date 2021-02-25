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
    var vegetarian: Bool
    var vegan: Bool
    var glutenFree: Bool
    var dairyFree: Bool
    var veryHealthy: Bool
    var cheap: Bool
    var veryPopular: Bool
    var sustainable: Bool
}

extension RecipeDescription {
    func getPositiveTags() -> [String] {
        var tags = [String]()
        if vegetarian == true { tags.append("Vegetarian") }
        if vegan == true { tags.append("Vegan") }
        if glutenFree == true { tags.append("Gluten free") }
        if dairyFree == true { tags.append("Dairy free") }
        if veryHealthy == true { tags.append("Very healthy") }
        if cheap == true { tags.append("Cheap") }
        if veryPopular == true { tags.append("Very Popular") }
        if sustainable == true { tags.append("Sustainable") }
        
        return tags
    }
}
