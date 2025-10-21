//
//  File.swift
//  FinanceLabApi
//
//  Created by Sébastien DAGUIN on 13/10/2025.
//

import Vapor
import Fluent

final class Project: Model, Content, @unchecked Sendable {
    static let schema = "projects"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    @Field(key: "icon")
    var icon: String
    
    @Field(key: "creation_date")
    var creationDate: Date?
    
    @Field(key: "final_date")
    var finalDate: Date?

    @Field(key: "amount_monthly")
    var amountMonthly: Double

    @Field(key: "amount_saved")
    var amountSaved: Double
    
    @Field(key: "amount_total")
    var amountTotal: Double
    
    @Field(key: "id_user")
    var idUser: UUID

    // Constructeur vide (requis par Fluent)
    init() {}
    
    init(id: UUID? = nil, name: String, icon: String, creationDate: Date? = nil, finalDate: Date? = nil, amountMonthly: Double, amountSaved: Double, amountTotal: Double, idUser: UUID) {
        self.id = id
        self.name = name
        self.icon = icon
        self.creationDate = creationDate
        self.finalDate = finalDate
        self.amountMonthly = amountMonthly
        self.amountSaved = amountSaved
        self.amountTotal = amountTotal
        self.idUser = idUser
    }

}
