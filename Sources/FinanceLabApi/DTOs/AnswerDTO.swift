//
//  AnswerDTO.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 17/10/2025.
//

import Vapor

struct AnswerDTO: Content {
    let id: UUID?
    let content: String
    
    init(from advice: Advice) throws {
        self.id = try advice.requireID()
        self.content = advice.content
    }
}
