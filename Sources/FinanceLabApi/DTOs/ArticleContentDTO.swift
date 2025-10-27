//
//  ArticleContentDTO.swift
//  FinanceLabApi
//
//  Created by Anne Ferret on 27/10/2025.
//

import Vapor

struct ArticleContentDTO: Content {
    let id: UUID?
    let orderPlacement: Int
    let type: String
    let content: String
    let idArticle: UUID
    
    init(
        id: UUID? = nil,
        orderPlacement: Int,
        type: String,
        content: String,
        idArticle: UUID
    ) {
        self.id = id
        self.orderPlacement = orderPlacement
        self.type = type
        self.content = content
        self.idArticle = idArticle
    }
}
