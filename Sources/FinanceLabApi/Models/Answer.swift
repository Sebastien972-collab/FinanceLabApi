//
//  File.swift
//  FinanceLabApi
//
//  Created by Sébastien DAGUIN on 14/10/2025.
//

import Vapor
import Fluent


final class Answer: Model, Content, @unchecked Sendable {
    static let schema = "answer"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "user_id")
    var userID: UUID

    @Field(key: "content")
    var content: UUID

    @Field(key: "#id_question")
    var questionID: UUID

    // Constructeur vide (requis par Fluent)
    init() {}
    
    init(id: UUID, userID: UUID, questionID: UUID) {
        self.id = id
        self.userID = userID
        self.questionID = questionID
    }
}
