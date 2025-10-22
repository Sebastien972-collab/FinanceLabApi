//
//  QuestionMigration.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 17/10/2025.
//

import Fluent

struct QuestionMigration: AsyncMigration {
    
    func prepare(on database: any Database) async throws {
        try await database.schema("questions")
            .id()
            .field("content", .string, .required)
        //        MARK: FOREIGN KEY
            .field("id_question_group", .uuid, .required)
            .foreignKey("id_question_group", references: "question_group", "id", onDelete: .cascade)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("questions").delete()
    }
}
