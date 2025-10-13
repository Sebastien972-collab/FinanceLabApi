//
//  File.swift
//  FinanceLabApi
//
//  Created by Sébastien DAGUIN on 13/10/2025.
//

import Vapor
import Fluent

struct ProjectController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let projects = routes.grouped("projects")
        projects.get(use: index)
        projects.post(use: create)
        projects.get(":projectID", use: getById)
        projects.delete(":projectID", use: delete)
    }

    func index(req: Request) async throws -> [Project] {
        try await Project.query(on: req.db).all()
    }

    func create(req: Request) async throws -> Project {
        let project = try req.content.decode(Project.self)
        try await project.save(on: req.db)
        return project
    }

    func getById(req: Request) async throws -> Project {
        guard let project = try await Project.find(req.parameters.get("projectID"), on: req.db) else {
            throw Abort(.notFound, reason: "Project not found")
        }
        return project
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let project = try await Project.find(req.parameters.get("projectID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await project.delete(on: req.db)
        return .noContent
    }
}
