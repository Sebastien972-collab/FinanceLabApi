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
    let idQuestionGroup: QuestionGroupDTO
    
    init(from question: Question, questionGroup: QuestionGroup) throws {
        self.id = try question.requireID()
        self.content = question.content
        self.idQuestionGroup = try QuestionGroupDTO(from: questionGroup)
    }
}
