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
    
    var signOutButton = UIButton(type: .system)
    var changePasswordButton = UIButton(type: .system)
    
    override func viewDidLoad () {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
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
        
        
        
        signOutButton.setTitle("Sign out", for: .normal)
        view.addSubview(signOutButton)
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signOutButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            signOutButton.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
            signOutButton.heightAnchor.constraint(equalTo: emailTextField.heightAnchor)
        ])
        signOutButton.backgroundColor = .green
        signOutButton.setTitleColor(.white, for: .normal)
        
        signOutButton.addAction(for: .touchUpInside) { (signOutButton) in
            
            do {
                try Auth.auth().signOut()
                FavouriteRecipes.shared.recipes.removeAll()
                let favoritesTab = FavoritesViewController()
                favoritesTab.navigationController?.isNavigationBarHidden = true
                favoritesTab.tabBarItem.title = "Favorites111"
                favoritesTab.tabBarItem.image = UIImage(named: "favorite")
//                let tab = UIApplication.shared.windows.first?.rootViewController?.children.first
//                tab?.addChild(favoritesTab)
//                self.navigationController?.viewControllers.first?.children
                self.navigationController?.viewControllers.first?.children[2].removeFromParent()
                self.navigationController?.viewControllers.first?.addChild(favoritesTab)
                
//                self.navigationController?.topViewController?.tabBarController?.viewControllers?.remove(at: 2)
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
                    let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                                    switch action.style{
                                                    case .default:
                                                        print("default")
                                                        
                                                    case .cancel:
                                                        print("cancel")
                                                        
                                                    case .destructive:
                                                        print("destructive")
                                                        
                                                    @unknown default:
                                                        print("unknown default")
                                                    }}))
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
