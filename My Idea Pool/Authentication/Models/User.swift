//
//  NewUser.swift
//  My Idea Pool
//
//  Created by Franco on 2019-10-30.
//  Copyright © 2019 Franco Fantillo. All rights reserved.
//

import Foundation

struct User: Encodable {
    
    let name: String?
    let email: String
    let password: String
    
    init(name: String?, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
}
