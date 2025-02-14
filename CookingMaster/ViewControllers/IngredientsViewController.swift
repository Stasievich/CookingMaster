//
//  IngredientsViewController.swift
//  CookingMaster
//
//  Created by Victor on 1/21/21.
//

import UIKit
import Speech
import AVKit
import Firebase


class IngredientsViewController: UIViewController {

    var recipes = [RecipeByIngredients]()
    var searchByChosenIngredientsButton = UIButton()
    var clearPantry = UIButton()
    var ingredients = [String]()
    let headerText = UILabel()
    
    var dataSource: UICollectionViewDiffableDataSource<Ingredients, ListItem>!
//    var ingredientsLayout: UICollectionViewFlowLayout = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//
//        return layout
//    }()
//    var listLayout: UICollectionViewCompositionalLayout = {
//        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
//        layoutConfig.headerMode = .firstItemInSection
//        let layout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
//        return layout
//    }()
//    var mosaicLayout: UICollectionViewCompositionalLayout = {
//        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .plain)
//    }
//    let reuseID = "cell"
    
    var voiceButton = UIButton(type: .system)
    var recognizedTextLabel = UILabel()
    var searchByVoiceButton = UIButton(type: .system)
    let userButton = UIButton()
    
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    var recognitionRequest : SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask : SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    
    
