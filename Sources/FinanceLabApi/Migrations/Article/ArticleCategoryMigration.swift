//
//  ArticleGroupMigration.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 17/10/2025.
//

import Fluent

struct ArticleCategoryMigration: AsyncMigration {
    
    func prepare(on database: any Database) async throws {
        try await database.schema("article_category")
            .id()
            .field("title", .string, .required)
            .field("icon", .string, .required)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("article_category").delete()
    }
}
