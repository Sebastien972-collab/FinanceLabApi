//
//  ArticleContentController.swift
//  FinanceLabApi
//
//  Created by Anne Ferret on 27/10/2025.
//

import Vapor
import Fluent

struct ArticleContentController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let articleContents = routes.grouped("articleContents")
        //articleContents.get(use: index)
        let protectedRoutes = articleContents.grouped(JWTMiddleware())
//        protectedRoutes.post(use: create)
        protectedRoutes.get(":articleID",use: getByArticleID)
//        protectedRoutes.delete(":articleContentID", use: delete)
//        protectedRoutes.put(":articleContentID", use: update)
    }
    
    
//    @Sendable
//    func create(req: Request) async throws -> ArticleContent {
//        let payload = try req.auth.require(UserPayload.self)
//        guard let user = try await User.find(payload.id, on: req.db) else {
//            throw Abort(.notFound, reason: "Utilisateur introuvable")
//        }
//        
//        let dto = try req.content.decode(ArticleContentDTO.self)
//        
//        // Create the actual Answer model
//        let articleContent = ArticleContent()
//        articleContent.orderPlacement = dto.orderPlacement
//        articleContent.type = dto.type
//        articleContent.content = dto.content
//        articleContent.$article.id = dto.idArticle
//        
//        try await articleContent.save(on: req.db)
//        
//        return articleContent
//    }
    
    func getByArticleID(req: Request) async throws -> [ArticleContentDTO] {
        let _ = try req.auth.require(UserPayload.self)
        
        guard let article = try await Article.find(req.parameters.get("articleID"), on: req.db) else {
            throw Abort(.notFound)
        }
        guard let articleUUID = article.id else {
            throw Abort(.badRequest, reason: "Invalid article ID format")
        }
        
        let articleContents = try await ArticleContent.query(on: req.db)
            .filter(\.$article.$id == articleUUID)
            .all()
        
        if articleContents.isEmpty {
            throw Abort(.notFound, reason: "No article content found for this article")
        }
        
        return articleContents.map{ $0.toArticleContentDTO() }
    }
    
//    func delete(req: Request) async throws -> HTTPStatus {
//        let payload = try req.auth.require(UserPayload.self)
//        
//        guard let user = try await User.find(payload.id, on: req.db) else {
//            throw Abort(.notFound)
//        }
//        
//        guard let articleContent = try await ArticleContent.find(req.parameters.get("articleContentID"), on: req.db) else {
//            throw Abort(.notFound)
//        }
//        try await articleContent.delete(on: req.db)
//        return .noContent
//    }
    
//    func update(req: Request) async throws -> ArticleContent {
//        guard let existing = try await ArticleContent.find(req.parameters.get("articleContentID"), on: req.db) else {
//            throw Abort(.notFound, reason: "Article content not found")
//        }
//        let dto = try req.content.decode(ArticleContentDTO.self)
//        // Preserve the existing identifier to ensure we update the correct record
//        existing.orderPlacement = dto.orderPlacement
//        existing.type = dto.type
//        existing.content = dto.content
//        existing.$article.id = dto.idArticle
//        
//        try await existing.save(on: req.db)
//        return existing
//    }
    
    
}
