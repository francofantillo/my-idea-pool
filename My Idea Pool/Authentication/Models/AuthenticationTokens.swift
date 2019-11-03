//
//  AuthenticationToken.swift
//  My Idea Pool
//
//  Created by Franco on 2019-10-30.
//  Copyright © 2019 Franco Fantillo. All rights reserved.
//

import Foundation

struct AuthenticationTokens: Encodable {
    
    let jwt: String?
    let refresh_token: String?
    
    init(jwt: String?, refresh_token: String?) {
        self.jwt = jwt
        self.refresh_token = refresh_token
    }
    
    init(refresh_token: String) {
        self.refresh_token = refresh_token
        self.jwt = nil
    }
}

extension AuthenticationTokens: Decodable {
    enum TokenKeys: String, CodingKey {
        case jwt = "jwt"
        case refresh_token = "refresh_token"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TokenKeys.self) // defining our (keyed) container
        let jwt: String? = try container.decodeIfPresent(String.self, forKey: .jwt) // extracting the data
        let refresh_token: String? = try container.decodeIfPresent(String.self, forKey: .refresh_token) // extracting the data
        
        self.init(jwt: jwt, refresh_token: refresh_token) // initializing our struct
    }
}
