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
    let idQuestion: UUID
    
    init(id: UUID? = nil, content: String, idQuestion: UUID) {
        self.id = id
        self.content = content
        self.idQuestion = idQuestion
    }
}
