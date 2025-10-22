//
//  User.swift
//  FinanceLabApi
//
//  Created by Anne Ferret on 13/10/2025.
//

import Vapor
import Fluent

final class User: Model, Content, @unchecked Sendable {
    static let schema = "user" // Nom de la table MySQL
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "first_name")
    var firstName: String
    
    @Field(key: "last_name")
    var lastName: String
    
    @Field(key: "user_category")
    var userCategory: String
    
    @Field(key: "profile_picture_url")
    var profilePictureURL: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String
    
    @Timestamp(key: "creation_date", on: .create)
    var dateOfRegistration: Date?
    
    @Field(key: "balance")
    var balance: Double
    
    @Children(for: \.$user)
    var answers: [Answer]
    
    @Children(for: \.$user)
    var projects: [Project]
    
    @Children(for: \.$user)
    var transactions: [Transaction]
    
    // Constructeur vide (requis par Fluent)
    init() {}
    
    init(
        id: UUID? = nil,
        firstName: String,
        lastName: String,
        userCategory: String,
        profilePictureURL: String,
        email: String,
        password: String,
        dateOfRegistration: Date? = nil,
        balance: Double
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.userCategory = userCategory
        self.profilePictureURL = profilePictureURL
        self.email = email
        self.password = password
        self.dateOfRegistration = dateOfRegistration
        self.balance = balance
    }
}

