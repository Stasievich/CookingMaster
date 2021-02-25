//
//  RecipeDescriptionViewController.swift
//  CookingMaster
//
//  Created by Victor on 2/21/21.
//


import Foundation
import UIKit
import Kingfisher

class RecipeDescriptionViewController: UIViewController {
    
    var recipeImageName = String()
    var recipeName = String()
    var recipeDescription = String()
    var recipeStringTags = [String]()
    
    let reuseId = "cell"
    
    lazy var recipeTags: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: tagsLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var tagsLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        return layout
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.addBackButton()
        
        recipeTags.showsHorizontalScrollIndicator = false
        recipeTags.showsVerticalScrollIndicator = false
        
        
        let recipeImage = UIImageView()
        recipeImage.kf.setImage(with: URL(string: recipeImageName))
        view.addSubview(recipeImage)
        recipeImage.translatesAutoresizingMaskIntoConstraints = false
        recipeImage.contentMode = .scaleAspectFill
        recipeImage.clipsToBounds = true
        
        view.addConstraints([
            recipeImage.topAnchor.constraint(equalTo: view.topAnchor),
            recipeImage.widthAnchor.constraint(equalTo: view.widthAnchor),
            recipeImage.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        let containerView = UIScrollView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 15
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.backgroundColor = UIColor.Theme.recipeTextColor
        containerView.showsVerticalScrollIndicator = false
        
        
        view.addSubview(containerView)
        
        view.addConstraints([
            containerView.topAnchor.constraint(equalTo: recipeImage.bottomAnchor, constant: -15),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerView.contentLayoutGuide.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        
        let recipeLabel = UILabel()
        recipeLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeLabel.text = recipeName
        recipeLabel.font = UIFont(name: "GillSans-Bold", size: 20)
        recipeLabel.numberOfLines = 0
        containerView.addSubview(recipeLabel)
        
        containerView.addConstraints([
            recipeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            recipeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            recipeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30)
        ])
        
        containerView.addSubview(recipeTags)
        containerView.addConstraints([
            recipeTags.leadingAnchor.constraint(equalTo: recipeLabel.leadingAnchor),
            recipeTags.trailingAnchor.constraint(equalTo: recipeLabel.trailingAnchor),
            recipeTags.topAnchor.constraint(equalTo: recipeLabel.bottomAnchor, constant: 5),
            recipeTags.heightAnchor.constraint(equalToConstant: 40)
        ])
        recipeTags.backgroundColor = UIColor.Theme.recipeTextColor
        recipeTags.dataSource = self
        recipeTags.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        recipeTags.delegate = self
        
        
        let recipeText = UITextView()
        recipeText.translatesAutoresizingMaskIntoConstraints = false
        recipeText.text = recipeDescription
        recipeText.font = UIFont(name: "GillSans", size: 17)
        recipeText.backgroundColor = UIColor.Theme.recipeTextColor
        containerView.addSubview(recipeText)
        
        containerView.addConstraints([
            recipeText.topAnchor.constraint(equalTo: recipeTags.bottomAnchor, constant: 20),
            recipeText.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            recipeText.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            recipeText.bottomAnchor.constraint(equalTo: containerView.contentLayoutGuide.bottomAnchor)
        ])
        
        recipeText.isScrollEnabled = false
        recipeText.isEditable = false
        resizeTextView(textView: recipeText)
        
//        let bottomOffset = CGPoint(x: 0, y: containerView.contentSize.height - containerView.bounds.height + containerView.contentInset.bottom)
//        containerView.setContentOffset(bottomOffset, animated: true)
    }
    
    fileprivate func resizeTextView(textView: UITextView) {
        var newFrame = textView.frame
        let width = newFrame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        newFrame.size = CGSize(width: width, height: newSize.height)
        textView.frame = newFrame
    }
    
}

extension RecipeDescriptionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let item = recipeStringTags[indexPath.row]
            let itemSize = item.size(withAttributes: [
                NSAttributedString.Key.font : UIFont(name: "GillSans", size: 16)!
            ])
            let ingredientSize = CGSize(width: itemSize.width + 17, height: 35)
            return ingredientSize
        
    }
}

extension RecipeDescriptionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recipeStringTags.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! TagCollectionViewCell
        cell.label.text = recipeStringTags[indexPath.row]
        return cell
    }

}

class TagCollectionViewCell: UICollectionViewCell {
    let label = UILabel()
    
    required init?(coder: NSCoder) {
        fatalError("nope!")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        layer.backgroundColor = CGColor(gray: 0.9, alpha: 1)
//        label.textColor = .systemGray
        layer.backgroundColor = UIColor.Theme.buttonColor.cgColor
        label.textColor = .white
        
        
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
