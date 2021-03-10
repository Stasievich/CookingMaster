//
//  RecipesViewController.swift
//  CookingMaster
//
//  Created by Victor on 1/24/21.
//

import UIKit
import Kingfisher
import Firebase

class SharedRecipes {
    static let sharedInstance = SharedRecipes()
    var recipes = [RecipeByIngredients]()
}

class FavouriteRecipes {
    static let shared = FavouriteRecipes()
    var recipes = [[String: Any]]()
}


class RecipesViewController: UIViewController {
    var recipesTableView = UITableView.init(frame: .zero, style: .grouped)
    let cellReuseIdentifier = "recipe"
    let favoriteImage = UIImage(named: "favorite")?.withTintColor(UIColor.Theme.mainColor)
    let favoritePaintedOverImage = UIImage(named: "favorite-painted-over")?.withTintColor(UIColor.Theme.mainColor)
    
    let indent: CGFloat = 12
    let cellHeight: CGFloat = 140
    let headerText = UILabel()
    let recipesContainer = UIView()
    let userButton = UIButton()
    
    let recipeBookImage = UIImageView()
    let promptForAddIngredientsLabel = UILabel()
    let addIngredientsButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        SharedRecipes.sharedInstance.recipes.append(RecipeByIngredients(id: 1, title: "Some food sdfassdfasfdfasfads", image: "https://www.hackingwithswift.com/uploads/articles/shadows-2.png", usedIngredientCount: 3, missedIngredientCount: 3))
//        SharedRecipes.sharedInstance.recipes.append(RecipeByIngredients(id: 2, title: "Some food sdfasdfasfads", image: "https://koenig-media.raywenderlich.com/uploads/2019/11/CombineGettingStarted-feature.png", usedIngredientCount: 3, missedIngredientCount: 3))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = UIColor.Theme.mainColor
        
        recipesTableView.backgroundColor = .white
        recipesTableView.separatorColor = .clear
        recipesTableView.rowHeight = cellHeight
        recipesTableView.sectionFooterHeight = 0.0
        
