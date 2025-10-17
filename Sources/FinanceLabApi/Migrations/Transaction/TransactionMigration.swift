//
//  TransactionMigration.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 16/10/2025.
//

import Fluent

struct TransactionMigration: AsyncMigration {
    
    func prepare(on database: any Database) async throws {
        try await database.schema("transaction")
            .id()
            .field("name", .string, .required)
            .field("amount", .double, .required)
            .field("date", .datetime, .required)
            .field("contractor", .string, .required)
            .field("id_transaction_category", .uuid, .required)
            .field("id_user", .uuid, .required)
            .create()
        
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("transaction").delete()
    }
    
}
