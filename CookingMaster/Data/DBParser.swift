//
//  DBParser.swift
//  CookingMaster
//
//  Created by Victor on 2/20/21.
//

import Foundation

class DBParser {
    
    func getCSVData() {
        guard let pathString = Bundle.main.path(forResource: "IngredientsDB", ofType: "csv") else { return }
        do {
            let content = try String(contentsOfFile: pathString)
            let parsedCSV = content
                .split(separator: "\r\n")
                .map{ $0.components(separatedBy: ",") }
                .map { (line) -> Ingredients in
                    var itemsInCategory = [ItemInCategory]()
                    for i in 1..<line.count{
                        itemsInCategory.append(ItemInCategory(item: line[i]))
                    }
                    return Ingredients(category: line[0], itemsInCategory: itemsInCategory)
                }
            IngredientsData.data.ingredients = parsedCSV
            print(parsedCSV)
        }
        catch {
            print("Parsing Error!")
        }
    }
}
