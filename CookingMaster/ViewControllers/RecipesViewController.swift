//
//  RecipesViewController.swift
//  CookingMaster
//
//  Created by Victor on 1/24/21.
//

import UIKit
import Kingfisher

class SharedRecipes {
    static let sharedInstance = SharedRecipes()
    var recipes = [RecipeByIngredients]()
}


class RecipesViewController: UIViewController {
    var recipesTableView = UITableView.init(frame: .zero, style: .grouped)
    let cellReuseIdentifier = "recipe"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.backgroundColor = .white
        
        DispatchQueue.main.async {
            self.recipesTableView.reloadData()
            self.view.addSubview(self.recipesTableView)
            self.recipesTableView.frame = self.view.frame.offsetBy(dx: 0, dy: 50)
            self.recipesTableView.register(TableViewCell.self, forCellReuseIdentifier: self.cellReuseIdentifier)
            self.recipesTableView.dataSource = self
            self.recipesTableView.rowHeight = 140
        }
    }
}

extension RecipesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! TableViewCell
        
        let recipe = SharedRecipes.sharedInstance.recipes[indexPath.section]
        cell.backgroundColor = .white
        let url = URL(string: recipe.image)
        cell.recipeImage.kf.setImage(with: url)
        cell.recipeName.text = recipe.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        SharedRecipes.sharedInstance.recipes.count
    }
}

class TableViewCell: UITableViewCell {
    var recipeImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        return img
    }()
    
    var recipeName: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(recipeImage)
        self.contentView.addSubview(recipeName)
        
        contentView.addConstraints([
            recipeImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recipeImage.widthAnchor.constraint(equalToConstant: 100),
            recipeImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            recipeImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        contentView.addConstraints([
            recipeName.leadingAnchor.constraint(equalTo: recipeImage.trailingAnchor, constant: 20),
            recipeName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
