//
//  ArticleMigration.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 17/10/2025.
//

import Fluent

struct ArticleMigration: AsyncMigration {
    
    func prepare(on database: any Database) async throws {
        try await database.schema("article")
            .id()
            .field("title", .string, .required)
            .field("image", .string, .required)
            .field("creation_date", .datetime, .required)
            .field("content", .string, .required)
            .field("id_article_category", .uuid, .required)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("article").delete()
    }
}
