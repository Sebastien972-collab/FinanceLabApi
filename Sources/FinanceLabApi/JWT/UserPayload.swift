//
//  UserPayload.swift
//  FinanceLabApi
//
//  Created by Anne Ferret on 13/10/2025.
//

import Foundation
import Vapor
import JWT

// Déclaration de la structure UserPayload
struct UserPayload: JWTPayload, Authenticatable {
    var id: UUID
    var expiration: Date

    // Vérification de la validité du token
    func verify(using signer: JWTSigner) throws {
        if self.expiration < Date() {
            throw JWTError.invalidJWK // Lancer une erreur si le token est expiré
        }
    }

    // Constructeur qui définit l'ID et la date d'expiration
    init(id: UUID) {
        self.id = id
        self.expiration = Date().addingTimeInterval(3600 * 24) // Expire dans 1 jour
    }
}
