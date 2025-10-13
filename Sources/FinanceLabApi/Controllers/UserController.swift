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
        }
    }
    
    func create(_ req: Request) async throws -> UserPublicDTO {
        let dto = try req.content.decode(CreateUserDTO.self)
        
        let user = User(firstName: dto.firstName, lastName: dto.lastName, password: dto.password, email: dto.email)
        
        try await user.create(on: req.db)
        return try UserPublicDTO(from: user)
    }

    func list(_ req: Request) async throws -> [UserPublicDTO] {
        let users = try await User.query(on: req.db).all()
        return try users.map(UserPublicDTO.init(from:))
    }
    
    func get(_ req: Request) async throws -> UserPublicDTO {
        guard let id = req.parameters.get("userID", as: UUID.self),
              let user = try await User.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        return try UserPublicDTO(from: user)
    }
    
    func delete(_ req: Request) async throws -> HTTPStatus {
        guard let id = req.parameters.get("userID", as: UUID.self),
              let user = try await User.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        try await user.delete(on: req.db)
        return .noContent
    }
}
