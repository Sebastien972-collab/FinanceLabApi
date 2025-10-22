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
        answers.get(use: index)
        answers.post(use: create)
        answers.get(":answerID", use: getById)
//        answers.delete(":answerID", use: delete)
//        answers.put(":answerID", use: update)
        
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
        guard let answer = try await Answer.find(req.parameters.get("answerID"), on: req.db) else {
            throw Abort(.notFound, reason: "Answer not found")
        }
        return answer
    }
    
//    func delete(req: Request) async throws -> HTTPStatus {
//        guard let answer = try await Answer.find(req.parameters.get("answerID"), on: req.db) else {
//            throw Abort(.notFound)
//        }
//        try await answer.delete(on: req.db)
//        return .noContent
//    }
//    
//    func update(req: Request) async throws -> Answer {
//        guard let existing = try await Answer.find(req.parameters.get("answerID"), on: req.db) else {
//            throw Abort(.notFound, reason: "Answer not found")
//        }
//        let input = try req.content.decode(Answer.self)
//        // Preserve the existing identifier to ensure we update the correct record
//        existing.content = input.content
//        existing.idUser = input.idUser
//        existing.idQuestion = input.idQuestion
//        
//        try await existing.save(on: req.db)
//        return existing
//    }
    
}
