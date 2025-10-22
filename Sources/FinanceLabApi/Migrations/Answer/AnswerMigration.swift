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
        try await database.schema("user_answer")
            .id()
            .field("content", .string, .required)
        //        MARK: FOREIGN KEY
            .field("id_user", .uuid, .required)
            .foreignKey("id_user", references: "users", "id", onDelete: .cascade)
            .field("id_question", .uuid, .required)
            .foreignKey("id_question", references: "questions", "id", onDelete: .cascade)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("user_answer").delete()
    }
}
