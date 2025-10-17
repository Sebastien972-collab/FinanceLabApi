import Fluent
import FluentMySQLDriver
import Vapor
import NIOSSL
import Gatekeeper

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
    
    // MARK: - Middleware configuration
    
    // CORS
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .DELETE, .OPTIONS],
        allowedHeaders: [.accept, .authorization, .contentType, .origin],
        cacheExpiration: 800
        )
    let corsMiddleware = CORSMiddleware(configuration: corsConfiguration)
    
    // Gatekeeper
    app.caches.use(.memory)
    app.gatekeeper.config = .init(maxRequests: 100, per: .minute)
    
    // MARK: - Middlewares
    // Rappel de l'ordre :
    // 1. ErrorMiddleware
    // 2. RequestID → Logging
    // 3. CORS
    // 4. Authentification/Autorisation
    // 5. Rate limit / politiques d'usage
    // 6. FileMiddleware

    app.middleware.use(corsMiddleware)
    app.middleware.use(GatekeeperMiddleware())
    
    // MARK: - Migrations
    try await app.autoMigrate()
    // uncomment this to revert migrations:
//    try await app.autoRevert()
    
    // MARK: - Routes
    // register routes
    try routes(app)
}
