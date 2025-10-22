//
//  TransactionCategoryMigration.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 16/10/2025.
//

import Fluent

struct TransactionCategoryMigration: AsyncMigration {
    
    func prepare(on database: any Database) async throws {
        try await database.schema("transaction_category")
            .id()
            .field("name", .string, .required)
            .field("icon", .string, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("transaction_category").delete()
    }
    
}
