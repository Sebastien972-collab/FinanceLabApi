//
//  DefinitionController.swift
//  FinanceLabApi
//
//  Created by Anne Ferret on 24/10/2025.
//

import Vapor
import Fluent

struct DefinitionController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let definitions = routes.grouped("definitions")
        let protectedRoutes = definitions.grouped(JWTMiddleware())
        protectedRoutes.get(use: index)
        protectedRoutes.post(use: create)
        protectedRoutes.get("random", use: random)
//        protectedRoutes.get(":definitionID", use: getById)
//        protectedRoutes.delete(":definitionID", use: delete)
//        protectedRoutes.put(":definitionID", use: update)
    }

    func index(req: Request) async throws -> [DefinitionDTO] {
        let _ = try req.auth.require(UserPayload.self)
        
        let definitions = try await Definition.query(on: req.db).all()
        return definitions.map{ $0.toDefinitionDTO() }
    }

    @Sendable
    func create(req: Request) async throws -> DefinitionDTO {
        let _ = try req.auth.require(UserPayload.self)
        
        let dto = try req.content.decode(DefinitionDTO.self)
        
        // Create the actual Definition model
        let definition = Definition()
        definition.name = dto.name
        definition.content = dto.content
        
        try await definition.save(on: req.db)
        
        return definition.toDefinitionDTO()
    }
    
    func random(req: Request) async throws -> DefinitionDTO {
        let _ = try req.auth.require(UserPayload.self)
        
        let definitions = try await Definition.query(on: req.db).all()
        let randomDefinition = definitions.randomElement() ?? Definition(name: "Error", content: "Error fetching random definition")
        return randomDefinition.toDefinitionDTO()
    }
//
//    func getById(req: Request) async throws -> Definition {
//        let payload = try req.auth.require(UserPayload.self)
//                
//        guard let definition = try await Definition.find(req.parameters.get("definitionID"), on: req.db) else {
//            throw Abort(.notFound, reason: "Definition not found")
//        }
//        try await definition.save(on: req.db)
//        
//        return definition
//    }
//
//    func delete(req: Request) async throws -> HTTPStatus {
//        let payload = try req.auth.require(UserPayload.self)
//                
//        guard let definition = try await Definition.find(req.parameters.get("definitionID"), on: req.db) else {
//            throw Abort(.notFound)
//        }
//        try await definition.delete(on: req.db)
//        return .noContent
//    }
//
//    func update(req: Request) async throws -> Definition {
//        guard let existing = try await Definition.find(req.parameters.get("definitionID"), on: req.db) else {
//            throw Abort(.notFound, reason: "Definition not found")
//        }
//        let dto = try req.content.decode(DefinitionDTO.self)
//        // Preserve the existing identifier to ensure we update the correct record
//        existing.name = dto.name
//        existing.content = dto.content
//
//        try await existing.save(on: req.db)
//        return existing
//    }
    
}
