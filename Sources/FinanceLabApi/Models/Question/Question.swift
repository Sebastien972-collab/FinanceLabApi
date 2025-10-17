//
//  Question.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 17/10/2025.
//

import Vapor
import Fluent

final class Question: Model, Content, @unchecked Sendable {
    static let schema = "question"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "content")
    var content: String
    
    @Field(key: "multiple_choice")
    var multipleChoice: Bool
    
    @Field(key: "id_question_group")
    var idQuestionGroup: UUID
    
    
    // Constructeur vide (Requis par Fluent)
    init() { }
    
    init(id: UUID? = nil, content: String, multipleChoice: Bool, idQuestionGroup: UUID) {
        self.id = id
        self.content = content
        self.multipleChoice = multipleChoice
        self.idQuestionGroup = idQuestionGroup
    }
}
