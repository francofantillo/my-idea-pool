//
//  File.swift
//  My Idea Pool
//
//  Created by Franco on 2019-10-30.
//  Copyright © 2019 Franco Fantillo. All rights reserved.
//

import Foundation

public enum Endpoints : String {
    case host = "https://small-project-api.herokuapp.com"
    case signUp = "/users"                                  // POST
    case logInOut = "/access-tokens"                        // POST for login.  DELETE for logout.
    case getUser = "/me"                                    // GET
    case refresh = "/access-tokens/refresh"                 // POST
    case newIdea = "/ideas"                                 // POST
    case getIdeas = "/ideas?page=1"                         // GET
    case removeOrEditIdea = "/ideas/"                       // PUT for Update.      //DELETE for delete.   ex. /ideas/tg2b9xuyy
}
