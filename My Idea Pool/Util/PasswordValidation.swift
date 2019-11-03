//
//  PasswordValidation.swift
//  My Idea Pool
//
//  Created by Franco on 2019-10-30.
//  Copyright © 2019 Franco Fantillo. All rights reserved.
//

import Foundation


enum EvaluatePasswordError: Error {
    case isEmpty
}

enum PasswordStrings: String {
    case baseErrorMsg = "Password requires at least "
}

struct Password {
    private var string: String

    init(_ string: String) throws {
        try PasswordValidations.password(string)
        self.string = string
    }

    func passwordString() -> String {
        return string
    }
}

struct PasswordValidations  {
    
    static func password(_ string: String) throws {
        if string.isEmpty == true {
            throw EvaluatePasswordError.isEmpty
        }
        
        let errorMsg = validatePassword(password: string)
        if errorMsg != PasswordStrings.baseErrorMsg.rawValue { throw errorMsg }
    }

    private static func validatePassword(password: String) -> String {
        var errorMsg = PasswordStrings.baseErrorMsg.rawValue


        if (password.rangeOfCharacter(from: CharacterSet.uppercaseLetters) == nil) {
            errorMsg += "one upper case letter"
        }
        if (password.rangeOfCharacter(from: CharacterSet.lowercaseLetters) == nil) {
            errorMsg += ", one lower case letter"
        }
        if (password.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil) {
            errorMsg += ", one number"
        }
        if password.count < 8 {
            errorMsg += ", and be at least eight characters long."
        }
        return errorMsg
    }
}


