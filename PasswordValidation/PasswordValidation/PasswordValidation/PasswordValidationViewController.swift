//
//  ViewController.swift
//  PasswordValidation
//
//  Created by Arunkumar on 25/05/25.
//

import UIKit

class PasswordValidationViewController: UIViewController, UITextFieldDelegate {
    
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
        //When stackview gives ambiguity or not layed correclty just play with things along with anchors of stackview
        //    stackView.distribution = .fill
        //    stackView.alignment = .leading
        return stackView
    }()
    
    lazy var passwordCriteriaStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [noSpaceLabelView, upperCaseLabelView, lowerCaseLabelView, digitLabelView, specialCharLabelView])
        stackView.axis = .vertical
        stackView.backgroundColor = .systemGroupedBackground
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 8
        stackView.layer.masksToBounds = true
        
        //add padding
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 8, left: 16, bottom: 8, right: 16)
        return stackView
    }()
    
    let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset Password", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    let noSpaceLabelView = PasswordCriteriaView(labelText: "8-32 characters (no spaces)", showDescription: true)
    let upperCaseLabelView = PasswordCriteriaView(labelText: "Uppercase letter (A-Z)")
    let lowerCaseLabelView = PasswordCriteriaView(labelText: "lower case (a-z)")
    let digitLabelView = PasswordCriteriaView(labelText: "digit (0-9)")
    let specialCharLabelView = PasswordCriteriaView(labelText: "Special character (e.g. !@#$%^&*)")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updatePasswordStatusView()
        layout()
        addKeyboardDismissGesture()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        // Calculate the bottom of the active field (like textField or button)
        if let activeField = getCurrentResponder(in: self.view),  // Custom method to get current UITextField
           let fieldFrameInView = activeField.superview?.convert(activeField.frame, to: view) {
            
            let fieldBottomY = fieldFrameInView.maxY
            
            if fieldBottomY > keyboardFrame.origin.y {
                // The field is hidden under the keyboard, move the view
                let overlap = -(fieldBottomY - keyboardFrame.origin.y / 1.5)
                view.frame.origin.y = overlap
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        // Reset to original position
        view.frame.origin.y = 0
    }
    
    func getCurrentResponder(in view: UIView) -> UIView? {
        for subview in view.subviews {
            if subview.isFirstResponder {
                return subview
            }
            if let responder = getCurrentResponder(in: subview) {
                return responder
            }
        }
        return nil
    }

    
}

extension PasswordValidationViewController {
    
    private func layout() {
        
        noSpaceLabelView.translatesAutoresizingMaskIntoConstraints = false
        upperCaseLabelView.translatesAutoresizingMaskIntoConstraints = false
        lowerCaseLabelView.translatesAutoresizingMaskIntoConstraints = false
        digitLabelView.translatesAutoresizingMaskIntoConstraints = false
        specialCharLabelView.translatesAutoresizingMaskIntoConstraints = false
        
        passwordStackView.addArrangedSubviews( [newPasswordFieldView,
                                                passwordCriteriaStackView,
                                                reEnterPasswordFieldView,
                                                resetButton
                                               ] )
        
        view.addSubview(passwordStackView)
        
        NSLayoutConstraint.activate([
            passwordStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            passwordStackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            passwordStackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    private func setupNewPassword() {
        let newPasswordValidation: CustomValidation = { text in
            
            // Empty text
            guard let text = text, !text.isEmpty else {
                //self.statusView.reset()
                return (false, "Enter your password")
            }
            
            // Valid characters
            let validChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,@:?!()$\\/#"
            let invalidSet = CharacterSet(charactersIn: validChars).inverted
            guard text.rangeOfCharacter(from: invalidSet) == nil else {
                //self.statusView.reset()
                return (false, "Enter valid special chars (.,@:?!()$\\/#) with no spaces")
            }

            // Criteria met
          //  self.statusView.updateDisplay(text)
//            if !self.statusView.validate(text) {
//                return (false, "Your password must meet the requirements below")
//            }

            return (true, "")
        }
        
        newPasswordFieldView.customValidation = newPasswordValidation
    }
    
    private func setupConfirmPassword() {
        let confirmPasswordValidation: CustomValidation = { text in
            guard let text = text, !text.isEmpty else {
                return (false, "Enter your password.")
            }

            guard text == self.newPasswordFieldView.text else {
                return (false, "Passwords do not match.")
            }

            return (true, "")
        }

        reEnterPasswordFieldView.customValidation = confirmPasswordValidation
        reEnterPasswordFieldView.passwordtextField.delegate = self
    }
}


extension UIStackView {
    /// Adds an array of views to the arrangedSubviews
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { self.addArrangedSubview($0) }
    }
}


//Closure callback
extension PasswordValidationViewController {
    
    func updatePasswordStatusView() {
        
        newPasswordFieldView.onTextChange  = { [weak self] textField in
            
            guard let self = self else { return }
            if textField == newPasswordFieldView.passwordtextField {
               textField.text!.count == 0 ?  resetCriteriaView() : validate(password: textField.text!)
               
            }
        }
        
        
        newPasswordFieldView.onTextEditingDidEnd = { [weak self] textField in
            guard let self = self else { return }
        }
    }
    
    func validate(password: String) {
        
        noSpaceLabelView.updateCriteriaImage(isValid: PasswordCriteriaCheck.checkLengthAndWhitespace(password))
        upperCaseLabelView.updateCriteriaImage(isValid: PasswordCriteriaCheck.containsUppercase(password))
        lowerCaseLabelView.updateCriteriaImage(isValid: PasswordCriteriaCheck.containsLowercase(password))
        digitLabelView.updateCriteriaImage(isValid: PasswordCriteriaCheck.containsDigit(password))
        specialCharLabelView.updateCriteriaImage(isValid: PasswordCriteriaCheck.containsSpecialCharacter(password))
    }
    
    func resetCriteriaView() {
        noSpaceLabelView.resetCriteriaView()
        upperCaseLabelView.resetCriteriaView()
        lowerCaseLabelView.resetCriteriaView()
        digitLabelView.resetCriteriaView()
        specialCharLabelView.resetCriteriaView()
    }
}



//To dismiss a keyboard when tapped
extension UIViewController {
    func addKeyboardDismissGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
