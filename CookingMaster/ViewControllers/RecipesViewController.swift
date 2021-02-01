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
    let indent: CGFloat = 12
    let cellHeight: CGFloat = 140
    let headerText = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SharedRecipes.sharedInstance.recipes.append(RecipeByIngredients(id: 1, title: "Some food sdfassdfasfdfasfads", image: "https://www.hackingwithswift.com/uploads/articles/shadows-2.png", usedIngredientCount: 3, missedIngredientCount: 3))
        SharedRecipes.sharedInstance.recipes.append(RecipeByIngredients(id: 1, title: "Some food sdfasdfasfads", image: "https://koenig-media.raywenderlich.com/uploads/2019/11/CombineGettingStarted-feature.png", usedIngredientCount: 3, missedIngredientCount: 3))
        //    UIView.animate(withDuration: TimeInterval(1)) {
        //                //constraint change
        //                self.view.layoutSubviews()
        //            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
            headerText.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            headerText.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let lblContainer = UIView()
        let lbl = UILabel()
        lbl.font = UIFont(name: "Helvetica", size: 20)
        lbl.text = "You can make 5 recipes"
        lblContainer.frame = CGRect(x: recipesTableView.frame.minX, y: recipesTableView.frame.minY, width: recipesTableView.frame.width, height: 80)
        
        
        lblContainer.addSubview(lbl)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lblContainer.addConstraints([
            lbl.leadingAnchor.constraint(equalTo: lblContainer.leadingAnchor, constant: indent),
            lbl.centerYAnchor.constraint(equalTo: lblContainer.centerYAnchor),
            lbl.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        recipesTableView.tableHeaderView = lblContainer

        DispatchQueue.main.async {
            self.recipesTableView.reloadData()
            self.view.addSubview(self.recipesTableView)
            self.recipesTableView.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY + 80, width: self.view.frame.width, height: self.view.frame.height - 80 - (self.tabBarController?.tabBar.frame.size.height)!)
            self.recipesTableView.layer.cornerRadius = 10
            self.recipesTableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            self.recipesTableView.showsVerticalScrollIndicator = false
            self.recipesTableView.register(TableViewCell.self, forCellReuseIdentifier: self.cellReuseIdentifier)
            self.recipesTableView.dataSource = self
        }
    }
}

extension RecipesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! TableViewCell
        
        let recipe = SharedRecipes.sharedInstance.recipes[indexPath.section]
        let url = URL(string: recipe.image)
        
        cell.recipeImage.kf.setImage(with: url)
        cell.recipeName.text = recipe.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    private func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        SharedRecipes.sharedInstance.recipes.count
    }
}

class TableViewCell: UITableViewCell {
    let indent: CGFloat = 12
    let cellHeight: CGFloat = 140
    
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
        
        mainCellView.layer.bounds = CGRect(x: bounds.minX, y: bounds.minY, width: bounds.size.width - 2 * indent, height: cellHeight)
        mainCellView.backgroundColor = .white
        mainCellView.layer.cornerRadius = 8
        recipeImage.layer.cornerRadius = 8
        recipeImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        self.contentView.addSubview(mainCellView)
        mainCellView.addSubview(recipeImage)
        mainCellView.addSubview(recipeName)
        
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
        
        
        
        mainCellView.layer.shadowColor = UIColor.gray.cgColor
        mainCellView.layer.shadowRadius = 5
        mainCellView.layer.shadowOpacity = 1
        mainCellView.layer.shadowOffset = .zero
        mainCellView.layer.shadowPath = UIBezierPath(rect: mainCellView.layer.bounds).cgPath
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
