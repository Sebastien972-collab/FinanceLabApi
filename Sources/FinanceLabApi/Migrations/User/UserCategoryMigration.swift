//
//  UserCategoryMigration.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 16/10/2025.
//

import Fluent

struct UserCategoryMigration: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("user_category")
            .id()
            .field("name", .string)
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("user_category").delete()
    }
}
