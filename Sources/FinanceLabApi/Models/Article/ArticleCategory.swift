//
//  ArticleGroup.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 17/10/2025.
//

import Vapor
import Fluent

final class ArticleCategory: Model, Content, @unchecked Sendable {
    
    static let schema = "article_category"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "icon")
    var icon: String
    
    // Constructeur vide (requis par Fluent)
    init() { }
    
    init(id: UUID? = nil, name: String, icon: String) {
        self.id = id
        self.name = name
        self.icon = icon
    }
}
