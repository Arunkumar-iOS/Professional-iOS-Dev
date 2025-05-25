//
//  ViewController.swift
//  PasswordValidation
//
//  Created by Arunkumar on 25/05/25.
//

import UIKit

class PasswordValidationViewController: UIViewController {

    lazy var newPasswordFieldView: PasswordFieldView = {
        let passwordField = PasswordFieldView(placeholderText: "New Password")
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        return passwordField
    }()
    
    lazy var reEnterPasswordFieldView: PasswordFieldView = {
        let passwordField = PasswordFieldView(placeholderText: "Re-enter New Password")
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        return passwordField
    }()
    
    let passwordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
    }


}

extension PasswordValidationViewController {
    
    private func layout() {
        
        passwordStackView.addArrangedSubviews( [newPasswordFieldView, reEnterPasswordFieldView] )
        
        view.addSubview(passwordStackView)
        
        NSLayoutConstraint.activate([
            newPasswordFieldView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            newPasswordFieldView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            newPasswordFieldView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
}


extension UIStackView {
    /// Adds an array of views to the arrangedSubviews
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
