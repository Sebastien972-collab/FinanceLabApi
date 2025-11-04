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
        protectedRoutes.post("bulk", use: postAllAnswers)
        protectedRoutes.get("groups", use: getAnsweredGroups)
        protectedRoutes.get(":answerID", use: getById)
        protectedRoutes.delete(":answerID", use: delete)
        protectedRoutes.put(":answerID", use: update)
        protectedRoutes.get(use: getByUserID)
    }

    func index(req: Request) async throws -> [Answer] {
        try await Answer.query(on: req.db).all()
    }

    @Sendable
    func create(req: Request) async throws -> AnswerDTO {
        let payload = try req.auth.require(UserPayload.self)
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound, reason: "Utilisateur introuvable")
        }
        
        let dto = try req.content.decode(AnswerDTO.self)
        
        // Create the actual Answer model
        let answer = Answer()
        answer.content = dto.content
        answer.$user.id = try user.requireID()
        answer.$question.id = dto.idQuestion
        
        try await answer.save(on: req.db)
        
        return dto
    }
    @Sendable
    func postAllAnswers(req: Request) async throws -> [AnswerDTO] {
        let payload = try req.auth.require(UserPayload.self)
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound, reason: "Utilisateur introuvable")
        }
        
        let dto = try req.content.decode([AnswerDTO].self)
        
        // Create the actual Answer model
        var answers: [AnswerDTO] = []
        for answer in dto {
            let newAnswer = Answer()
            newAnswer.content = answer.content
            newAnswer.$user.id = try user.requireID()
            newAnswer.$question.id = answer.idQuestion
            try await newAnswer.save(on: req.db)
            answers.append(newAnswer.toDto())
        }
        
        return answers
    }
    
    func getById(req: Request) async throws -> Answer {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        guard let answer = try await Answer.find(req.parameters.get("answerID"), on: req.db) else {
            throw Abort(.notFound, reason: "Answer not found")
        }
        answer.$user.id = try user.requireID()
        try await answer.save(on: req.db)
        
        return answer
    }
    
    func getAnsweredGroups(req: Request) async throws -> [String] {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        guard let userUUID = user.id else {
            throw Abort(.badRequest, reason: "Invalid user ID format")
        }

        let answers = try await Answer.query(on: req.db)
            .filter(\.$user.$id == userUUID)
            .with(\.$question)
            .all()
        let questionGroups = Array(Set(answers.compactMap { $0.question.questionGroup }))
        return questionGroups
    }

    func delete(req: Request) async throws -> HTTPStatus {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        guard let answer = try await Answer.find(req.parameters.get("answerID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await answer.delete(on: req.db)
        return .noContent
    }

    func update(req: Request) async throws -> Answer {
        guard let existing = try await Answer.find(req.parameters.get("answerID"), on: req.db) else {
            throw Abort(.notFound, reason: "Answer not found")
        }
        let dto = try req.content.decode(AnswerDTO.self)
        // Preserve the existing identifier to ensure we update the correct record
        existing.content = dto.content
        existing.$question.id = dto.idQuestion

        try await existing.save(on: req.db)
        return existing
    }
    
    func getByUserID(req: Request) async throws -> [AnswerDTO] {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        guard let userUUID = user.id else {
            throw Abort(.badRequest, reason: "Invalid user ID format")
        }

        let answers = try await Answer.query(on: req.db)
            .filter(\.$user.$id == userUUID)
            .all()

        if answers.isEmpty {
            throw Abort(.notFound, reason: "No answers found for this user")
        }

        return answers.map { $0.toDto() }
    }
}
