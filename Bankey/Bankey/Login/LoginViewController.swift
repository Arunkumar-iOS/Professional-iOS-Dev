//
//  ViewController.swift
//  Bankey
//
//  Created by Arunkumar on 14/05/25.
//

import UIKit


protocol LoginViewControllerDelegate: AnyObject {
    func didLogIn()
}



class LoginViewController: UIViewController {
    
    let loginView = LoginView()
    
    weak var delegate: LoginViewControllerDelegate?
    
    let signInButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.title = "Sign In"
        config.showsActivityIndicator = false
        config.imagePadding = UIScaler.scaled(12) // this controls spacing between spinner and text
        button.configuration = config
        button.addTarget(self, action: #selector(signInBtnTapped), for: .touchUpInside)
        return button
    }()
    
    let errorMsgLabel: UILabel = {
       let label = UILabel()
        label.textColor = .red
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIScaler.font(size: 12)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        style()
        layout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        signInButton.configuration?.showsActivityIndicator = false
    }


}

extension LoginViewController {
    
    private func style() {
        loginView.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        errorMsgLabel.translatesAutoresizingMaskIntoConstraints = false
        
        signInButton.layer.cornerRadius = UIScaler.scaled(8)
       
    }
    
    private func layout() {
        
        view.addSubview(loginView)
        view.addSubview(signInButton)
        view.addSubview(errorMsgLabel)
        
        NSLayoutConstraint.activate([
            loginView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScaler.scaled(16)),
            loginView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UIScaler.scaled(-16)),
            loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            signInButton.topAnchor.constraint(equalTo: loginView.bottomAnchor, constant: UIScaler.scaled(16)),
            signInButton.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: loginView.trailingAnchor),
            
            errorMsgLabel.topAnchor.constraint(equalToSystemSpacingBelow: signInButton.bottomAnchor, multiplier: 2),
            errorMsgLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScaler.scaled(8)),
            errorMsgLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UIScaler.scaled(8)),

        ])
    }
}

//For Actions
extension LoginViewController {
    
    @objc func signInBtnTapped() {

        handleLogin()
    }
    
    private func handleLogin() {
                
        errorMsgLabel.isHidden = true
        
        //Unwrap an Optional
        guard let userName = loginView.usernameTextField.text, let password = loginView.passwordTextField.text else {
            assertionFailure("You must need username and password to contine process.!")
            return
        }
        //Check unwrapped value for certain condition
       guard !userName.isEmpty, !password.isEmpty else {
            configureErrorLabel(withText: "Please enter username and password")
            return
        }
        
        guard userName == "1" && password == "1" else {
            configureErrorLabel(withText: "Please check your username or password")
            return
        }
        
        print("You loggedIn successfully")
        signInButton.configuration!.showsActivityIndicator = true
        print(delegate)
        delegate!.didLogIn()
    }
    
    private func configureErrorLabel(withText text: String) {
        errorMsgLabel.text = text
        errorMsgLabel.isHidden = false
        
        UserDefaults.isLoggedIn = true
    }
    
}


extension UserDefaults {
    
    //Extension shouldn't has stored properties instead use enum for better architecture
    static let defaults = UserDefaults.standard
    
    enum keys: String {
        case isLoggedIn = "isLoggedIn"
    }
    
     static var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: keys.isLoggedIn.rawValue)
        }
        set {
            defaults.set(newValue, forKey: keys.isLoggedIn.rawValue)
        }
    }
    
}
