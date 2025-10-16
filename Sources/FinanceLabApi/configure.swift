import Fluent
import FluentMySQLDriver
import Vapor
import NIOSSL

public func configure(_ app: Application) async throws {
    
    app.databases.use(DatabaseConfigurationFactory.mysql(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? MySQLConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
    ), as: .mysql)

    // ✅ TLS moderne sans vérification de certificat
    var tls = TLSConfiguration.makeClientConfiguration()
    tls.certificateVerification = .none
            
    // MARK: - Migrations
    app.migrations.add(CreateProject())
    app.migrations.add(RemoveStatusFromProject())
    app.migrations.add(CreateUser())
    app.migrations.add(AnswerMigration())
    
    // MARK: - Launch or revert migrations
//    try await app.autoMigrate()
    try await app.autoRevert()
    
    // MARK: - Routes
    // register routes
    try routes(app)
}
