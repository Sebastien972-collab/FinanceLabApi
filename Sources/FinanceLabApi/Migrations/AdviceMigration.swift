//
//  AdviceMigration.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 17/10/2025.
//

import Fluent

struct AdviceMigration: AsyncMigration {
    
    func prepare(on database: any Database) async throws {
        try await database.schema("advice")
            .id()
            .field("content", .string, .required)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("advice").delete()
    }
}
