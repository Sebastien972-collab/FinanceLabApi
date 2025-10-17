//
//  DefinitionMigration.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 17/10/2025.
//

import Fluent

struct DefinitionMigration: AsyncMigration {
    
    func prepare(on database: any Database) async throws {
        try await database.schema("definition")
            .id()
            .field("name", .string, .required)
            .field("content", .string, .required)
            .create()
        
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("definition").delete()
    }
    
}
