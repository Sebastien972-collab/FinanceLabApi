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
    func create(req: Request) async throws -> TransactionDTO {
        // Authentificate user
        let payload = try req.auth.require(UserPayload.self)
        
        // Find user from token in the database
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }

        // Initialize our transaction DTO
        let dto = try req.content.decode(TransactionDTO.self)
        
        // Create the transaction model
        let transaction = Transaction()
        transaction.name = dto.name
        transaction.iconName = dto.iconName
        transaction.amount = dto.amount
        transaction.date = dto.date
        transaction.contractor = dto.contractor
        transaction.$user.id = try user.requireID()     // user ID from token
        
        // Saves on database and return transaction as DTO
        try await transaction.save(on: req.db)
        return transaction.toTransactionDTO()
    }
    
    func getById(req: Request) async throws -> TransactionDTO {
        // Authentificate user
        let _ = try req.auth.require(UserPayload.self)

        // Finds transaction by ID
        guard let transaction = try await Transaction.find(req.parameters.get("transactionID"), on: req.db) else {
            throw Abort(.notFound, reason: "Transaction not found")
        }
        
        // Return transaction as DTO
        return transaction.toTransactionDTO()
    }

    func delete(req: Request) async throws -> HTTPStatus {
        // Authentificate user
        let _ = try req.auth.require(UserPayload.self)
        
        // Finds transaction by ID
        guard let transaction = try await Transaction.find(req.parameters.get("transactionID"), on: req.db) else {
            throw Abort(.notFound, reason: "Transaction not found")
        }
        
        // Delete transaction from database
        try await transaction.delete(on: req.db)
        
        // Returns http status confirmation without content
        return .noContent
    }

    func update(req: Request) async throws -> TransactionDTO {
        // Authentificate user
        let _ = try req.auth.require(UserPayload.self)

        // Takes existing transaction from database
        guard let existing = try await Transaction.find(req.parameters.get("transactionID"), on: req.db) else {
            throw Abort(.notFound, reason: "Transaction not found")
        }
        
        // Takes DTO sent from client
        let dto = try req.content.decode(TransactionDTO.self)
        
        // Values to update
        existing.name = dto.name
        existing.iconName = dto.iconName
        existing.amount = dto.amount
        existing.date = dto.date
        existing.contractor = dto.contractor

        // Saves on database and returns updated transaction as DTO
        try await existing.save(on: req.db)
        return existing.toTransactionDTO()
    }
    
    func getByUserID(req: Request) async throws -> [TransactionDTO] {
        // Authentificate user
        let payload = try req.auth.require(UserPayload.self)
        
        // Find user from token in the database
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }

        // Get user ID
        guard let userUUID = user.id else {
            throw Abort(.badRequest, reason: "Invalid user ID format")
        }

        // Finds all transactions with this user ID in database
        let transactions = try await Transaction.query(on: req.db)
            .filter(\.$user.$id == userUUID)
            .all()
        if transactions.isEmpty {
            throw Abort(.notFound, reason: "No transaction found for this user")
        }

        // Returns the transactions in an array of transaction DTOs
        return transactions.map{ $0.toTransactionDTO() }
    }
}
