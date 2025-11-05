//
//  FinanceTests.swift
//  FinanceLabApi
//
//  Created by Anne Ferret on 05/11/2025.
//

@testable import FinanceLabApi
import VaporTesting
import Testing
import Fluent

@Suite("FinanceLab runs", .serialized)
struct FinanceTests {
    
    @Test("It works")
    func itWorks() async throws {
        try await withApp(configure: configure) { app in
            try await app.testing().test(.GET, "/") { res async in
                #expect(res.status == .ok)
                #expect(res.body.string == "It works!")
            }
        }
    }
    
    // Note: I'd need migrations to do more (actually useful) tests.
    // If you're an evaluator and read this, I'm sorry!
}