        headerText.text = "Recipes"
        headerText.font = UIFont(name: "Helvetica", size: 30)
        headerText.textColor = .white
        headerText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerText)
        view.addConstraints([
            headerText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            headerText.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        userButton.translatesAutoresizingMaskIntoConstraints = false
        userButton.setBackgroundImage(UIImage(named: "key"), for: .normal)
        view.addSubview(userButton)
        view.addConstraints([
            userButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userButton.centerYAnchor.constraint(equalTo: headerText.centerYAnchor),
            userButton.widthAnchor.constraint(equalToConstant: 30),
            userButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        userButton.backgroundColor = .white
        userButton.layer.cornerRadius = 15
        
        userButton.addAction(for: .touchUpInside) { (signOutButton) in
            if Auth.auth().currentUser == nil {
                let signUpVC = SignUpViewController()
                self.navigationController?.pushViewController(signUpVC, animated: true)
            }
            else {
                let currentUserViewController = CurrentUserViewController()
                self.navigationController?.pushViewController(currentUserViewController, animated: true)
            }
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
        
        if SharedRecipes.sharedInstance.recipes.isEmpty {
            
            recipeBookImage.translatesAutoresizingMaskIntoConstraints = false
            recipeBookImage.image = UIImage(named: "recipeBook")
            recipesContainer.addSubview(recipeBookImage)
            recipesContainer.addConstraints([
                recipeBookImage.topAnchor.constraint(equalTo: recipesContainer.topAnchor, constant: 60),
                recipeBookImage.centerXAnchor.constraint(equalTo: recipesContainer.centerXAnchor),
                recipeBookImage.widthAnchor.constraint(equalToConstant: view.frame.width / 4),
                recipeBookImage.heightAnchor.constraint(equalToConstant: view.frame.width / 4)
            ])
            
            
            
            
            promptForAddIngredientsLabel.translatesAutoresizingMaskIntoConstraints = false
            promptForAddIngredientsLabel.text = "Add your ingredients to get started"
            promptForAddIngredientsLabel.font = UIFont(name: "Helvetica", size: 14)
            promptForAddIngredientsLabel.numberOfLines = 2
            promptForAddIngredientsLabel.textAlignment = .center
            recipesContainer.addSubview(promptForAddIngredientsLabel)
            recipesContainer.addConstraints([
                promptForAddIngredientsLabel.topAnchor.constraint(equalTo: recipeBookImage.bottomAnchor, constant: 20),
                promptForAddIngredientsLabel.centerXAnchor.constraint(equalTo: recipesContainer.centerXAnchor),
                promptForAddIngredientsLabel.widthAnchor.constraint(equalToConstant: 140.0)
            ])
            
            addIngredientsButton.translatesAutoresizingMaskIntoConstraints = false
            addIngredientsButton.setTitle("Add ingredients", for: .normal)
            addIngredientsButton.titleLabel?.textAlignment = .center
            addIngredientsButton.setButtonToMainTheme()
            recipesContainer.addSubview(addIngredientsButton)
            recipesContainer.addConstraints([
                addIngredientsButton.centerXAnchor.constraint(equalTo: recipesContainer.centerXAnchor),
                addIngredientsButton.topAnchor.constraint(equalTo: promptForAddIngredientsLabel.bottomAnchor, constant: 20),
                addIngredientsButton.widthAnchor.constraint(equalToConstant: 150)
            ])
            
            addIngredientsButton.addAction(for: .touchUpInside) { (addIngredientsButton) in
                self.tabBarController?.selectedIndex = 0
            }
            
            
        }
        
        else {
            
            
            
            let lblContainer = UIView()
            let lbl = UILabel()
            lbl.font = UIFont(name: "Helvetica", size: 20)
            lbl.text = "You can make \(SharedRecipes.sharedInstance.recipes.count) recipes"
            lblContainer.frame = CGRect(x: recipesTableView.frame.minX, y: recipesTableView.frame.minY, width: recipesTableView.frame.width, height: 80)
            
            
            lblContainer.addSubview(lbl)
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lblContainer.addConstraints([
                lbl.leadingAnchor.constraint(equalTo: lblContainer.leadingAnchor, constant: indent),
                lbl.centerYAnchor.constraint(equalTo: lblContainer.centerYAnchor),
                lbl.heightAnchor.constraint(equalToConstant: 50)
            ])
            
            recipesTableView.tableHeaderView = lblContainer
            
            
            
            
            recipesContainer.addSubview(recipesTableView)
            recipesTableView.translatesAutoresizingMaskIntoConstraints = false
            recipesTableView.fillView(recipesContainer)
            
            recipesTableView.layer.cornerRadius = 10
            recipesTableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            recipesTableView.showsVerticalScrollIndicator = false
            recipesTableView.delegate = self
            recipesTableView.dataSource = self
            recipesTableView.register(TableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
            recipesTableView.reloadData()
        }
        
    }
}

extension RecipesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        FoodAPI.shared.getRecipeInformation(recipeId: SharedRecipes.sharedInstance.recipes[indexPath.section].id) { (data, error) in
            guard let data = data else  { return }
            
            do {
                let getRecipeInfo = try JSONDecoder().decode(RecipeDescription.self, from: data)
                
                DispatchQueue.main.async {
                    
                    let recipeDescription = RecipeDescriptionViewController()
                    if let description = getRecipeInfo.instructions {
                        recipeDescription.recipeDescription = description
                    }
                    else {
                        recipeDescription.recipeDescription = getRecipeInfo.sourceUrl
                    }
                    recipeDescription.recipeName = getRecipeInfo.title
                    recipeDescription.recipeImageName = getRecipeInfo.image
                    recipeDescription.recipeStringTags = getRecipeInfo.getPositiveTags()
                    
                    self.navigationController?.pushViewController(recipeDescription, animated: true)
                }
            }
            catch {
                print(error)
            }
        }
    }
}

extension RecipesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! TableViewCell
        
        let recipe = SharedRecipes.sharedInstance.recipes[indexPath.section]
        let url = URL(string: recipe.image)
        
//        cell.recipeImage.kf.cancelDownloadTask()
        cell.mainCellView.bounds = CGRect(x: 0, y: 0, width: view.bounds.width - 2 * indent, height: cellHeight)
//        UIApplication.shared.windows.first?.bounds.size
        cell.mainCellView.layer.shadowColor = UIColor.gray.cgColor
        cell.mainCellView.layer.shadowRadius = 4
        cell.mainCellView.layer.shadowOpacity = 1
        cell.mainCellView.layer.shadowOffset = .zero
        cell.mainCellView.layer.shadowPath = UIBezierPath(rect: cell.mainCellView.bounds).cgPath
        
        cell.recipeImage.kf.setImage(with: url)
        cell.recipeName.text = recipe.title
//        cell.recipeName.font = UIFont(name: "AppleSDGothicNeo", size: 18)
        cell.usedIngredientsCountLabel.text = "You have all \(recipe.usedIngredientCount) ingredients"
//        cell.usedIngredientsCountLabel.font = UIFont(name: "AppleSDGothicNeo", size: 8)
//        cell.usedIngredientsCountLabel.textColor = .gray
        
        let fav = FavouriteRecipes.shared.recipes.map { (recipe) -> Int in
            recipe["id"] as! Int
        }.contains(recipe.id)
        
        if fav == false {
            cell.heartButton.setBackgroundImage(favoriteImage, for: .normal)
        }
        else {
            cell.heartButton.setBackgroundImage(favoritePaintedOverImage, for: .normal)
        }
        
        cell.heartButton.addAction(for: .touchUpInside) { (heartButton) in
            if Auth.auth().currentUser != nil {
                
                print(FavouriteRecipes.shared.recipes.count)
                if fav == true {
                    FirebaseManager.shared.remove(id: String(recipe.id))
                    FavouriteRecipes.shared.recipes = FavouriteRecipes.shared.recipes.filter({
                        $0["id"] as! Int != recipe.id
                    })
                    tableView.reloadData()
                    cell.heartButton.setBackgroundImage(self.favoriteImage, for: .normal)
                }
                else {
                    FirebaseManager.shared.saveRecipe(recipe: recipe)
                    FavouriteRecipes.shared.recipes.append(["id": recipe.id, "title": recipe.title, "image": recipe.image])
                    tableView.reloadData()
                    cell.heartButton.setBackgroundImage(self.favoritePaintedOverImage, for: .normal)
                }
            }
            else {
                let alert = UIAlertController(title: "You're not registered", message: "You need an account to save recipes. Would you like to sign up now?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "NO", style: .default))
                alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (alert) in
                    self.navigationController?.pushViewController(SignUpViewController(), animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        SharedRecipes.sharedInstance.recipes.count
    }
}

class TableViewCell: UITableViewCell {
    let indent: CGFloat = 12
    let cellHeight: CGFloat = 140
    var favorite: Bool = false
    
    var heartButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
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
        lbl.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        return lbl
    }()
    
    var usedIngredientsCountLabel: UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
        lbl.textColor = .gray
        lbl.translatesAutoresizingMaskIntoConstraints = false
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
        mainCellView.addSubview(usedIngredientsCountLabel)
        mainCellView.addSubview(heartButton)
        
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
            recipeName.trailingAnchor.constraint(equalTo: mainCellView.trailingAnchor, constant: -30),
            recipeName.topAnchor.constraint(equalTo: mainCellView.topAnchor, constant: 5)
        ])
        
        mainCellView.addConstraints([
            usedIngredientsCountLabel.leadingAnchor.constraint(equalTo: recipeImage.trailingAnchor, constant: 20),
            usedIngredientsCountLabel.trailingAnchor.constraint(equalTo: mainCellView.trailingAnchor, constant: -30),
            usedIngredientsCountLabel.bottomAnchor.constraint(equalTo: mainCellView.bottomAnchor, constant: -5)
        ])
        
        mainCellView.addConstraints([
            heartButton.trailingAnchor.constraint(equalTo: mainCellView.trailingAnchor, constant: -5),
            heartButton.topAnchor.constraint(equalTo: mainCellView.topAnchor, constant: 5),
            heartButton.heightAnchor.constraint(equalToConstant: 20),
            heartButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
