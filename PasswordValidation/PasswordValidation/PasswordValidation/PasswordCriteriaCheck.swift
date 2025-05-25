//
//  PasswordCriteriaCheck.swift
//  PasswordValidation
//
//  Created by Arunkumar on 25/05/25.
//

import UIKit


struct PasswordCriteriaCheck {
    
    static func checkLengthAndWhitespace(_ password: String) -> Bool {
        let regex = #"^[^\s]{8,32}$"#
        return password.range(of: regex, options: .regularExpression) != nil
    }
    
    static func containsUppercase(_ text: String) -> Bool {
         return text.range(of: "[A-Z]", options: .regularExpression) != nil
     }

     static func containsLowercase(_ text: String) -> Bool {
         return text.range(of: "[a-z]", options: .regularExpression) != nil
     }

     static func containsDigit(_ text: String) -> Bool {
         return text.range(of: "[0-9]", options: .regularExpression) != nil
     }

     static func containsSpecialCharacter(_ text: String) -> Bool {
         return text.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil
     }
}
