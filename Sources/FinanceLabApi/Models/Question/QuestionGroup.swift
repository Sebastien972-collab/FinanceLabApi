//
//  QuestionGroup.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 17/10/2025.
//

import Vapor
import Fluent

final class QuestionGroup: Model, Content, @unchecked Sendable {
    static let schema = "question_group"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "icon")
    var icon: String
    
    // Constructeur vide (Requis par Fluent)
    init() { }
    
    init(id: UUID? = nil, title: String, icon: String) {
        self.id = id
        self.title = title
        self.icon = icon
    }
}
