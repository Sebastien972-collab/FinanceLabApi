//
//  User.swift
//  FinanceLabApi
//
//  Created by Anne Ferret on 13/10/2025.
//

import Vapor
import Fluent

final class Utilisateur: Model, Content, @unchecked Sendable {
    static let schema = "users" // Nom de la table MySQL
    
    @ID(key: .id) var id: UUID?
    @Field(key: "firstName") var firstName: String
    @Field(key: "lastName") var lastName: String
    @Field(key: "email") var email: String
    @Timestamp(key: "date_of_registration", on: .create) var dateOfRegistration: Date?
    @Field(key: "password") var password: String
    @Field(key: "profile_picture") var profilePicture: UUID?
    
    // Constructeur vide (requis par Fluent)
    init() {}
}

