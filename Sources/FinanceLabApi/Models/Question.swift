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
    
    @Field(key: "label")
    var label: String
    
    @Field(key: "content")
    var content: String
    
    @Field(key: "follow_up_label")
    var followUpLabel: String?
    
    @Field(key: "question_group")
    var questionGroup: String
    
    @Children(for: \.$question)
    var answers: [Answer]
    
    // Constructeur vide (Requis par Fluent)
    init() { }
    
    init(
        id: UUID? = nil,
        label: String,
        content: String,
        followUpLabel: String? = nil,
        questionGroup: String
    ) {
        self.id = id
        self.label = label
        self.content = content
        self.followUpLabel = followUpLabel
        self.questionGroup = questionGroup
    }
}
