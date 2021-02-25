//
//  SignUpViewController.swift
//  CookingMaster
//
//  Created by Victor on 2/13/21.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    var nameTextField = TextField()
    var emailTextField = TextField()
    var passwordTextField = TextField()
    var verifyPasswordTextField = TextField()
    var matchLabel = UILabel()
    
    var signUpContainer = UIView()
    var loginButton = UIButton(type: .system)
    var cookButton = UIButton(type: .system)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = .lightGray
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray

        signUpContainer.backgroundColor = .white
        signUpContainer.layer.cornerRadius = 8
        view.addSubview(signUpContainer)
        signUpContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            signUpContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            signUpContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            signUpContainer.heightAnchor.constraint(equalToConstant: 200.0),
            signUpContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        signUpContainer.layer.shadowColor = UIColor.gray.cgColor
        signUpContainer.layer.shadowRadius = 10
        signUpContainer.layer.shadowOpacity = 1
        signUpContainer.layer.shadowOffset = .zero
//        signUpContainer.layer.bounds = CGRect(x: 10, y: view.bounds.maxY / 2 - 100, width: view.bounds.width - 20, height: 200)
        signUpContainer.layer.shadowPath = UIBezierPath(rect: signUpContainer.layer.bounds).cgPath
        
        
        nameTextField.placeholder = "Name"
        signUpContainer.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        signUpContainer.addConstraints([
            nameTextField.trailingAnchor.constraint(equalTo: signUpContainer.trailingAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: signUpContainer.leadingAnchor),
            nameTextField.topAnchor.constraint(equalTo: signUpContainer.topAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        nameTextField.layer.borderColor = CGColor(gray: 0.5, alpha: 1)
        nameTextField.layer.borderWidth = 0.5
        nameTextField.layer.cornerRadius = 8
        nameTextField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        nameTextField.autocorrectionType = .no
        
        emailTextField.placeholder = "Email"
        signUpContainer.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        signUpContainer.addConstraints([
            emailTextField.trailingAnchor.constraint(equalTo: signUpContainer.trailingAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: signUpContainer.leadingAnchor),
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        emailTextField.layer.borderColor = CGColor(gray: 0.5, alpha: 1)
        emailTextField.layer.borderWidth = 0.5
        emailTextField.autocorrectionType = .no
        
        passwordTextField.placeholder = "Password"
        signUpContainer.addSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        signUpContainer.addConstraints([
            passwordTextField.trailingAnchor.constraint(equalTo: signUpContainer.trailingAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: signUpContainer.leadingAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        passwordTextField.layer.borderColor = CGColor(gray: 0.5, alpha: 1)
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.autocorrectionType = .no
        passwordTextField.isSecureTextEntry = true
        
        verifyPasswordTextField.placeholder = "Verify password"
        signUpContainer.addSubview(verifyPasswordTextField)
        verifyPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        signUpContainer.addConstraints([
            verifyPasswordTextField.trailingAnchor.constraint(equalTo: signUpContainer.trailingAnchor),
            verifyPasswordTextField.leadingAnchor.constraint(equalTo: signUpContainer.leadingAnchor),
            verifyPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor),
            verifyPasswordTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        verifyPasswordTextField.layer.borderColor = CGColor(gray: 0.5, alpha: 1)
        verifyPasswordTextField.layer.borderWidth = 0.5
        verifyPasswordTextField.layer.cornerRadius = 8
        verifyPasswordTextField.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        verifyPasswordTextField.autocorrectionType = .no
        verifyPasswordTextField.isSecureTextEntry = true
        
        
        cookButton.setTitle("Let's Cook!", for: .normal)
        view.addSubview(cookButton)
        cookButton.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            cookButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cookButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cookButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            cookButton.widthAnchor.constraint(equalToConstant: view.frame.width)
        ])
        cookButton.backgroundColor = .red
        cookButton.setTitleColor(.white, for: .normal)
        
        cookButton.addAction(for: .touchUpInside) { (cookButton) in
            guard let email = self.emailTextField.text,
                  let password = self.verifyPasswordTextField.text else { return }
            guard self.isEmailValid(email) == true else { self.matchLabel.text = "email is not valid"; return }
            guard self.isPasswordValid(password) == true else { return }
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                guard error == nil else { self.matchLabel.text = "\(error!.localizedDescription)"; return }
                
                let newUser = authResult?.user
                if let id = newUser?.uid {
                    FirebaseManager.shared.saveNewUser(id: id, name: self.nameTextField.text!)
                }
                print("\(String(describing: newUser?.email)) created!")
                Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                    FavouriteRecipes.shared.recipes.removeAll()
                }
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        loginButton.setTitle("Login", for: .normal)
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            loginButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            loginButton.widthAnchor.constraint(equalToConstant: 80),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        loginButton.addAction(for: .touchUpInside) { (loginButton) in
            let loginVC = LoginViewController()
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
        
        
        matchLabel.text = ""
        matchLabel.font = UIFont(name: "Helvetica", size: 10)
        view.addSubview(matchLabel)
        matchLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            matchLabel.topAnchor.constraint(equalTo: signUpContainer.bottomAnchor, constant: 5),
            matchLabel.leftAnchor.constraint(equalTo: signUpContainer.leftAnchor),
            matchLabel.widthAnchor.constraint(equalTo: signUpContainer.widthAnchor)
        ])
        
    }
    
    
    func isEmailValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isPasswordValid(_ password: String) -> Bool {
        if passwordTextField.text != verifyPasswordTextField.text {
            matchLabel.text = "Passwords don't match!"
            return false
        }
        else if let count = verifyPasswordTextField.text?.count {
            if count < 8 {
                matchLabel.text = "Password must contain at least 8 characters!"
                return false
            }
            else if passwordTextField.text == passwordTextField.text?.lowercased() {
                matchLabel.text = "Password must contain at least 1 uppercase character!"
                return false
            }
            else if passwordTextField.text == passwordTextField.text?.uppercased() {
                matchLabel.text = "Password must contain at least 1 lowercase character!"
                return false
            }
            else if passwordTextField.text?.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil {
                matchLabel.text = "Password must contain at least 1 digit character!"
                return false
            }
            else {
                matchLabel.text = ""
                return true
            }
        }
        return true
    }

   

}
