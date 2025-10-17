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
    let amount: Double
    let date: Date?
    let contractor: String
    let idTransactionCategory: UUID
    let idUser: UUID
    
    init(from transaction: Transaction) throws {
        self.id = try transaction.requireID()
        self.name = transaction.name
        self.amount = transaction.amount
        self.date = transaction.date
        self.contractor = transaction.contractor
        self.idTransactionCategory = transaction.idTransactionCategory
        self.idUser = transaction.idUser
    }
}

