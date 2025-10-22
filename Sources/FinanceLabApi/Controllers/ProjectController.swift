//
//  File.swift
//  FinanceLabApi
//
//  Created by Sébastien DAGUIN on 13/10/2025.
//

import Vapor
import Fluent

struct ProjectController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let projects = routes.grouped("projects")
        projects.get(use: index)
        projects.post(use: create)
        projects.get(":projectID", use: getById)
//        projects.delete(":projectID", use: delete)
//        projects.put(":projectID", use: update)
    }
    
    func index(req: Request) async throws -> [Project] {
        try await Project.query(on: req.db).all()
    }
    
    func create(req: Request) async throws -> Project {
        let project = try req.content.decode(Project.self)
        try await project.save(on: req.db)
        return project
    }
    
    func getById(req: Request) async throws -> Project {
        guard let project = try await Project.find(req.parameters.get("projectID"), on: req.db) else {
            throw Abort(.notFound, reason: "Project not found")
        }
        return project
    }
    // la requête tourne en boucle
//    func delete(req: Request) async throws -> HTTPStatus {
//        guard let project = try await Project.find(req.parameters.get("projectID"), on: req.db) else {
//            throw Abort(.notFound)
//        }
//        try await project.delete(on: req.db)
//        return .noContent
//    }
    
    // Problème lors de l'update, la requête tourne en boucle.
//    func update(req: Request) async throws -> Project {
//        guard let existing = try await Project.find(req.parameters.get("projectID"), on: req.db) else {
//            throw Abort(.notFound, reason: "Project not found")
//        }
//        
//        let input = try req.content.decode(Project.self)
//        // Preserve the existing identifier to ensure we update the correct record
//        existing.name = input.name
//        existing.icon = input.icon
//        existing.creationDate = input.creationDate
//        existing.finalDate = input.finalDate
//        existing.amountMonthly = input.amountMonthly
//        existing.amountSaved = input.amountSaved
//        existing.amountTotal = input.amountTotal
//        existing.idUser = input.idUser
//        
//        try await existing.save(on: req.db)
//        return existing
//    }
}
