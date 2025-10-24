//
//  File.swift
//  FinanceLabApi
//
//  Created by Sébastien DAGUIN on 14/10/2025.
//

import Vapor
import Fluent

struct AnswerController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let answers = routes.grouped("answers")
        //answers.get(use: index)
        let protectedRoutes = answers.grouped(JWTMiddleware())
        protectedRoutes.post(use: create)
        protectedRoutes.get(":answerID", use: getById)
        protectedRoutes.delete(":answerID", use: delete)
        protectedRoutes.put(":answerID", use: update)
        protectedRoutes.get(use: getByUserID)
    }

    func index(req: Request) async throws -> [Answer] {
        
        try await Answer.query(on: req.db).all()
    }

    @Sendable
    func create(req: Request) async throws -> Answer {
        let payload = try req.auth.require(UserPayload.self)
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound, reason: "Utilisateur introuvable")
        }
        
        let dto = try req.content.decode(AnswerDTO.self)
        
        // Create the actual Project model
        let answer = Answer()
        answer.content = dto.content
        answer.$user.id = try user.requireID()
        answer.$question.id = dto.idQuestion
        
        try await answer.save(on: req.db)
        
        return answer
    }
    
    func getById(req: Request) async throws -> Project {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        guard let project = try await Project.find(req.parameters.get("projectID"), on: req.db) else {
            throw Abort(.notFound, reason: "Project not found")
        }
        project.$user.id = try user.requireID()
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
        let input = try req.content.decode(ProjectDTO.self)
        // Preserve the existing identifier to ensure we update the correct record
        existing.name = input.name
        existing.iconName = input.iconName
        existing.endDate = input.endDate
        existing.amountSaved = input.amountSaved
        existing.amountTotal = input.amountTotal
        existing.$user.id = input.idUser

        try await existing.save(on: req.db)
        return existing
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
