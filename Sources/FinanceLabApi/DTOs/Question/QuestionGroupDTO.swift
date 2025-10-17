//
//  QuestionGroupDTO.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 17/10/2025.
//

import Vapor

struct QuestionGroupDTO: Content {
    
    let id: UUID?
    let title: String
    let icon: String
    
    init(from questionGroup: QuestionGroup) throws {
        self.id = try questionGroup.requireID()
        self.title = questionGroup.title
        self.icon = questionGroup.icon
    }
}
