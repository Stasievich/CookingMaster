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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
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
        containerView.backgroundColor = #colorLiteral(red: 0.8064470887, green: 0.8808635473, blue: 0.9482396245, alpha: 1)
//        containerView.showsVerticalScrollIndicator = false
       
        
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
        recipeLabel.font = UIFont(name: "Helvetica-bold", size: 20)
        recipeLabel.numberOfLines = 0
        containerView.addSubview(recipeLabel)
        
        containerView.addConstraints([
            recipeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            recipeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            recipeLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9)
        ])
        
        
        let recipeText = UITextView()
        recipeText.translatesAutoresizingMaskIntoConstraints = false
        recipeText.text = recipeDescription
        recipeText.font = UIFont(name: "Helvetica", size: 20)
        recipeText.backgroundColor = #colorLiteral(red: 0.8064470887, green: 0.8808635473, blue: 0.9482396245, alpha: 1)
        containerView.addSubview(recipeText)
        
        containerView.addConstraints([
            recipeText.topAnchor.constraint(equalTo: recipeLabel.bottomAnchor, constant: 20),
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


