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
    let userID: UserPublicDTO
    let questionID: QuestionDTO
    
    init(from answer: Answer, user: User, question: Question, questionGroup: QuestionGroup) throws {
        self.id = try answer.requireID()
        self.content = answer.content
        self.userID = try UserPublicDTO(from: user)
        self.questionID = try QuestionDTO(from: question, questionGroup: questionGroup)
    }
}
