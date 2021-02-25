//
//  LoginViewController.swift
//  CookingMaster
//
//  Created by Victor on 2/15/21.
//

import Firebase
import UIKit

class LoginViewController: UIViewController {
    
    var emailTextField = TextField()
    var passwordTextField = TextField()
    var matchLabel = UILabel()
    
    var loginContainer = UIView()
    var signUpButton = UIButton(type: .system)
    var cookButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        self.addBackButton()
        
        loginContainer.backgroundColor = .white
        loginContainer.layer.cornerRadius = 8
        view.addSubview(loginContainer)
        loginContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            loginContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            loginContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            loginContainer.heightAnchor.constraint(equalToConstant: 100.0),
            loginContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        loginContainer.layer.shadowColor = UIColor.gray.cgColor
        loginContainer.layer.shadowRadius = 10
        loginContainer.layer.shadowOpacity = 1
        loginContainer.layer.shadowOffset = .zero
        //        signUpContainer.layer.bounds = CGRect(x: 10, y: view.bounds.maxY / 2 - 100, width: view.bounds.width - 20, height: 200)
        loginContainer.layer.shadowPath = UIBezierPath(rect: loginContainer.layer.bounds).cgPath
        
        
        emailTextField.placeholder = "Email"
        loginContainer.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        loginContainer.addConstraints([
            emailTextField.trailingAnchor.constraint(equalTo: loginContainer.trailingAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: loginContainer.leadingAnchor),
            emailTextField.topAnchor.constraint(equalTo: loginContainer.topAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        emailTextField.layer.borderColor = CGColor(gray: 0.5, alpha: 1)
        emailTextField.layer.borderWidth = 0.5
        emailTextField.layer.cornerRadius = 8
        emailTextField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        emailTextField.autocorrectionType = .no
        
        passwordTextField.placeholder = "Password"
        loginContainer.addSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        loginContainer.addConstraints([
            passwordTextField.trailingAnchor.constraint(equalTo: loginContainer.trailingAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: loginContainer.leadingAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        passwordTextField.layer.borderColor = CGColor(gray: 0.5, alpha: 1)
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.layer.cornerRadius = 8
        passwordTextField.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        passwordTextField.autocorrectionType = .no
        passwordTextField.isSecureTextEntry = true
        
        
        cookButton.setTitle("Let's Cook!", for: .normal)
        view.addSubview(cookButton)
        cookButton.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            cookButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cookButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cookButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            cookButton.widthAnchor.constraint(equalToConstant: view.frame.width)
        ])
        cookButton.backgroundColor = UIColor.Theme.buttonColor
        cookButton.setTitleColor(.white, for: .normal)
        
        cookButton.addAction(for: .touchUpInside) { (cookButton) in
            guard let email = self.emailTextField.text,
                  let password = self.passwordTextField.text else { return }
            guard self.isEmailValid(email) == true else { self.matchLabel.text = "email is not valid"; return }
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                guard error == nil else { self.matchLabel.text = error!.localizedDescription; return }
                FavouriteRecipes.shared.recipes.removeAll()
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        signUpButton.setTitle("Sign Up", for: .normal)
        view.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.setTitleColor(UIColor.Theme.mainColor, for: .normal)
        view.addConstraints([
            signUpButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            signUpButton.widthAnchor.constraint(equalToConstant: 80),
            signUpButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        signUpButton.addAction(for: .touchUpInside) { (signUpButton) in
            let signUpVC = SignUpViewController()
            self.navigationController?.pushViewController(signUpVC, animated: true)
        }
        
        
        matchLabel.text = ""
        matchLabel.font = UIFont(name: "Helvetica", size: 10)
        view.addSubview(matchLabel)
        matchLabel.translatesAutoresizingMaskIntoConstraints = false
        matchLabel.numberOfLines = 0
        view.addConstraints([
            matchLabel.topAnchor.constraint(equalTo: loginContainer.bottomAnchor, constant: 5),
            matchLabel.leftAnchor.constraint(equalTo: loginContainer.leftAnchor),
            matchLabel.widthAnchor.constraint(equalTo: loginContainer.widthAnchor)
        ])
        
    }
    
    
    func isEmailValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
//        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .lightGray
    }
    
}
