//
//  Advice.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 17/10/2025.
//

import Vapor
import Fluent

final class Advice: Model, Content, @unchecked Sendable {
    static let schema = "advices"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "content")
    var content: String
    
    // Constructeur vide (requis par Fluent)
    init() { }
    
    init(id: UUID?, content: String) {
        self.id = id
        self.content = content
    }
    
}
