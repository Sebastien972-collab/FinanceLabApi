//
//  AswerMigration.swift
//  FinanceLabApi
//
//  Created by Sébastien DAGUIN on 14/10/2025.
//

import Foundation
import Fluent

/// Migration to create the `answers` table
struct AnswerMigration: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("answers")
            .id()
            .field("content", .string, .required)
            .field("user_id", .uuid, .required, .references("projects", "id", onDelete: .cascade))
            .unique(on: "id")
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("answers").delete()
    }
}
