//
//  File.swift
//  FinanceLabApi
//
//  Created by Sébastien DAGUIN on 13/10/2025.
//

import Fluent

struct : AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("projects")
            .id()
            .field("name", .string, .required)
            .field("goal_amount", .double, .required)
            .field("amount_saved", .double, .required, .sql(.default(0.0)))
            .field("final_date", .date, .required)
            .field("current_image", .string)
            .field("status", .string, .required, .sql(.default("en_cours")))
            .field("id_user", .uuid, .required)
            .foreignKey("id_user", references: "users", "id", onDelete: .cascade)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("projects").delete()
    }
}
