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
    let indent: CGFloat = 12
    let cellHeight: CGFloat = 140
    let headerText = UILabel()
    let recipesContainer = UIView()
    let userButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SharedRecipes.sharedInstance.recipes.append(RecipeByIngredients(id: 1, title: "Some food sdfassdfasfdfasfads", image: "https://www.hackingwithswift.com/uploads/articles/shadows-2.png", usedIngredientCount: 3, missedIngredientCount: 3))
        SharedRecipes.sharedInstance.recipes.append(RecipeByIngredients(id: 2, title: "Some food sdfasdfasfads", image: "https://koenig-media.raywenderlich.com/uploads/2019/11/CombineGettingStarted-feature.png", usedIngredientCount: 3, missedIngredientCount: 3))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .red
        
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
        
        
        view.addSubview(recipesContainer)
        recipesContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            recipesContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            recipesContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            recipesContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recipesContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
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
        
        let fav = FavouriteRecipes.shared.recipes.map { (recipe) -> Int in
            recipe["id"] as! Int
        }.contains(recipe.id)
        
        if fav == false {
            cell.heartButton.setBackgroundImage(UIImage(named: "favorite"), for: .normal)
        }
        else {
            cell.heartButton.setBackgroundImage(UIImage(named: "favorite-painted-over"), for: .normal)
        }
        
        cell.heartButton.addAction(for: .touchUpInside) { (heartButton) in
            print(FavouriteRecipes.shared.recipes.count)
            if fav == true {
                FirebaseManager.shared.remove(id: String(recipe.id))
                cell.heartButton.setBackgroundImage(UIImage(named: "favorite"), for: .normal)
            }
            else {
                FirebaseManager.shared.saveRecipe(recipe: recipe)
                cell.heartButton.setBackgroundImage(UIImage(named: "favorite-painted-over"), for: .normal)
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
        btn.setBackgroundImage(UIImage(named: "favorite"), for: .normal)
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
            recipeName.trailingAnchor.constraint(equalTo: mainCellView.trailingAnchor, constant: -20)
        ])
        
        mainCellView.addConstraints([
            heartButton.trailingAnchor.constraint(equalTo: mainCellView.trailingAnchor),
            heartButton.topAnchor.constraint(equalTo: mainCellView.topAnchor),
            heartButton.heightAnchor.constraint(equalToConstant: 20),
            heartButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
