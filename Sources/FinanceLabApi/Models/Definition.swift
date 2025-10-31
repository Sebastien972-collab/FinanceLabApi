//
//  Definition.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 17/10/2025.
//

import Vapor
import Fluent

final class Definition: Model, Content, @unchecked Sendable  {
    static let schema = "definition"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "content")
    var content: String
    
    // Constructeur vide (requis par Fluent)
    init() { }
    
    func toDefinitionDTO() -> DefinitionDTO {
        DefinitionDTO(
            id: id,
            name: name,
            content: content
        )
    }
    
    init(
        id: UUID? = nil,
        name: String,
        content: String
    ) {
        self.id = id
        self.name = name
        self.content = content
    }

}
