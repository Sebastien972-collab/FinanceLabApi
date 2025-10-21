//
//  AnswerChoiceDTO.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 20/10/2025.
//

import Vapor

struct AnswerChoiceDTO: Content {
    let id: UUID?
    let content: String
    let idQuestion: QuestionDTO
    
    init(from answerChoice: AnswerChoice, question: Question, questionGroup: QuestionGroup) throws {
        self.id = try answerChoice.requireID()
        self.content = answerChoice.content
        self.idQuestion = try QuestionDTO(from: question, questionGroup: questionGroup)
    }
}
