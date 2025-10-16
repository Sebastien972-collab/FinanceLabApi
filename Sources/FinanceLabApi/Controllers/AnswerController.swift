//
//  File.swift
//  FinanceLabApi
//
//  Created by Sébastien DAGUIN on 14/10/2025.
//

import Vapor
import Fluent

struct AnswerController: RouteCollection {
    func boot(routes: any Vapor.RoutesBuilder) throws {
        let answers = routes.grouped("answers")
        answers.get(use: index)
        answers.post(use: create)
        answers.get(":answersID", use: getById)
        answers.delete(":answersID", use: delete)
        answers.put(":answersID", use: update)
        
    }
    
    func index(req: Request) async throws -> [Answer] {
        try await Answer.query(on: req.db).all()
    }
    
    func create(req: Request) async throws -> Answer {
        let answer = try req.content.decode(Answer.self)
        try await answer.save(on: req.db)
        return answer
    }

    func getById(req: Request) async throws -> Answer {
        guard let project = try await Answer.find(req.parameters.get("answerID"), on: req.db) else {
            throw Abort(.notFound, reason: "Project not found")
        }
        return project
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let project = try await Answer.find(req.parameters.get("answerID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await project.delete(on: req.db)
        return .noContent
    }

    func update(req: Request) async throws -> Answer {
        guard let existing = try await Project.find(req.parameters.get("answerID"), on: req.db) else {
            throw Abort(.notFound, reason: "Aswer not found")
        }
        let input = try req.content.decode(Answer.self)
        // Preserve the existing identifier to ensure we update the correct record
        input.id = existing.id
        try await input.update(on: req.db)
        return input
    }
    
}
