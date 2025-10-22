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
    
    init(from definition: Definition) throws {
        self.id = try definition.requireID()
        self.name = definition.name
        self.content = definition.content
        
    }
}
