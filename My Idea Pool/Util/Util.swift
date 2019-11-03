//
//  Util.swift
//  My Idea Pool
//
//  Created by Franco on 2019-11-02.
//  Copyright © 2019 Franco Fantillo. All rights reserved.
//

import Foundation

class Util  {
    
    static func getEncodedRefreshToken(tokenString: String) -> Data?{
        let refreshToken = AuthenticationTokens(refresh_token: tokenString)
        var encodedRefreshToken: Data!
        do { encodedRefreshToken = try JSONEncoder().encode(refreshToken) }
        catch { fatalError("Could not encode") }
        return encodedRefreshToken
    }
}
