//
//  LoginView.swift
//  Bankey
//
//  Created by Arunkumar on 14/05/25.
//

import UIKit


class LoginView: UIView {
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password                                  "
        textField.isSecureTextEntry = true
        textField.enablePasswordToggle()
        return textField
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Bankey"
        label.font = UIScaler.font(size: 32, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    let titleDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Your premium source for all\n things banking!"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = UIScaler.font(size: 16)
        return label
    }()
    
    let separatorView = SeparatorView()
    
    let stackView = VerticalStackView()
    
    let titleStackView = VerticalStackView()
    
    var titleStackViewCentreXAnchorConstraint: NSLayoutConstraint!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     func animateTitleStackView() {
         let animator = UIViewPropertyAnimator(duration: 0.9, curve: .easeInOut) {
             //Change the constraint with animation
            self.titleStackViewCentreXAnchorConstraint?.constant = 0
            self.titleStackViewCentreXAnchorConstraint?.isActive = true
            self.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    //Since all element inside this have intrinsic size so this no longer needed.
//    override var intrinsicContentSize: CGSize {
//        .init(width: 200, height: 100)
//    }
}

extension LoginView {
    
    private func style() {
        backgroundColor = .secondarySystemBackground
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        layer.cornerRadius = 8
    }
    
    private func layout() {
    
        addSubview(titleStackView)
        addSubview(stackView)
        
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(titleDescriptionLabel)
        titleStackView.spacing = UIScaler.scaled(16)
        
        //Set constraint
        titleStackViewCentreXAnchorConstraint = titleStackView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -1000)
        
        NSLayoutConstraint.activate([
            titleStackViewCentreXAnchorConstraint,
            titleStackView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: UIScaler.scaled(-16)),
        ])
    
        
        stackView.addArrangedSubview(usernameTextField)
        stackView.addArrangedSubview(separatorView)
        stackView.addArrangedSubview(passwordTextField)
        
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = UIScaler.scaled(8)
        
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        stackView.isLayoutMarginsRelativeArrangement = true
        let scaledSize = UIScaler.scaled(8)
        stackView.layoutMargins = UIEdgeInsets(top: scaledSize, left: scaledSize, bottom: scaledSize, right: scaledSize)

    }
}

extension LoginView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()  // dismiss keyboard
        return true
    }
}



class VerticalStackView: UIStackView {
    
    init() {
        super.init(frame: .zero)
        
        self.axis = .vertical
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




struct UIScaler {
    
    static let baseWidth: CGFloat = 375.0

    static var scale: CGFloat {
        UIScreen.main.bounds.width / baseWidth
    }

    static func scaled(_ value: CGFloat) -> CGFloat {
        return value * scale
    }

    static func font(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont.systemFont(ofSize: scaled(size), weight: weight)
    }
}
