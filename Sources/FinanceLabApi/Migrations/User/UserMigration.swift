//
//  CreateUser.swift
//  FinanceLabApi
//
//  Created by Anne Ferret on 13/10/2025.
//

import Fluent

struct UserMigration: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("users")
            .id()
            .field("first_name", .string)
            .field("last_name", .string)
            .field("email", .string, .required)
            .field("date_of_registration", .datetime, .required)
            .field("password", .string, .required)
        //        MARK: FOREIGN KEY
            .field("id_user_category", .uuid, .required)
            .foreignKey("id_user_category", references: "user_category", "id", onDelete: .cascade)
            .unique(on: "email")
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("users").delete()
    }
}
