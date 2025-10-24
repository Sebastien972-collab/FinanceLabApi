//
//  QuestionController.swift
//  FinanceLabApi
//
//  Created by Anne Ferret on 24/10/2025.
//

import Vapor
import Fluent

struct QuestionController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let questions = routes.grouped("questions")
        //questions.get(use: index)
        let protectedRoutes = questions.grouped(JWTMiddleware())
        protectedRoutes.post(use: create)
        protectedRoutes.get(":questionID", use: getById)
        protectedRoutes.delete(":questionID", use: delete)
        protectedRoutes.put(":questionID", use: update)
    }

    func index(req: Request) async throws -> [Question] {
        try await Question.query(on: req.db).all()
    }

    @Sendable
    func create(req: Request) async throws -> Question {
        let payload = try req.auth.require(UserPayload.self)
        
        let dto = try req.content.decode(QuestionDTO.self)
        
        // Create the actual Question model
        let question = Question()
        question.label = dto.label
        question.content = dto.content
        question.followUpLabel = dto.followUpLabel
        question.questionGroup = dto.questionGroup
        
        try await question.save(on: req.db)
        
        return question
    }
    
    func getById(req: Request) async throws -> Question {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        guard let question = try await Question.find(req.parameters.get("questionID"), on: req.db) else {
            throw Abort(.notFound, reason: "Project not found")
        }
        try await question.save(on: req.db)
        
        return question
    }

    func delete(req: Request) async throws -> HTTPStatus {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        guard let question = try await Question.find(req.parameters.get("questionID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await question.delete(on: req.db)
        return .noContent
    }

    func update(req: Request) async throws -> Question {
        guard let existing = try await Question.find(req.parameters.get("questionID"), on: req.db) else {
            throw Abort(.notFound, reason: "Question not found")
        }
        let dto = try req.content.decode(QuestionDTO.self)
        // Preserve the existing identifier to ensure we update the correct record
        existing.label = dto.label
        existing.content = dto.content
        existing.followUpLabel = dto.followUpLabel
        existing.questionGroup = dto.questionGroup

        try await existing.save(on: req.db)
        return existing
    }
    
}
