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
    
    init(id: UUID? = nil,
         title: String,
         image: String,
         creationDate: Date?,
         articleCategory: String
    ){
        self.id = id
        self.title = title
        self.image = image
        self.creationDate = creationDate
        self.articleCategory = articleCategory
    }
}
