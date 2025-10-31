//
//  DefinitionDTO.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 17/10/2025.
//

import Vapor

struct DefinitionDTO: Content {
    
    let id: UUID?
    let name: String
    let content: String
    
    init(id: UUID? = nil, name: String, content: String) {
        self.id = id
        self.name = name
        self.content = content
    }
}
