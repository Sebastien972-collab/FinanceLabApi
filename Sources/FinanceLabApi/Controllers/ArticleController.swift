//
//  ArticleController.swift
//  FinanceLabApi
//
//  Created by Anne Ferret on 27/10/2025.
//

import Vapor
import Fluent

struct ArticleController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let articles = routes.grouped("articles")
        let protectedRoutes = articles.grouped(JWTMiddleware())
        protectedRoutes.post(use: create)
        protectedRoutes.get(":articleID", use: getById)
        protectedRoutes.delete(":articleID", use: delete)
        protectedRoutes.put(":articleID", use: update)
        protectedRoutes.get(use: index)
    }

    @Sendable
    func create(req: Request) async throws -> Article{
        let payload = try req.auth.require(UserPayload.self)
        
        let dto = try req.content.decode(ArticleDTO.self)
        
        // Create the actual Question model
        let article = Article()
        article.title = dto.title
        article.image = dto.image
        article.creationDate = .now
        article.articleCategory = dto.articleCategory

        try await article.save(on: req.db)
        
        return article
    }
    
    func getById(req: Request) async throws -> Article {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        guard let article = try await Article.find(req.parameters.get("articleID"), on: req.db) else {
            throw Abort(.notFound, reason: "Article not found")
        }
        try await article.save(on: req.db)
        
        return article
    }

    func delete(req: Request) async throws -> HTTPStatus {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        guard let article = try await Article.find(req.parameters.get("articleID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await article.delete(on: req.db)
        return .noContent
    }

    func update(req: Request) async throws -> Article {
        guard let existing = try await Article.find(req.parameters.get("articleID"), on: req.db) else {
            throw Abort(.notFound, reason: "Article not found")
        }
        let dto = try req.content.decode(ArticleDTO.self)
        // Preserve the existing identifier to ensure we update the correct record
        existing.title = dto.title
        existing.image = dto.image
        existing.articleCategory = dto.articleCategory

        try await existing.save(on: req.db)
        return existing
    }
    
    func index(req: Request) async throws -> [ArticleDTO] {
        // Authentificate user
        let _ = try req.auth.require(UserPayload.self)

        // Finds all articles in database
        let articles = try await Article.query(on: req.db)
            .all()
        if articles.isEmpty {
            throw Abort(.notFound, reason: "No articles found")
        }

        // Returns the transactions in an array of transaction DTOs
        return articles.map{ $0.toArticleDTO() }
    }
    
}
