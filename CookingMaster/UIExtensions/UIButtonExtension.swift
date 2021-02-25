//
//  UIButtonExtension.swift
//  CookingMaster
//
//  Created by Victor on 2/25/21.
//

import Foundation
import UIKit

extension UIButton {
    
    func setButtonToMainTheme() {
        self.backgroundColor = UIColor.Theme.buttonColor
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = 5
    }
}
