//
//  JWTMiddleware.swift
//  FinanceLabApi
//
//  Created by Anne Ferret on 13/10/2025.
//

import Vapor
import JWT

final class JWTMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: any Responder) -> EventLoopFuture<Response> {
        // Vérifiez l'en-tête Authorization pour obtenir le token JWT
        guard let token = request.headers["Authorization"].first?.split(separator: " ").last else {
            return request.eventLoop.future(error: Abort(.unauthorized, reason: "Missing token."))
        }
        
        let signer = JWTSigner.hs256(key: "This_app_was_supposed_to_be_called_Dembo")
        let payload: UserPayload
        
        do {
            // Vérifiez le token et récupérez le payload
            payload = try signer.verify(String(token), as:UserPayload.self)
        } catch {
            return request.eventLoop.future(error: Abort(.unauthorized, reason: "Invalid token."))
        }
        
        // Attacher l'utilisateur au contexte de la requête
        request.auth.login(payload)
        
        // Passer à la prochaine étape du traitement de la requête
        return next.respond(to: request)
    }
}
