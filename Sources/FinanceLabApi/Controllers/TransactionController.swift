//
//  TransactionController.swift
//  FinanceLabApi
//
//  Created by Anne Ferret on 27/10/2025.
//

import Vapor
import Fluent

struct TransactionController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let transactions = routes.grouped("transactions")
        //transactions.get(use: index)
        let protectedRoutes = transactions.grouped(JWTMiddleware())
        protectedRoutes.post(use: create)
        protectedRoutes.get(":transactionID", use: getById)
        protectedRoutes.delete(":transactionID", use: delete)
        protectedRoutes.put(":transactionID", use: update)
        protectedRoutes.get(use: getByUserID)
    }

    func index(req: Request) async throws -> [Transaction] {
        
        try await Transaction.query(on: req.db).all()
    }

    @Sendable
    func create(req: Request) async throws -> Transaction {
        let payload = try req.auth.require(UserPayload.self)
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound, reason: "Utilisateur introuvable")
        }
        
        let dto = try req.content.decode(TransactionDTO.self)
        
        // Create the actual Transaction model
        let transaction = Transaction()
        transaction.name = dto.name
        transaction.iconName = dto.iconName
        transaction.amount = dto.amount
        transaction.date = dto.date
        transaction.contractor = dto.contractor
        transaction.$user.id = try user.requireID()
        
        try await transaction.save(on: req.db)
        
        return transaction
    }
    
    func getById(req: Request) async throws -> Transaction {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        guard let transaction = try await Transaction.find(req.parameters.get("transactionID"), on: req.db) else {
            throw Abort(.notFound, reason: "Transaction not found")
        }
        transaction.$user.id = try user.requireID()
        try await transaction.save(on: req.db)
        
        return transaction
    }

    func delete(req: Request) async throws -> HTTPStatus {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        guard let transaction = try await Transaction.find(req.parameters.get("transactionID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await transaction.delete(on: req.db)
        return .noContent
    }

    func update(req: Request) async throws -> Transaction {
        guard let existing = try await Transaction.find(req.parameters.get("transactionID"), on: req.db) else {
            throw Abort(.notFound, reason: "Transaction not found")
        }
        let dto = try req.content.decode(TransactionDTO.self)
        // Preserve the existing identifier to ensure we update the correct record
        existing.name = dto.name
        existing.iconName = dto.iconName
        existing.amount = dto.amount
        existing.date = dto.date
        existing.contractor = dto.contractor
        existing.$user.id = dto.idUser

        try await existing.save(on: req.db)
        return existing
    }
    
    func getByUserID(req: Request) async throws -> [Transaction] {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        guard let userUUID = user.id else {
            throw Abort(.badRequest, reason: "Invalid user ID format")
        }

        let transactions = try await Transaction.query(on: req.db)
            .filter(\.$user.$id == userUUID)
            .all()

        if transactions.isEmpty {
            throw Abort(.notFound, reason: "No transaction found for this user")
        }

        return transactions
    }
}
