//
//  IngredientsViewController.swift
//  CookingMaster
//
//  Created by Victor on 1/21/21.
//

import UIKit
import Speech
import AVKit


class IngredientsViewController: UIViewController {

    var recipes = [RecipeByIngredients]()
    var searchByChosenIngredientsButton = UIButton(type: .system)
    var ingredients = ["strawberry", "cheese"]
    let headerText = UILabel()
    
    var dataSource: UICollectionViewDiffableDataSource<Ingredients, ListItem>!
    var ingredientsLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .vertical
        return layout
    }()
    var listLayout: UICollectionViewCompositionalLayout = {
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        layoutConfig.headerMode = .firstItemInSection
        let layout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        return layout
    }()
    let reuseID = "cell"
    
    var voiceButton = UIButton(type: .system)
    var recognizedTextLabel = UILabel()
    var searchByVoiceButton = UIButton(type: .system)
    
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    var recognitionRequest : SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask : SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    
    
    func getRecipes() {
        FoodAPI.shared.getRecipesByIngredient(ingredients: self.ingredients) { (data, error) in
            guard let data = data else  { return }
            
            do {
                let getRecipes = try JSONDecoder().decode([RecipeByIngredients].self, from: data)
                
                DispatchQueue.main.async {
                    self.recipes = getRecipes
                    print(self.recipes)
                    SharedRecipes.sharedInstance.recipes = getRecipes
                    self.tabBarController?.selectedIndex = 1
                }
            }
            catch {
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        
        headerText.text = "Ingredients"
        headerText.font = UIFont(name: "Helvetica", size: 30)
        headerText.textColor = .white
        headerText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerText)
        view.addConstraints([
            headerText.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            headerText.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        
        let searchRecipesByChosenIngredientsContainer = UIView()
        view.addSubview(searchRecipesByChosenIngredientsContainer)
        searchRecipesByChosenIngredientsContainer.backgroundColor = .white
        searchRecipesByChosenIngredientsContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            searchRecipesByChosenIngredientsContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            searchRecipesByChosenIngredientsContainer.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            searchRecipesByChosenIngredientsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchRecipesByChosenIngredientsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        searchRecipesByChosenIngredientsContainer.addSubview(searchByChosenIngredientsButton)
        searchByChosenIngredientsButton.translatesAutoresizingMaskIntoConstraints = false
        searchByChosenIngredientsButton.setTitle("SearchByChosenIngredients", for: .normal)
        searchRecipesByChosenIngredientsContainer.addConstraints([
            searchByChosenIngredientsButton.topAnchor.constraint(equalTo: searchRecipesByChosenIngredientsContainer.topAnchor, constant: 10),
            searchByChosenIngredientsButton.heightAnchor.constraint(equalToConstant: 30),
            searchByChosenIngredientsButton.trailingAnchor.constraint(equalTo: searchRecipesByChosenIngredientsContainer.trailingAnchor, constant: -10),
            searchByChosenIngredientsButton.widthAnchor.constraint(equalToConstant: view.frame.width / 2 - 20),
        ])
        
        let searchRecipesByVoiceContainer = UIView()
        view.addSubview(searchRecipesByVoiceContainer)
        searchRecipesByVoiceContainer.backgroundColor = .white
        searchRecipesByVoiceContainer.translatesAutoresizingMaskIntoConstraints = false
        searchRecipesByVoiceContainer.layer.cornerRadius = 10
        searchRecipesByVoiceContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addConstraints([
            searchRecipesByVoiceContainer.heightAnchor.constraint(equalToConstant: 100),
            searchRecipesByVoiceContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
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
            recognizedTextLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 20),
            recognizedTextLabel.centerXAnchor.constraint(equalTo: searchRecipesByVoiceContainer.centerXAnchor)
        ])
        
        
        searchRecipesByVoiceContainer.addSubview(voiceButton)
        voiceButton.translatesAutoresizingMaskIntoConstraints = false
        voiceButton.setTitle("Start recording", for: .normal)
        searchRecipesByVoiceContainer.addConstraints([
            voiceButton.leadingAnchor.constraint(equalTo: searchRecipesByVoiceContainer.leadingAnchor, constant: 10),
            voiceButton.widthAnchor.constraint(equalToConstant: view.frame.width / 2 - 20),
            voiceButton.topAnchor.constraint(equalTo: recognizedTextLabel.bottomAnchor, constant: 10),
            voiceButton.bottomAnchor.constraint(equalTo: searchRecipesByVoiceContainer.bottomAnchor, constant: -10)
        ])
        
        
        searchRecipesByVoiceContainer.addSubview(searchByVoiceButton)
        searchByVoiceButton.translatesAutoresizingMaskIntoConstraints = false
        searchByVoiceButton.setTitle("SearchByVoice", for: .normal)
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
        
        let ingredientsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout)
        ingredientsContainer.addSubview(ingredientsCollectionView)
        ingredientsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            ingredientsCollectionView.topAnchor.constraint(equalTo: ingredientsContainer.topAnchor),
            ingredientsCollectionView.bottomAnchor.constraint(equalTo: ingredientsContainer.bottomAnchor),
            ingredientsCollectionView.leadingAnchor.constraint(equalTo: ingredientsContainer.leadingAnchor),
            ingredientsCollectionView.trailingAnchor.constraint(equalTo: ingredientsContainer.trailingAnchor)
        ])
        ingredientsCollectionView.backgroundColor = .red
//        ingredientsCollectionView.dataSource = self
        ingredientsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseID)
        ingredientsCollectionView.allowsMultipleSelection = true
//        ingredientsCollectionView.delegate = self
        
        let headerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Ingredients> {
            (cell, indexPath, headerItem) in
            
            var content = cell.defaultContentConfiguration()
            content.text = headerItem.category
            cell.contentConfiguration = content
            
            let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options: headerDisclosureOption)]
        }
        
        let itemsCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ItemInCategory> {
            (cell, indexPath, items) in
            
            var content = cell.defaultContentConfiguration()
            content.text = items.item
            cell.contentConfiguration = content
            
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
                let selectedBackground = UIView()
                selectedBackground.backgroundColor = .green
                cell.selectedBackgroundView = selectedBackground
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
            
            sectionSnapshot.expand([headerListItem])
            
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
                        print(self.ingredients)
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
            print(selectedIndexes)
            for index in selectedIndexes {
                self.ingredients.append(IngredientsData.data.ingredients[index[0]].itemsInCategory[index[1] - 1].item)
            }
            
            print(self.ingredients)
            self.getRecipes()
        }
        
    }
}

//extension IngredientsViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 20
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath)
//        cell.backgroundColor = .systemBlue
//
//        let selectedBackground = UIView()
//        selectedBackground.backgroundColor = .green
//        cell.selectedBackgroundView = selectedBackground
//        return cell
//    }
//
//}

//extension IngredientsViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.ingredients = IngredientsData.data.ingredients[indexPath.section].itemsInCategory[indexPath.row].item
//
//    }
//}
