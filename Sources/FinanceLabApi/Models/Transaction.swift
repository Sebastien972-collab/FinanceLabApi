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
    
    @Field(key: "icon_name")
    var iconName: String
    
    @Field(key: "amount")
    var amount: Double
    
    @Timestamp(key: "date", on: .none)
    var date: Date?
    
    @Field(key: "contractor")
    var contractor: String
    
    @Parent(key: "id_user")
    var user: User
        
    // Constructeur vide (requis par Fluent)
    init() { }
    
    func toTransactionDTO() -> TransactionDTO {
        TransactionDTO(
            id: id,
            name: name,
            iconName: iconName,
            amount: amount,
            date: date ?? Date(),
            contractor: contractor
        )
    }
    
    init(
        id: UUID? = nil,
        name: String,
        iconName: String,
        amount: Double,
        date: Date? = nil,
        contractor: String,
        userID: User.IDValue
    ) {
        self.id = id
        self.name = name
        self.iconName = iconName
        self.amount = amount
        self.date = date
        self.contractor = contractor
        self.$user.id = userID
    }
}
