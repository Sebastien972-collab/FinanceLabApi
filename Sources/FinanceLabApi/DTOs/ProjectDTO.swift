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
    let endDate: Date
    let amountSaved: Double
    let amountTotal: Double
    init(id: UUID? = nil, name: String, iconName: String, creationDate: Date? = nil,
         endDate: Date, amountSaved: Double, amountTotal: Double, idUser: UUID) {
        self.id = id
        self.name = name
        self.iconName = iconName
        self.creationDate = .now
        self.endDate = endDate
        self.amountSaved = amountSaved
        self.amountTotal = amountTotal
    }
}
