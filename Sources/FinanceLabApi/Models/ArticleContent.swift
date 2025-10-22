//
//  ArticleContent.swift
//  FinanceLabApi
//
//  Created by Anne Ferret on 22/10/2025.
//

import Vapor
import Fluent

final class ArticleContent: Model, Content, @unchecked Sendable {
    static let schema = "article_content"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "order_placement")
    var orderPlacement: Int
    
    @Field(key: "type")
    var type: String
    
    @Field(key: "content")
    var content: String
    
    @Parent(key: "id_article")
    var article: Article
    
    // Constructeur vide (requis par Fluent)
    init() {}
    
    init(
        id: UUID? = nil,
        orderPlacement: Int,
        type: String,
        content: String,
        articleID: Article.IDValue,
    ) {
        self.id = id
        self.orderPlacement = orderPlacement
        self.type = type
        self.content = content
        self.$article.id = articleID
    }
}
