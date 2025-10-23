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
        //projects.get(use: index)
        let protectedRoutes = projects.grouped(JWTMiddleware())
        protectedRoutes.post(use: create)
        protectedRoutes.get(":projectID", use: getById)
        protectedRoutes.delete(":projectID", use: delete)
        protectedRoutes.put(":projectID", use: update)
        protectedRoutes.get(use: getByUserID)
    }

    func index(req: Request) async throws -> [Project] {
        
        try await Project.query(on: req.db).all()
    }

    @Sendable
    func create(req: Request) async throws -> Project {
        let payload = try req.auth.require(UserPayload.self)
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound, reason: "Utilisateur introuvable")
        }
        let project = try req.content.decode(Project.self)
        project.$user.id = try user.requireID()
        try await project.save(on: req.db)
        
        return project
    }

    func getById(req: Request) async throws -> Project {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        guard let project = try await Project.find(req.parameters.get("projectID"), on: req.db) else {
            throw Abort(.notFound, reason: "Project not found")
        }
        project.user.id = try user.requireID()
        try await project.save(on: req.db)
        
        return project
    }

    func delete(req: Request) async throws -> HTTPStatus {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        guard let project = try await Project.find(req.parameters.get("projectID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await project.delete(on: req.db)
        return .noContent
    }

    func update(req: Request) async throws -> Project {
        guard let existing = try await Project.find(req.parameters.get("projectID"), on: req.db) else {
            throw Abort(.notFound, reason: "Project not found")
        }
        let input = try req.content.decode(Project.self)
        // Preserve the existing identifier to ensure we update the correct record
        input.id = existing.id
        try await input.update(on: req.db)
        return input
    }
    func getByUserID(req: Request) async throws -> [Project] {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        guard let userUUID = user.id else {
            throw Abort(.badRequest, reason: "Invalid user ID format")
        }

        let projects = try await Project.query(on: req.db)
            .filter(\.$user.$id == userUUID)
            .all()

        if projects.isEmpty {
            throw Abort(.notFound, reason: "No projects found for this user")
        }

        return projects
    }
}
