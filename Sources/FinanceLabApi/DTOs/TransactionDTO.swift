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
    let date: Date
    let contractor: String
    
    init(
        id: UUID? = nil,
        name: String,
        iconName: String,
        amount: Double,
        date: Date,
        contractor: String,
    ) {
        self.id = id
        self.name = name
        self.iconName = iconName
        self.amount = amount
        self.date = date
        self.contractor = contractor
    }
}

