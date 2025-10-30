//
//  File.swift
//  FinanceLabApi
//
//  Created by Sébastien DAGUIN on 14/10/2025.
//

import Vapor
import Fluent


final class Answer: Model, Content, @unchecked Sendable {
    static let schema = "user_answer"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "content")
    var content: String
    
    @Parent(key: "id_user")
    var user: User
    
    @Parent(key: "id_question")
    var question: Question
    
    // Constructeur vide (requis par Fluent)
    init() {}
    
    init(
        id: UUID? = nil,
        content: String,
        userID: User.IDValue,
        questionID: Question.IDValue
    ) {
        self.id = id
        self.content = content
        self.$user.id = userID
        self.$question.id = questionID
    }
    func toDto() -> AnswerDTO {
        AnswerDTO(id: self.id, content: self.content, idQuestion: self.question.id ?? .init())
    }
}
