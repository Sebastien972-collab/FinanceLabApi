//
//  ArticleGroupDTO.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 17/10/2025.
//

import Vapor

struct ArticleGroupDTO: Content {
    
    let id: UUID?
    let name: String
    let icon: String
    
    init(from articleGroup: ArticleGroup) throws {
        self.id = try articleGroup.requireID()
        self.name = articleGroup.name
        self.icon = articleGroup.icon
    }
}
