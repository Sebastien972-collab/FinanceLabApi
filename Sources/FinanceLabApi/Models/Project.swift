//
//  File.swift
//  FinanceLabApi
//
//  Created by Sébastien DAGUIN on 13/10/2025.
//

import Vapor
import Fluent

final class Project: Model, Content, @unchecked Sendable {
    static let schema = "project"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    @Field(key: "icon_name")
    var iconName: String
    
    @Timestamp(key: "creation_date", on: .create)
    var creationDate: Date?
    
    @Field(key: "end_date")
    var endDate: Date

    @Field(key: "amount_saved")
    var amountSaved: Double
    
    @Field(key: "amount_total")
    var amountTotal: Double
    
    @Parent(key: "id_user")
    var user: User
    
    // Constructeur vide (requis par Fluent)
    init() {}

    init(
        id: UUID? = nil,
        name: String,
        iconName: String,
        creationDate: Date? = nil,
        endDate: Date,
        amountSaved: Double,
        amountTotal: Double,
        userID: User.IDValue
    ) {
        self.id = id
        self.name = name
        self.iconName = iconName
        self.creationDate = creationDate
        self.endDate = endDate
        self.amountSaved = amountSaved
        self.amountTotal = amountTotal
        self.$user.id = userID
    }
}