    fileprivate func getRecipes() {
        FoodAPI.shared.getRecipesByIngredient(ingredients: self.ingredients) { (data, error) in
            guard let data = data else  { return }
            
            do {
                let getRecipes = try JSONDecoder().decode([RecipeByIngredients].self, from: data)
                
                DispatchQueue.main.async {
                    self.recipes = getRecipes
                    SharedRecipes.sharedInstance.recipes = getRecipes
                    self.tabBarController?.selectedIndex = 1
                }
            }
            catch {
                print(error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.Theme.mainColor
        
        headerText.text = "Ingredients"
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
        
        
        let searchRecipesByChosenIngredientsContainer = UIView()
        view.addSubview(searchRecipesByChosenIngredientsContainer)
        searchRecipesByChosenIngredientsContainer.backgroundColor = .white
        
        searchRecipesByChosenIngredientsContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            searchRecipesByChosenIngredientsContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            searchRecipesByChosenIngredientsContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(self.tabBarController?.tabBar.frame.size.height)!),
            searchRecipesByChosenIngredientsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchRecipesByChosenIngredientsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        searchRecipesByChosenIngredientsContainer.addSubview(searchByChosenIngredientsButton)
        searchByChosenIngredientsButton.translatesAutoresizingMaskIntoConstraints = false
        searchByChosenIngredientsButton.setTitle("See recipes", for: .normal)
        searchByChosenIngredientsButton.setButtonToMainTheme()
        searchRecipesByChosenIngredientsContainer.addConstraints([
            searchByChosenIngredientsButton.topAnchor.constraint(equalTo: searchRecipesByChosenIngredientsContainer.topAnchor, constant: 10),
            searchByChosenIngredientsButton.heightAnchor.constraint(equalToConstant: 30),
            searchByChosenIngredientsButton.trailingAnchor.constraint(equalTo: searchRecipesByChosenIngredientsContainer.trailingAnchor, constant: -10),
            searchByChosenIngredientsButton.widthAnchor.constraint(equalToConstant: view.frame.width / 2 - 20),
        ])
        
        searchRecipesByChosenIngredientsContainer.addSubview(clearPantry)
        clearPantry.translatesAutoresizingMaskIntoConstraints = false
        clearPantry.setTitle("Clear pantry", for: .normal)
        clearPantry.setTitleColor(.gray, for: .normal)
        clearPantry.backgroundColor = UIColor(cgColor: CGColor(gray: 0.9, alpha: 1))
        clearPantry.layer.cornerRadius = 5
        searchRecipesByChosenIngredientsContainer.addConstraints([
            clearPantry.topAnchor.constraint(equalTo: searchRecipesByChosenIngredientsContainer.topAnchor, constant: 10),
            clearPantry.heightAnchor.constraint(equalToConstant: 30),
            clearPantry.leadingAnchor.constraint(equalTo: searchRecipesByChosenIngredientsContainer.leadingAnchor, constant: 10),
            clearPantry.widthAnchor.constraint(equalToConstant: view.frame.width / 2 - 20),
        ])
        
        
        
        let searchRecipesByVoiceContainer = UIView()
        view.addSubview(searchRecipesByVoiceContainer)
        searchRecipesByVoiceContainer.backgroundColor = .white
        searchRecipesByVoiceContainer.translatesAutoresizingMaskIntoConstraints = false
        searchRecipesByVoiceContainer.layer.cornerRadius = 10
        searchRecipesByVoiceContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addConstraints([
            searchRecipesByVoiceContainer.heightAnchor.constraint(equalToConstant: 100),
            searchRecipesByVoiceContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            searchRecipesByVoiceContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchRecipesByVoiceContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        
        searchRecipesByVoiceContainer.addSubview(recognizedTextLabel)
        recognizedTextLabel.translatesAutoresizingMaskIntoConstraints = false
        recognizedTextLabel.lineBreakMode = .byTruncatingHead
        recognizedTextLabel.text = "Search recipes by using your voice!"
        searchRecipesByVoiceContainer.addConstraints([
            recognizedTextLabel.topAnchor.constraint(equalTo: searchRecipesByVoiceContainer.topAnchor, constant: 20),
            recognizedTextLabel.heightAnchor.constraint(equalToConstant: 20),
            recognizedTextLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 30),
            recognizedTextLabel.centerXAnchor.constraint(equalTo: searchRecipesByVoiceContainer.centerXAnchor)
        ])
        
        
        searchRecipesByVoiceContainer.addSubview(voiceButton)
        voiceButton.translatesAutoresizingMaskIntoConstraints = false
        voiceButton.setTitle("Start recording", for: .normal)
        voiceButton.setButtonToMainTheme()
        searchRecipesByVoiceContainer.addConstraints([
            voiceButton.leadingAnchor.constraint(equalTo: searchRecipesByVoiceContainer.leadingAnchor, constant: 10),
            voiceButton.widthAnchor.constraint(equalToConstant: view.frame.width / 2 - 20),
            voiceButton.topAnchor.constraint(equalTo: recognizedTextLabel.bottomAnchor, constant: 10),
            voiceButton.bottomAnchor.constraint(equalTo: searchRecipesByVoiceContainer.bottomAnchor, constant: -10)
        ])
        
        
        searchRecipesByVoiceContainer.addSubview(searchByVoiceButton)
        searchByVoiceButton.translatesAutoresizingMaskIntoConstraints = false
        searchByVoiceButton.setTitle("Search by voice", for: .normal)
        searchByVoiceButton.setButtonToMainTheme()
        searchRecipesByVoiceContainer.addConstraints([
            searchByVoiceButton.trailingAnchor.constraint(equalTo: searchRecipesByVoiceContainer.trailingAnchor, constant: -10),
            searchByVoiceButton.widthAnchor.constraint(equalToConstant: view.frame.width / 2 - 20),
            searchByVoiceButton.topAnchor.constraint(equalTo: recognizedTextLabel.bottomAnchor, constant: 10),
            searchByVoiceButton.bottomAnchor.constraint(equalTo: searchRecipesByVoiceContainer.bottomAnchor, constant: -10)
        ])
        
        
        let ingredientsContainer = UIView()
        view.addSubview(ingredientsContainer)
        ingredientsContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            ingredientsContainer.topAnchor.constraint(equalTo: searchRecipesByVoiceContainer.bottomAnchor),
            ingredientsContainer.bottomAnchor.constraint(equalTo: searchRecipesByChosenIngredientsContainer.topAnchor),
            ingredientsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ingredientsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let ingredientsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CustomViewFlowLayout())
        ingredientsContainer.addSubview(ingredientsCollectionView)
        ingredientsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        ingredientsCollectionView.fillView(ingredientsContainer)
        
        ingredientsCollectionView.backgroundColor = .white
//        ingredientsCollectionView.dataSource = self
//        ingredientsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseID)
        ingredientsCollectionView.allowsMultipleSelection = true
        ingredientsCollectionView.delegate = self
        
        let headerCellRegistration = UICollectionView.CellRegistration<HeaderViewCell, Ingredients> {
            (cell, indexPath, headerItem) in
            
            cell.label.text = headerItem.category
            cell.image.image = UIImage(named: headerItem.category)
            
        }
        
        let itemsCellRegistration = UICollectionView.CellRegistration<IngredientsViewCell, ItemInCategory> {
            (cell, indexPath, items) in
            
            cell.label.text = items.item
            
        }
        
        dataSource = UICollectionViewDiffableDataSource<Ingredients, ListItem>(collectionView: ingredientsCollectionView) {
            (collectionView, indexPath, listItem) -> UICollectionViewCell? in
            switch listItem {
            case .header(let headerItem):
                let cell = collectionView.dequeueConfiguredReusableCell(using: headerCellRegistration,
                                                                        for: indexPath,
                                                                        item: headerItem)
                return cell
            case .item(let item):
                let cell = collectionView.dequeueConfiguredReusableCell(using: itemsCellRegistration,
                                                                        for: indexPath,
                                                                        item: item)
                return cell
            }
        }
        
        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<Ingredients, ListItem>()
        
        dataSourceSnapshot.appendSections(IngredientsData.data.ingredients)
        dataSource.apply(dataSourceSnapshot)
                
        for headerItem in IngredientsData.data.ingredients {
            
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<ListItem>()
            
            let headerListItem = ListItem.header(headerItem)
            sectionSnapshot.append([headerListItem])
            
            let itemListArray = headerItem.itemsInCategory.map { ListItem.item($0) }
            sectionSnapshot.append(itemListArray, to: headerListItem)
            
//            sectionSnapshot.expand([headerListItem])
            
            dataSource.apply(sectionSnapshot, to: headerItem, animatingDifferences: false)
        }
        
        
        self.setupSpeech()
        
        
        voiceButton.addAction(for: .touchUpInside) { (voiceButton) in
            if self.audioEngine.isRunning {
                self.audioEngine.stop()
                self.recognitionRequest?.endAudio()
                self.voiceButton.setTitle("Start recording", for: .normal)
            } else {
                self.startRecording()
                self.voiceButton.setTitle("Stop recording", for: .normal)
            }
        }
        
        searchByVoiceButton.addAction(for: .touchUpInside) { (searchByVoiceButton) in
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
            self.voiceButton.setTitle("Start recording", for: .normal)
            
            guard let recognizedText = self.recognizedTextLabel.text else { return }
            
            FoodAPI.shared.getIngredientsFromString(stringToRecognize: recognizedText) { (data, error) in
                guard let data = data else  { return }

                do {
                    let getIngredients = try JSONDecoder().decode(FoodInText.self, from: data)
                    print(getIngredients)
                    DispatchQueue.main.async {
                        var arr = [String]()
                        for ingredient in getIngredients.annotations {
                            arr.append(ingredient.annotation)
                        }
                        self.ingredients = arr
                        self.getRecipes()
                    }
                }
                catch {
                    print(error)
                }
            }
        }
        
        searchByChosenIngredientsButton.addAction(for: .touchUpInside) { (searchButton) in

            self.ingredients.removeAll()
            let selectedItemsIndexes = ingredientsCollectionView.indexPathsForSelectedItems
            guard let selectedIndexes = selectedItemsIndexes else { return }
            guard selectedIndexes.count != 0 else {
                let alert = UIAlertController(title: "CookingMaster", message: "Please select one or more ingredients.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
                return
            }
            for index in selectedIndexes {
                self.ingredients.append(IngredientsData.data.ingredients[index[0]].itemsInCategory[index[1] - 1].item)
            }
            
            self.getRecipes()
        }
        
        clearPantry.addAction(for: .touchUpInside) { (clearPantry) in
            let alert = UIAlertController(title: "CookingMaster", message: "Are you sure you want to remove all your ingredients?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "NO", style: .default))
            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (alert) in
                let selectedItems = ingredientsCollectionView.indexPathsForSelectedItems
                if let items = selectedItems {
                    for indexPath in items {
                        ingredientsCollectionView.deselectItem(at: indexPath, animated:true)
                    }
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}

extension IngredientsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: view.frame.width - 20, height: 50)
        }
        else {
            let item = IngredientsData.data.ingredients[indexPath.section].itemsInCategory[indexPath.row - 1].item
            let itemSize = item.size(withAttributes: [
                NSAttributedString.Key.font : UIFont(name: "GillSans", size: 16)!
            ])
            let ingredientSize = CGSize(width: itemSize.width + 17, height: 35)
            return ingredientSize
        }
    }
}


class IngredientsViewCell: UICollectionViewCell {
    let label = UILabel()
    
    required init?(coder: NSCoder) {
        fatalError("nope!")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.backgroundColor = CGColor(gray: 0.9, alpha: 1)
        let selectedBackground = UIView()
        selectedBackground.backgroundColor = UIColor.Theme.buttonColor
        label.textColor = .systemGray
        label.highlightedTextColor = .white
        selectedBackground.layer.cornerRadius = 5
        selectedBackgroundView = selectedBackground
        
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GillSans", size: 16)
        label.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant:  -8).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        
        layer.cornerRadius = 5
        
    }
}

class HeaderViewCell: UICollectionViewListCell {
    let label = UILabel()
    let image = UIImageView()
    let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header, tintColor: UIColor.Theme.mainColor)
    
    required init?(coder: NSCoder) {
        fatalError("nope!")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        layer.backgroundColor = CGColor(red: 1, green: 0, blue: 1, alpha: 1)
        contentView.layer.backgroundColor = UIColor.Theme.mainColor.cgColor
        
        accessories = [.outlineDisclosure(options: headerDisclosureOption)]
        
        contentView.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
//        image.image = UIImage(named: "")
        image.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        image.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        image.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant:  -8).isActive = true
        image.widthAnchor.constraint(equalToConstant: 34).isActive = true
        
        
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Heavy", size: 12)
        label.textColor = .white
        label.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        label.leadingAnchor.constraint(equalTo: image.safeAreaLayoutGuide.trailingAnchor, constant: 20).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant:  -8).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        contentView.layer.cornerRadius = 5
        
    }
    
}

class CustomViewFlowLayout: UICollectionViewFlowLayout {
    let cellSpacing: CGFloat = 10
 
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        self.minimumLineSpacing = 10.0
        self.sectionInset = UIEdgeInsets(top: 12.0, left: 10.0, bottom: 0.0, right: 10.0)
        let attributes = super.layoutAttributesForElements(in: rect)
 
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + cellSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes
    }
}
