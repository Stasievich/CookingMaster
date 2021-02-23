//
//  FavoritesViewController.swift
//  CookingMaster
//
//  Created by Victor on 1/24/21.
//

import UIKit
import Firebase

class FavoritesViewController: UIViewController {
    var headerText = UILabel()
    var recipesContainer = UIView()
    var promptForSignUpLabel = UILabel()
    var signUpButton = UIButton(type: .system)
    var signOutButton = UIButton(type: .system)
    
    var recipesTableView = UITableView.init(frame: .zero, style: .grouped)
    let cellReuseIdentifier = "favRecipe"
    let indent: CGFloat = 12
    let cellHeight: CGFloat = 140
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .red
        
        headerText.text = "Favourites"
        headerText.font = UIFont(name: "Helvetica", size: 30)
        headerText.textColor = .white
        headerText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerText)
        view.addConstraints([
            headerText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            headerText.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.setTitle("Sign Out", for: .normal)
        view.addSubview(signOutButton)
        view.addConstraints([
            signOutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            signOutButton.centerYAnchor.constraint(equalTo: headerText.centerYAnchor)
        ])
        
        signOutButton.addAction(for: .touchUpInside) { (signOutButton) in
            do {
                try Auth.auth().signOut()
            } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
            }
            print(self.tabBarController?.selectedIndex)
            let favoritesTab = FavoritesViewController()
            favoritesTab.tabBarItem.title = "Favorites"
            favoritesTab.tabBarItem.image = UIImage(named: "favorite")
            self.tabBarController?.viewControllers?.append(favoritesTab)
            self.tabBarController?.viewControllers?.remove(at: 2)
        }
        
        view.addSubview(recipesContainer)
        recipesContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            recipesContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            recipesContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            recipesContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recipesContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        recipesContainer.backgroundColor = .white
        recipesContainer.layer.cornerRadius = 10
        recipesContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        
        if Auth.auth().currentUser == nil {
            
            promptForSignUpLabel.translatesAutoresizingMaskIntoConstraints = false
            promptForSignUpLabel.text = "Only registered users can save recipes"
            promptForSignUpLabel.font = UIFont(name: "Helvetica", size: 14)
            promptForSignUpLabel.numberOfLines = 2
            promptForSignUpLabel.textAlignment = .center
            recipesContainer.addSubview(promptForSignUpLabel)
            recipesContainer.addConstraints([
                promptForSignUpLabel.topAnchor.constraint(equalTo: recipesContainer.topAnchor, constant: 60),
                promptForSignUpLabel.centerXAnchor.constraint(equalTo: recipesContainer.centerXAnchor),
                promptForSignUpLabel.widthAnchor.constraint(equalToConstant: 140.0)
            ])
            
            signUpButton.translatesAutoresizingMaskIntoConstraints = false
            signUpButton.setTitle("Sign Up", for: .normal)
            recipesContainer.addSubview(signUpButton)
            recipesContainer.addConstraints([
                signUpButton.centerXAnchor.constraint(equalTo: recipesContainer.centerXAnchor),
                signUpButton.topAnchor.constraint(equalTo: promptForSignUpLabel.bottomAnchor, constant: 20)
            ])
            
            signUpButton.addAction(for: .touchUpInside) { (signUpButton) in
                let signUpVC = SignUpViewController()
                self.navigationController?.pushViewController(signUpVC, animated: true)
            }
            
            
        }
        else {
            print(Auth.auth().currentUser?.email)
            
            DispatchQueue.main.async {
                
                if let uid = Auth.auth().currentUser?.uid {
                    //print(FirebaseManager.shared.getUserData(uid: uid))
                    FirebaseManager.shared.getUserData(uid: uid) { (result) in
                        FavouriteRecipes.shared.recipes = result
                        self.recipesTableView.reloadData()
                    }
                }
            }
            
            recipesContainer.addSubview(recipesTableView)
            recipesTableView.translatesAutoresizingMaskIntoConstraints = false
            recipesTableView.fillView(recipesContainer)
            recipesTableView.backgroundColor = .white
            recipesTableView.separatorColor = .clear
            recipesTableView.rowHeight = cellHeight
            recipesTableView.sectionFooterHeight = 0.0
            recipesTableView.layer.cornerRadius = 10
            recipesTableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            recipesTableView.showsVerticalScrollIndicator = false
            recipesTableView.register(FavoritesTableViewCell.self, forCellReuseIdentifier: self.cellReuseIdentifier)
            recipesTableView.dataSource = self
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! FavoritesTableViewCell
        
//        let recipe = SharedRecipes.sharedInstance.recipes[indexPath.section]
//        if let uid = Auth.auth().currentUser?.uid {
//            let recipe = FirebaseManager.shared.getUserData(uid: uid)
//            let url = URL(string: recipe[indexPath.section]["image"] as! String)
//
//            //        cell.recipeImage.kf.cancelDownloadTask()
//            cell.recipeImage.kf.setImage(with: url)
//            cell.recipeName.text = (recipe[indexPath.section]["title"] as! String)
//        }
        cell.mainCellView.bounds = CGRect(x: 0, y: 0, width: view.bounds.width - 2 * indent, height: cellHeight)
        
        cell.mainCellView.layer.shadowColor = UIColor.gray.cgColor
        cell.mainCellView.layer.shadowRadius = 4
        cell.mainCellView.layer.shadowOpacity = 1
        cell.mainCellView.layer.shadowOffset = .zero
        cell.mainCellView.layer.shadowPath = UIBezierPath(rect: cell.mainCellView.bounds).cgPath
        
        let recipe = FavouriteRecipes.shared.recipes[indexPath.section]
        let url = URL(string: recipe["image"] as! String)
        cell.recipeImage.kf.setImage(with: url)
        cell.recipeName.text = (recipe["title"] as! String)
        
        cell.deleteButton.addAction(for: .touchUpInside) { (deleteButton) in
            
            FirebaseManager.shared.remove(id: String(recipe["id"] as! Int))
            FavouriteRecipes.shared.recipes.remove(at: indexPath.section)
            self.recipesTableView.reloadData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    private func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return FavouriteRecipes.shared.recipes.count
    }
}

class FavoritesTableViewCell: UITableViewCell {
    let indent: CGFloat = 12
    let cellHeight: CGFloat = 140
    var favorite: Bool = false
    
    var deleteButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setBackgroundImage(UIImage(named: "trash"), for: .normal)
        return btn
    }()
    
    var recipeImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        return img
    }()
    
    var recipeName: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "AppleSDGothicNeo", size: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        return lbl
    }()
    
    var mainCellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layer.backgroundColor = UIColor.clear.cgColor
        
        mainCellView.backgroundColor = .white
        mainCellView.layer.cornerRadius = 8
        recipeImage.layer.cornerRadius = 8
        recipeImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        self.contentView.addSubview(mainCellView)
        mainCellView.addSubview(recipeImage)
        mainCellView.addSubview(recipeName)
        mainCellView.addSubview(deleteButton)
        
        contentView.addConstraints([
            mainCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: indent),
            mainCellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -indent),
            mainCellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainCellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        mainCellView.addConstraints([
            recipeImage.leadingAnchor.constraint(equalTo: mainCellView.leadingAnchor),
            recipeImage.widthAnchor.constraint(equalToConstant: 100),
            recipeImage.topAnchor.constraint(equalTo: mainCellView.topAnchor),
            recipeImage.bottomAnchor.constraint(equalTo: mainCellView.bottomAnchor)
        ])
        
        mainCellView.addConstraints([
            recipeName.leadingAnchor.constraint(equalTo: recipeImage.trailingAnchor, constant: 20),
            recipeName.trailingAnchor.constraint(equalTo: mainCellView.trailingAnchor, constant: -20)
        ])
        
        mainCellView.addConstraints([
            deleteButton.trailingAnchor.constraint(equalTo: mainCellView.trailingAnchor),
            deleteButton.topAnchor.constraint(equalTo: mainCellView.topAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 20),
            deleteButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
