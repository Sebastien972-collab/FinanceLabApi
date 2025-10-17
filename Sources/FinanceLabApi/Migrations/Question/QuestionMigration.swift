//
//  QuestionMigration.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 17/10/2025.
//

import Fluent

struct QuestionMigration: AsyncMigration {
    
    func prepare(on database: any Database) async throws {
        try await database.schema("question")
            .id()
            .field("content", .string, .required)
            .field("multiple_choice", .bool, .required)
            .field("id_question_group", .uuid, .required)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("question").delete()
    }
}
