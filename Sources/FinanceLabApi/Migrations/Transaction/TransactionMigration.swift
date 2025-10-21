//
//  TransactionMigration.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 16/10/2025.
//

import Fluent

struct TransactionMigration: AsyncMigration {
    
    func prepare(on database: any Database) async throws {
        try await database.schema("transactions")
            .id()
            .field("name", .string, .required)
            .field("amount", .double, .required)
            .field("date", .datetime, .required)
            .field("contractor", .string, .required)
//        MARK: - FOREIGN KEY
            .field("id_transaction_category", .uuid, .required)
            .foreignKey("id_transaction_category", references: "transaction_category", "id", onDelete: .cascade)
            .field("id_user", .uuid, .required)
            .foreignKey("id_user", references: "users", "id", onDelete: .cascade)
            .create()
        
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("transactions").delete()
    }
    
}
