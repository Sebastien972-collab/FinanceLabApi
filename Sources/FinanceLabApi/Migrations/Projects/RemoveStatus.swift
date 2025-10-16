//
//  File.swift
//  FinanceLabApi
//
//  Created by Sébastien DAGUIN on 13/10/2025.
//

import Fluent

struct RemoveStatusFromProject: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("projects")
            .deleteField("status")
            .update()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("projects")
            .field("status", .string, .required, .sql(.default("en_cours")))
            .update()
    }
}
