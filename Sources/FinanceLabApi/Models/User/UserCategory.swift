//
//  UserCategory.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 16/10/2025.
//

import Vapor
import Fluent

final class UserCategory: Model, Content, @unchecked Sendable {
    static let schema = "user_category" // Nom de la table MySQL
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    // Constructeur vide (requis par Fluent)
    init() {}
    
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
