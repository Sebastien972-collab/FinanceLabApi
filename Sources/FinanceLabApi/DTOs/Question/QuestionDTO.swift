//
//  QuestionDTO.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 17/10/2025.
//

import Vapor

struct QuestionDTO: Content {
    
    let id: UUID?
    let content: String
    let multipleChoice: Bool
    let idQuestionGroup: UUID
    
    init(from question: Question) throws {
        self.id = try question.requireID()
        self.content = question.content
        self.multipleChoice = question.multipleChoice
        self.idQuestionGroup = question.idQuestionGroup
    }
}
