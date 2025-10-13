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

    @Field(key: "user_id")
    var userID: UUID

    @Field(key: "name")
    var name: String

    @Field(key: "goal_amount")
    var goalAmount: Double

    @Field(key: "amount_saved")
    var amountSaved: Double

    @Field(key: "final_date")
    var finalDate: Date

    @OptionalField(key: "current_image")
    var currentImage: String?

    @Field(key: "status")
    var status: String

    init() {}

    init(
        id: UUID? = nil,
        userID: UUID,
        name: String,
        goalAmount: Double,
        amountSaved: Double = 0.0,
        finalDate: Date,
        currentImage: String? = nil,
    ) {
        self.id = id
        self.userID = userID
        self.name = name
        self.goalAmount = goalAmount
        self.amountSaved = amountSaved
        self.finalDate = finalDate
        self.currentImage = currentImage
    }
}
