//
//  Idea.swift
//  My Idea Pool
//
//  Created by Franco on 2019-10-31.
//  Copyright © 2019 Franco Fantillo. All rights reserved.
//

import Foundation

struct Idea: Encodable {
    
    let id : String
    let content : String
    let impact : Int
    let ease : Int
    let confidence : Int
    let average_score: Double
    let created_at: Double
    
    init(id: String, content: String, impact: Int, ease: Int, confidence: Int, average_score: Double, created_at: Double) {
        
        self.id = id
        self.content = content
        self.impact = impact
        self.ease = ease
        self.confidence = confidence
        self.average_score = average_score
        self.created_at = created_at
    }
}

extension Idea: Decodable {
    enum IdeaKeys: String, CodingKey {
        case id = "id"
        case content = "content"
        case impact = "impact"
        case ease = "ease"
        case confidence = "confidence"
        case average_score = "average_score"
        case created_at = "created_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: IdeaKeys.self) // defining our (keyed) container
        let id: String = try container.decode(String.self, forKey: .id) // extracting the data
        let content: String = try container.decode(String.self, forKey: .content) // extracting the data
        let impact: Int = try container.decode(Int.self, forKey: .impact)
        let ease: Int = try container.decode(Int.self, forKey: .ease)
        let confidence: Int = try container.decode(Int.self, forKey: .confidence)
        let average_score: Double = try container.decode(Double.self, forKey: .average_score)
        let created_at: Double = try container.decode(Double.self, forKey: .created_at)
        
        self.init(id: id, content: content, impact: impact, ease: ease, confidence: confidence, average_score: average_score, created_at: created_at) // initializing our struct
    }
}
