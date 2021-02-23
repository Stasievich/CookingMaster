//
//  FoodAPI.swift
//  CookingMaster
//
//  Created by Victor on 1/21/21.
//

import Foundation

class FoodAPI {
    
    static let shared = FoodAPI()
    
    func getRecipesByIngredient(ingredients: [String], completion: @escaping (Data?, Error?) -> Void) {
        let headers = [
            "x-rapidapi-key": "ab94af265fmsh9ad57a776c71a9dp1c97a8jsn2625aa125597",
            "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
        ]
        var components = URLComponents()
        components.scheme = "https"
        components.host = "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
        components.path = "/recipes/findByIngredients"
        
        components.queryItems = [
            URLQueryItem(name: "ingredients", value: ingredients.joined(separator: ",")),
            URLQueryItem(name: "number", value: "5"),
            URLQueryItem(name: "ranking", value: "1"),
            URLQueryItem(name: "ignorePantry", value: "true")
        ]
        
        var request = URLRequest(url: components.url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                completion(data, error)
            }
        }

        dataTask.resume()
    }
    
    func getIngredientsFromString(stringToRecognize: String, completion: @escaping (Data?, Error?) -> Void) {
        let headers = [
            "content-type": "application/x-www-form-urlencoded",
            "x-rapidapi-key": "ab94af265fmsh9ad57a776c71a9dp1c97a8jsn2625aa125597",
            "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
        ]
        var customStringToRecognize = "text="
        customStringToRecognize.append(stringToRecognize)
        let postData = NSMutableData(data: customStringToRecognize.data(using: String.Encoding.utf8)!)
//        let postData = Data(base64Encoded: stringToRecognize.data(using: .utf8)!)

        var components = URLComponents()
        components.scheme = "https"
        components.host = "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
        components.path = "/food/detect"
        var request = URLRequest(url: components.url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                completion(data, error)
            }
        })

        dataTask.resume()
    }
    
    
    func getRecipeInformation(recipeId: Int, completion: @escaping (Data?, Error?) -> Void) {
        let headers = [
            "x-rapidapi-key": "ab94af265fmsh9ad57a776c71a9dp1c97a8jsn2625aa125597",
            "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
        ]
        var components = URLComponents()
        components.scheme = "https"
        components.host = "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
        components.path = "/recipes/\(recipeId)/information"
        
        var request = URLRequest(url: components.url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                completion(data, error)
            }
        }

        dataTask.resume()
    }
    
}
