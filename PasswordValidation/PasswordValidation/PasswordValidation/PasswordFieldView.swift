//
//  PasswordFieldView.swift
//  PasswordValidation
//
//  Created by Arunkumar on 25/05/25.
//

import UIKit


typealias CustomValidation = (_ textValue: String?) -> (Bool, String)?

class PasswordFieldView: UIView {
    
    var customValidation: CustomValidation?
    
    var text: String? {
        get { return passwordtextField.text }
        set { passwordtextField.text = newValue }
    }
    
    let textFieldPalceholderText: String
    
    var onTextChange: ((UITextField) -> Void)?
    var onTextEditingDidEnd: ((UITextField) -> Void)?
    
    lazy var passwordtextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
       // textField.placeholder = "  New Password  "
        textField.attributedPlaceholder = NSAttributedString(string: "  \(textFieldPalceholderText)  ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
        textField.textColor = .secondaryLabel
        textField.delegate = self
        
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
        
        textField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)

        
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
        label.text = ""
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
    
    @objc func textDidChange(_ sender: UITextField) {
        
        onTextChange?(sender)
    }
}


//MARK:- Delegate
extension PasswordFieldView: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("TextField end editing..! and value is \(textField.text!)")
        onTextEditingDidEnd?(textField)
            return true
        }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Return key presses and we need to dismiss a keyboard")
       // textField.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
}


// typealias CustomValidation = (_ textValue: String?) -> (Bool, String)?

// MARK: - Validation
extension PasswordFieldView {
    func validate() -> Bool {
        if let customValidation = customValidation,
            let customValidationResult = customValidation(text),
            customValidationResult.0 == false {
            showError(customValidationResult.1)
            return false
        }
        clearError()
        return true
    }
    
    private func showError(_ errorMessage: String) {
        errorLabel.isHidden = false
        errorLabel.text = errorMessage
    }

    private func clearError() {
        errorLabel.isHidden = true
        errorLabel.text = ""
    }
}
