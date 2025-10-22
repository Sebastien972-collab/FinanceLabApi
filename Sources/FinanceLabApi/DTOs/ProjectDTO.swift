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
    let icon: String
    let creationDate: Date?
    let finalDate: Date?
    let amountMonthly: Double
    let amountSaved: Double
    let amountTotal: Double
    let idUser: UserPublicDTO
    
    init(from project: Project, user: User) throws {
        self.id = try project.requireID()
        self.name = project.name
        self.icon = project.icon
        self.creationDate = project.creationDate
        self.finalDate = project.finalDate
        self.amountMonthly = project.amountMonthly
        self.amountSaved = project.amountSaved
        self.amountTotal = project.amountTotal
        self.idUser = try UserPublicDTO(from: user)
    }
}
