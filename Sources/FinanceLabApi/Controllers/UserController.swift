//
//  UserController.swift
//  FinanceLabApi
//
//  Created by Anne Ferret on 13/10/2025.
//

import Vapor
import Fluent
import JWT

struct UserController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let users = routes.grouped("users")
        
        users.post(use: create)
        users.get(use: index)
        users.post("login", use: login)
        
        let protectedRoutes = users.grouped(JWTMiddleware())
        protectedRoutes.get("profile", use: profile)
        protectedRoutes.patch("update", use: update)
        
        // TODO: Some of these routes might need to be disabled before going into production
        users.group(":userID") { user in
            user.get(use: self.get)
            user.delete(use: self.delete)
        }
    }
    
    @Sendable
    func create(_ req: Request) async throws -> UserPublicDTO {
        let user = try req.content.decode(User.self)
        user.password = try Bcrypt.hash(user.password)
        try await user.save(on: req.db)
        return try UserPublicDTO(from: user)
    }
    
    @Sendable
    func login(_ req: Request) async throws -> [String: String] {
        let userData = try req.content.decode(LoginRequest.self)
        
        guard let user = try await User.query(on: req.db)
            .filter(\.$email == userData.email)
            .first() else {
            throw Abort(.unauthorized, reason: "This user does not exist.")
        }
        
        guard try Bcrypt.verify(userData.password, created: user.password) else {
            throw Abort(.unauthorized, reason: "Incorrect password.")
        }
        
        let payload = UserPayload(id: user.id!)
        let signer = JWTSigner.hs256(key: "This_app_was_supposed_to_be_called_Dembo")
        let token = try signer.sign(payload)
        //return token
        return ["token": token]
    }
    
    @Sendable
    func profile(_ req: Request) async throws -> UserPublicDTO {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        return try UserPublicDTO(from: user)
    }

    @Sendable
    func index(_ req: Request) async throws -> [UserPublicDTO] {
        let users = try await User.query(on: req.db).all()
        return try users.map(UserPublicDTO.init(from:))
    }
    
    @Sendable
    func get(_ req: Request) async throws -> UserPublicDTO {
        guard let id = req.parameters.get("userID", as: UUID.self),
              let user = try await User.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        return try UserPublicDTO(from: user)
    }
    
    @Sendable
    func delete(_ req: Request) async throws -> HTTPStatus {
        guard let id = req.parameters.get("userID", as: UUID.self),
              let user = try await User.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        try await user.delete(on: req.db)
        return .noContent
    }
    
    @Sendable
    func update(_ req: Request) async throws -> UserPublicDTO {
        let payload = try req.auth.require(UserPayload.self)
        let patch = try req.content.decode(PatchUserDTO.self)
        
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        if let firstName = patch.firstName {
            user.firstName = firstName
        }
        if let lastName = patch.lastName {
            user.lastName = lastName
        }
        if let email = patch.email {
            user.email = email
        }
        try await user.save(on: req.db)
        return try UserPublicDTO(from: user)
    }
}
