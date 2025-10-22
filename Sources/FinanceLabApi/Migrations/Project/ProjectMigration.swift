//
//  File.swift
//  FinanceLabApi
//
//  Created by Sébastien DAGUIN on 13/10/2025.
//

import Fluent

struct ProjectMigration: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("projects")
            .id()
            .field("name", .string, .required)
            .field("icon", .string, .required)
            .field("creation_date", .date, .required)
            .field("final_date", .date, .required)
            .field("amount_monthly", .double, .required)
            .field("amount_saved", .double, .required, .sql(.default(0.0)))
            .field("amount_total", .double, .required)
            .field("status", .string, .required, .sql(.default("en_cours"))) // Voir avec Seb
        //        MARK: FOREIGN KEY
            .field("id_user", .uuid, .required)
            .foreignKey("id_user", references: "users", "id", onDelete: .cascade)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("projects").delete()
    }
}
