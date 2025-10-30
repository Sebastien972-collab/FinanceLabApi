//
//  UserDTO.swift
//  FinanceLabApi
//
//  Created by Anne Ferret on 13/10/2025.
//

import Vapor

struct UserDTO: Content {
    let firstName: String
    let lastName: String
    let email: String
    var password: String
    
    func toUser() -> User {
        User(id: UUID(), firstName: self.firstName, lastName: self.lastName, userCategory: "none", profilePictureURL: "", email: self.email, password: self.password, balance: 0.0)
    }
}

struct UserPublicDTO: Content {
    let id: UUID
    let firstName: String
    let lastName: String
    let userCategory: String
    let profilePictureURL: String
    let email: String
    let balance: Double
    init(from user: User) throws {
        self.id = try user.requireID()
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.userCategory = user.userCategory
        self.profilePictureURL = user.profilePictureURL
        self.email = user.email
        self.balance = user.balance
    }
}

struct PatchUserDTO: Decodable {
    var firstName: String?
    var lastName: String?
    var userCategory: String?
    var profilePictureURL: String?
    var email: String?
    var balance: Double?
}
