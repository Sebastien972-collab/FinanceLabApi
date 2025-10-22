//
//  TransactionDTO.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 16/10/2025.
//

import Vapor

struct TransactionDTO: Content {
    
    let id: UUID?
    let name: String
    let iconName: String
    let amount: Double
    let date: Date?
    let contractor: String
    let idUser: UserPublicDTO
    
    init(from transaction: Transaction, user: User) throws {
        self.id = try transaction.requireID()
        self.name = transaction.name
        self.iconName = transaction.iconName
        self.amount = transaction.amount
        self.date = transaction.date
        self.contractor = transaction.contractor
        self.idUser = try UserPublicDTO(from: user)
    }
}

