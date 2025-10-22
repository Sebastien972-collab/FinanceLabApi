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
    let password: String
}

struct UserPublicDTO: Content {
    let id: UUID
    let email: String
    let firstName: String
    let lastName: String
    let dateOfRegistration: Date?
    
    init(from user: User) throws {
        self.id = try user.requireID()
        self.email = user.email
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.dateOfRegistration = user.dateOfRegistration
    }
}

struct PatchUserDTO: Decodable {
    var firstName: String?
    var lastName: String?
    var email: String?
}
