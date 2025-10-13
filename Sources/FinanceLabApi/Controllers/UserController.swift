//
//  UserController.swift
//  FinanceLabApi
//
//  Created by Anne Ferret on 13/10/2025.
//

import Vapor
import Fluent

struct UserController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let users = routes.grouped("users")
        
        users.post(use: create)
        users.get(use: list)
        users.group(":userID") { user in
            user.get(use: self.get)
            user.delete(use: self.delete)
            user.patch(use: self.patch)
        }
    }
    
    @Sendable
    func create(_ req: Request) async throws -> UserPublicDTO {
        let user = try req.content.decode(User.self)
        user.password = try Bcrypt.hash(user.password)
        try await user.save(on: req.db)
        return try UserPublicDTO(from: user)
    }
    
//    @Sendable
//    func create(_ req: Request) async throws -> UserPublicDTO {
//        let dto = try req.content.decode(CreateUserDTO.self)
//        
//        let user = User(firstName: dto.firstName, lastName: dto.lastName, email: dto.email, password: dto.password)
//        
//        try await user.create(on: req.db)
//        return try UserPublicDTO(from: user)
//    }

    @Sendable
    func list(_ req: Request) async throws -> [UserPublicDTO] {
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
    func patch(_ req: Request) async throws -> UserPublicDTO {
        let patch = try req.content.decode(PatchUserDTO.self)
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
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
        if let password = patch.password {
            user.password = password
        }
        try await user.save(on: req.db)
        return try UserPublicDTO(from: user)
    }
}
