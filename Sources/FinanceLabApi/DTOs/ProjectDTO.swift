//
//  ProjectDTO.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 20/10/2025.
//

import Vapor

struct ProjectDTO: Content {
    
    let id: UUID?
    let name: String
    let iconName: String
    let creationDate: Date?
    let endDate: Date?
    let amountSaved: Double
    let amountTotal: Double
    let idUser: UserPublicDTO
    
    init(from project: Project, user: User) throws {
        self.id = try project.requireID()
        self.name = project.name
        self.iconName = project.iconName
        self.creationDate = project.creationDate
        self.endDate = project.endDate
        self.amountSaved = project.amountSaved
        self.amountTotal = project.amountTotal
        self.idUser = try UserPublicDTO(from: user)
    }
}
