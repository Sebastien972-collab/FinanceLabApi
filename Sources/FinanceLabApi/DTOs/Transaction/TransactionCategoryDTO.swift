//
//  TransactionCategoryDTO.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 16/10/2025.
//

import Vapor

struct TransactionCategoryDTO: Content {
    let id: UUID?
    let name: String
    let icon: String

    init(from transactionCategory: TransactionCategory) throws {
        self.id = try transactionCategory.requireID()
        self.name = transactionCategory.name
        self.icon = transactionCategory.icon
    }
}
