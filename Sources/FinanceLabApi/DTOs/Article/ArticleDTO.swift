//
//  ArticleDTO.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 17/10/2025.
//

import Vapor

struct ArticleDTO: Content {
    
    let id: UUID?
    let title: String
    let image: String
    let creationDate: Date?
    let content: String
    let idArticleCategory: UUID
    
    init(from article: Article) throws {
        self.id = try article.requireID()
        self.title = article.title
        self.image = article.image
        self.creationDate = article.creationDate
        self.content = article.content
        self.idArticleCategory = article.idArticleCategory
    }
}
