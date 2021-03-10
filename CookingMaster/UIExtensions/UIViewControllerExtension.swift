//
//  UIViewControllerExtension.swift
//  CookingMaster
//
//  Created by Victor on 2/25/21.
//

import Foundation
import UIKit

extension UIViewController {

    
    
    func addBackButton() {
        let backButton: UIButton = UIButton()
        let image = UIImage(named: "previous")?.withTintColor(UIColor.Theme.mainColor)
        backButton.setImage(image, for: .normal)
        backButton.sizeToFit()
        backButton.addAction(for: .touchUpInside) { (btnLeftMenu) in
            self.navigationController?.popViewController(animated: true)
        }
        let barButton = UIBarButtonItem(customView: backButton)
        barButton.customView?.translatesAutoresizingMaskIntoConstraints = false
        barButton.customView?.heightAnchor.constraint(equalToConstant: 32).isActive = true
        barButton.customView?.widthAnchor.constraint(equalToConstant: 32).isActive = true
        navigationItem.leftBarButtonItem = barButton
    }
}
