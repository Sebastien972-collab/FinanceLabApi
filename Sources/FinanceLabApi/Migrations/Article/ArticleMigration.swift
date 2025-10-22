//
//  ArticleMigration.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 17/10/2025.
//

import Fluent

struct ArticleMigration: AsyncMigration {
    
    func prepare(on database: any Database) async throws {
        try await database.schema("articles")
            .id()
            .field("title", .string, .required)
            .field("image", .string, .required)
            .field("creation_date", .datetime, .required)
            .field("content", .string, .required)
        //        MARK: FOREIGN KEY
            .field("id_article_category", .uuid, .required)
            .foreignKey("id_article_category", references: "article_category", "id", onDelete: .cascade)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("articles").delete()
    }
}
