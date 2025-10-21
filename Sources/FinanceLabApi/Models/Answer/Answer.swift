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
    
    @Field(key: "id_user")
    var idUser: UUID?

    @Field(key: "id_question")
    var idQuestion: UUID

    // Constructeur vide (requis par Fluent)
    init() {}
    
    init(id: UUID? = nil, content: String, idUser: UUID? = nil, idQuestion: UUID) {
        self.id = id
        self.content = content
        self.idUser = idUser
        self.idQuestion = idQuestion
    }
}
