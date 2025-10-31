//
//  Article.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 17/10/2025.
//

import Vapor
import Fluent

final class Article: Model, Content, @unchecked Sendable {
    
    static let schema = "article"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "image")
    var image: String
    
    @Timestamp(key: "creation_date", on: .create)
    var creationDate: Date?
    
    @Field(key: "article_category")
    var articleCategory: String
    
    @Children(for: \.$article)
    var articleContents: [ArticleContent]
    
    // Constructeur vide (requis par Fluent)
    init() { }
    
    init(
        id: UUID? = nil,
        title: String,
        image: String,
        creationDate: Date? = nil,
        articleCategory: String
    ) {
        self.id = id
        self.title = title
        self.image = image
        self.creationDate = creationDate
        self.articleCategory = articleCategory
    }
    
    func toArticleDTO() -> ArticleDTO {
        ArticleDTO(id: id,
                   title: title,
                   image: image,
                   creationDate: creationDate,
                   articleCategory: articleCategory)
        
    }
}
