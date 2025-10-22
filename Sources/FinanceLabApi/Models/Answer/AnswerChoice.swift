//
//  AnswerChoice.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 20/10/2025.
//

import Vapor
import Fluent

final class AnswerChoice: Model, Content, @unchecked Sendable {
    static let schema = "answer_choice"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "content")
    var content: String
    
    @Field(key: "id_question")
    var idQuestion: UUID
    
    
//    Constructeur vide (requis par Fluent)
    init() { }
    
    init(id: UUID? = nil, content: String, idQuestion: UUID) {
        self.id = id
        self.content = content
        self.idQuestion = idQuestion
    }
}
