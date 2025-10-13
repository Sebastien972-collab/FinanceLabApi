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
            .field("first_name", .string)
            .field("last_name", .string)
            .field("email", .string, .required)
            .field("date_of_registration", .datetime, .required)
            .field("password", .string, .required)
            .field("profile_picture", .uuid)
            .unique(on: "email")
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("users").delete()
    }
}
