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

    // TLS moderne sans vérification de certificat
    var tls = TLSConfiguration.makeClientConfiguration()
    tls.certificateVerification = .none
        
    // MARK: - Migrations
    app.migrations.add(UserCategoryMigration())
    app.migrations.add(UserMigration())
    app.migrations.add(TransactionCategoryMigration())
    app.migrations.add(TransactionMigration())
    app.migrations.add(ProjectMigration())
    app.migrations.add(DefinitionMigration())
    app.migrations.add(AdviceMigration())
    app.migrations.add(QuestionGroupMigration())
    app.migrations.add(QuestionMigration())
    app.migrations.add(AnswerMigration())    
    app.migrations.add(ArticleCategoryMigration())
    app.migrations.add(ArticleMigration())
    app.migrations.add(RemoveStatusFromProject())
       
    // MARK: Configurations
  
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
    
    // MARK: - Routes
    // register routes
    try routes(app)
}