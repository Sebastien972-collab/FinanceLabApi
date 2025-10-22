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
    let idTransactionCategory: TransactionCategoryDTO
    let idUser: UserPublicDTO
    
    init(from transaction: Transaction, transactionCategory: TransactionCategory, user: User) throws {
        self.id = try transaction.requireID()
        self.name = transaction.name
        self.amount = transaction.amount
        self.date = transaction.date
        self.contractor = transaction.contractor
        self.idTransactionCategory = try TransactionCategoryDTO(from: transactionCategory)
        self.idUser = try UserPublicDTO(from: user)
    }
}

