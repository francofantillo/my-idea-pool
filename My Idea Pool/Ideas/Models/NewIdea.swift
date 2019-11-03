//
//  NewIdea.swift
//  My Idea Pool
//
//  Created by Franco on 2019-10-31.
//  Copyright © 2019 Franco Fantillo. All rights reserved.
//

import Foundation

struct NewIdea: Encodable {
    
    let content: String
    let impact: String
    let ease: String
    let confidence: String
    
    init(content: String, impact: String, ease: String, confidence: String) {
        self.content = content
        self.impact = impact
        self.ease = ease
        self.confidence = confidence
    }
}
