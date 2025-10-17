//
//  Transaction.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 16/10/2025.
//

import Vapor
import Fluent

final class Transaction: Model, Content, @unchecked Sendable  {
    static let schema = "transaction"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "amount")
    var amount: Double
    
    @Timestamp(key: "date", on: .create)
    var date: Date?
    
    @Field(key: "contractor")
    var contractor: String
    
    @Field(key: "id_transaction_category")
    var idTransactionCategory: UUID
    
    @Field(key: "id_user")
    var idUser: UUID
    
    // Constructeur vide (requis par Fluent)
    init() { }
    
    
    init(id: UUID? = nil, name: String, amount: Double, date: Date? = nil, contractor: String, idTransactionCategory: UUID, idUser: UUID) {
        self.id = id
        self.name = name
        self.amount = amount
        self.date = date
        self.contractor = contractor
        self.idTransactionCategory = idTransactionCategory
        self.idUser = idUser
    }
}
