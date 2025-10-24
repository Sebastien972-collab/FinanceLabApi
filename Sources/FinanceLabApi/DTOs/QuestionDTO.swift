//
//  QuestionDTO.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 17/10/2025.
//

import Vapor

struct QuestionDTO: Content {
    
    let id: UUID?
    let label: String
    let content: String
    let followUpLabel: String?
    let questionGroup: String
    
    init(from question: Question) throws {
        self.id = try question.requireID()
        self.label = question.label
        self.content = question.content
        self.followUpLabel = question.followUpLabel
        self.questionGroup = question.questionGroup
    }
}
