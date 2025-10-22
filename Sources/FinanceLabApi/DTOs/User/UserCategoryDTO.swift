//
//  UserCategoryDTO.swift
//  FinanceLabApi
//
//  Created by YacineBahaka  on 16/10/2025.
//

import Vapor

struct UserCategoryDTO: Content {
    let id: UUID
    let name: String
    
    init(from userCategory: UserCategory) throws {
        self.id = try userCategory.requireID()
        self.name = userCategory.name
    }
}
