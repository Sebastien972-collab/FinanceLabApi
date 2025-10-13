//
//  CreateUser.swift
//  FinanceLabApi
//
//  Created by Anne Ferret on 13/10/2025.
//

import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("users")
            .id()
            .field("email", .string, .required)
            .unique(on: "email")
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("users").delete()
    }
}
