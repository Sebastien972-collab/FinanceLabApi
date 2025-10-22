//
//  User.swift
//  FinanceLabApi
//
//  Created by Anne Ferret on 13/10/2025.
//

import Vapor
import Fluent

final class User: Model, Content, @unchecked Sendable {
    static let schema = "users" // Nom de la table MySQL
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "first_name")
    var firstName: String
    
    @Field(key: "last_name")
    var lastName: String
    
    @Field(key: "email")
    var email: String
    
    @Timestamp(key: "date_of_registration", on: .create)
    var dateOfRegistration: Date?
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "id_user_category")
    var idUserCategory: UUID
    
    // Constructeur vide (requis par Fluent)
    init() {}
    
    init(id: UUID? = nil, firstName: String, lastName: String, email: String, password: String, idUserCategory: UUID) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
    }
}

