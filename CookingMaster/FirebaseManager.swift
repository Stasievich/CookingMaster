//
//  FirebaseManager.swift
//  CookingMaster
//
//  Created by Victor on 2/14/21.
//

import Foundation
import Firebase

class FirebaseManager {
    
    static let shared = FirebaseManager()
    private init() {}
    
    let db = Firestore.firestore()
    lazy var userCollection = db.collection(FirestoreCollections.users.rawValue)
    
    enum FirestoreCollections: String {
        case users
        
        enum UserFields: String {
            case name
        }
        enum RecipesFields: String {
            case id
            case title
            case image
        }
    }
    
    func saveRecipe(recipe: RecipeByIngredients) {
        
        if let uid = Auth.auth().currentUser?.uid {
            let document = userCollection.document(uid)
            document.collection("recipes").document("\(recipe.id)").setData([
                FirestoreCollections.RecipesFields.id.rawValue : recipe.id,
                FirestoreCollections.RecipesFields.title.rawValue: recipe.title,
                FirestoreCollections.RecipesFields.image.rawValue: recipe.image
            ])
        } else {
            
        }
        
    }
    
    func saveNewUser(id: String, name: String) {
        let document = userCollection.document(id)
        document.setData([
            FirestoreCollections.UserFields.name.rawValue : name
        ])
    }
    
    func getUserData(uid: String, completion: @escaping  (([[String: Any]]) -> Void)) {
        var documents = [[String: Any]]()
        let dg = DispatchGroup()
        dg.enter()
        userCollection.document(uid).collection("recipes").getDocuments { (query, error) in
            if let docs = query?.documents {
                documents = docs.map{ $0.data() }
                dg.leave()
            }
        }
        
        dg.notify(queue: .main) {
            completion(documents)
        }
        
        dg.resume()
    }
    
    func remove (id: String) {
        if let uid = Auth.auth().currentUser?.uid {
            let document = userCollection.document(uid)
            document.collection("recipes").document("\(id)").delete()
        } else {
            
        }
    }
    
}
