//
//  CurrentUserViewController.swift
//  CookingMaster
//
//  Created by Victor on 2/23/21.
//

import Foundation
import UIKit
import Firebase

class CurrentUserViewController: UIViewController {
    var productLabel = UILabel()
    var emailTextField = TextField()
    var appTitleLabel = UILabel()
    
    var signOutButton = UIButton(type: .system)
    var changePasswordButton = UIButton(type: .system)
    
    override func viewDidLoad () {
        super.viewDidLoad()
        view.backgroundColor = UIColor(cgColor: CGColor(gray: 0.7, alpha: 1))
        self.addBackButton()
        
        if let userEmail = Auth.auth().currentUser?.email {
            emailTextField.text = "\(userEmail)"
        }
        emailTextField.textAlignment = .center
        emailTextField.isUserInteractionEnabled = false
        emailTextField.backgroundColor = .white
        
        view.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        emailTextField.layer.borderColor = CGColor(gray: 0.5, alpha: 1)
        emailTextField.layer.borderWidth = 0.5
        emailTextField.layer.cornerRadius = 8
        emailTextField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        emailTextField.autocorrectionType = .no
        
        view.addSubview(appTitleLabel)
        let str = "CookingMaster"
        let titleString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font: UIFont(name: "GillSans-Bold", size: 26)!])
        titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.8284265995, green: 0.2433997393, blue: 0.5355008841, alpha: 1), range: NSRange(location:0,length:7))
        titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.Theme.mainColor, range: NSRange(location:7,length:str.count - 7))
        appTitleLabel.attributedText = titleString
        appTitleLabel.textAlignment = .center
        appTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            appTitleLabel.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
            appTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appTitleLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -20)
        ])
        
        signOutButton.setTitle("Sign out", for: .normal)
        view.addSubview(signOutButton)
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signOutButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            signOutButton.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
            signOutButton.heightAnchor.constraint(equalTo: emailTextField.heightAnchor)
        ])
        signOutButton.backgroundColor = UIColor.Theme.buttonColor
        signOutButton.setTitleColor(.white, for: .normal)
        
        signOutButton.addAction(for: .touchUpInside) { (signOutButton) in
            
            do {
                try Auth.auth().signOut()
                FavouriteRecipes.shared.recipes.removeAll()
                SharedRecipes.sharedInstance.recipes.removeAll()
                let ingredientsTab = IngredientsViewController()
                ingredientsTab.tabBarItem.title = "Ingredients"
                ingredientsTab.tabBarItem.image = UIImage(named: "fridge")
                
                let recipesTab = RecipesViewController()
                recipesTab.tabBarItem.title = "Recipes"
                recipesTab.tabBarItem.image = UIImage(named: "recipe-book")
                
                let favoritesTab = FavoritesViewController()
                favoritesTab.tabBarItem.title = "Favorites"
                favoritesTab.tabBarItem.image = UIImage(named: "favorite")
                
                let tabBarVC = self.navigationController?.viewControllers.first as! UITabBarController
                tabBarVC.viewControllers = [ingredientsTab, recipesTab, favoritesTab]
                tabBarVC.selectedIndex = 0
                
                self.navigationController?.popToRootViewController(animated: true)
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
        
        
        changePasswordButton.setTitle("Change password", for: .normal)
        view.addSubview(changePasswordButton)
        changePasswordButton.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            changePasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changePasswordButton.topAnchor.constraint(equalTo: signOutButton.bottomAnchor),
            changePasswordButton.widthAnchor.constraint(equalTo: signOutButton.widthAnchor),
            changePasswordButton.heightAnchor.constraint(equalTo: signOutButton.heightAnchor)
        ])
        changePasswordButton.backgroundColor = .none
        changePasswordButton.setTitleColor(.gray, for: .normal)
        
        changePasswordButton.addAction(for: .touchUpInside) { (signOutButton) in
            
            if let userEmail = Auth.auth().currentUser?.email {
                Auth.auth().sendPasswordReset(withEmail: userEmail) { error in
                    let alert = UIAlertController(title: "CookingMaster", message: "Please check your inbox for a password reset email.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
                
                
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = .lightGray
    }
}
