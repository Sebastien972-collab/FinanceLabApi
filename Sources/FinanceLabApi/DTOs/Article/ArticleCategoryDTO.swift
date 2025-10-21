//
//  ArticleGroupDTO.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 17/10/2025.
//

import Vapor

struct ArticleCategoryDTO: Content {
    
    let id: UUID?
    let name: String
    let icon: String
    
    init(from articleCategory: ArticleCategory) throws {
        self.id = try articleCategory.requireID()
        self.name = articleCategory.name
        self.icon = articleCategory.icon
    }
}
