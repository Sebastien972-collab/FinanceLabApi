//
//  AnswerChoiceMigration.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 20/10/2025.
//

import Fluent

struct AnswerChoiceMigration: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("answer_choice")
            .id()
            .field("content", .string)
        //        MARK: FOREIGN KEY
            .field("idQuestion", .uuid)
            .foreignKey("idQuestion", references: "questions", "id", onDelete: .cascade)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("answer_choice").delete()
    }
}
