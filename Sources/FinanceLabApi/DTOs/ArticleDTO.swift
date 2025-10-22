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
    let articleCategory: String
    let articleContents: [ArticleContent]
    
    init(from article: Article) throws {
        self.id = try article.requireID()
        self.title = article.title
        self.image = article.image
        self.creationDate = article.creationDate
        self.articleCategory = article.articleCategory
        self.articleContents = article.articleContents
    }
    
}
