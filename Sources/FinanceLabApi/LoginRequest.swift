//
//  LoginRequest.swift
//  FinanceLabApi
//
//  Created by Anne Ferret on 13/10/2025.
//

import Vapor

struct LoginRequest: Content {
    let email: String
    let password: String
}
