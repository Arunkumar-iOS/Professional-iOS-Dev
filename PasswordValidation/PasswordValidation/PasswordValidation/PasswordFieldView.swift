//
//  PasswordFieldView.swift
//  PasswordValidation
//
//  Created by Arunkumar on 25/05/25.
//

import UIKit


class PasswordFieldView: UIView {
    
    let textFieldPalceholderText: String
    
    lazy var passwordtextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
       // textField.placeholder = "  New Password  "
        textField.attributedPlaceholder = NSAttributedString(string: "  \(textFieldPalceholderText)  ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
        textField.textColor = .secondaryLabel
        
        // Left Image View
        let leftImageView = UIImageView(image: UIImage(systemName: "lock.fill"))
        leftImageView.tintColor = .systemBlue
        leftImageView.contentMode = .scaleAspectFit
        leftImageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        textField.leftView = leftImageView
        textField.leftViewMode = .always

        // RightView as button
        let rightEyeButton = UIButton(type: .custom)
        rightEyeButton.tintColor = .systemBlue
        rightEyeButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        rightEyeButton.addTarget(self, action: #selector(eyeButtonTapped), for: .primaryActionTriggered)
        rightEyeButton.setImage(UIImage(systemName: "eye.circle"), for: .normal)
        rightEyeButton.setImage(UIImage(systemName: "eye.slash.circle"), for: .selected)
        textField.rightView = rightEyeButton
        textField.rightViewMode = .always
        
        return textField
    }()
    
    lazy var dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.font = .preferredFont(forTextStyle: .footnote)
        label.text = "Enter Your Password"
        //label.adjustsFontSizeToFitWidth = true //When you don't want to make multiline
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var passwordFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [passwordtextField, dividerView, errorLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    init(placeholderText: String) {
        self.textFieldPalceholderText = placeholderText
        super.init(frame: .zero)
        
        self.style()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Since every component inside has intric size so not needed. (Ref:- For dividerView we harcoded a height) otherwise if anything don't have intrinsic size use this.
//    override var intrinsicContentSize: CGSize {
//        .init(width: 250, height: 200)
//    }
}

extension PasswordFieldView {
    
    private func style() {
        
        addSubview(passwordFieldStackView)
    }
    
    private func layout() {
        
        NSLayoutConstraint.activate([
            passwordFieldStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            passwordtextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            passwordFieldStackView.topAnchor.constraint(equalTo: topAnchor),
            passwordFieldStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

//MARK:- Action
extension PasswordFieldView {
    
    @objc func eyeButtonTapped() {
        
        print("Eye Button Tapped")
    }
}
