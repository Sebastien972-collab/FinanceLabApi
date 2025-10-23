import Fluent
import FluentMySQLDriver
import Vapor
import Gatekeeper

public func configure(_ app: Application) async throws {
    // MARK: - Configuration de la base MySQL via variables d'environnement
    let hostname = Environment.get("DATABASE_HOST") ?? "127.0.0.1"
    let port = Environment.get("DATABASE_PORT").flatMap(Int.init) ?? 3306
    let username = Environment.get("DATABASE_USERNAME") ?? "secret"
    let password = Environment.get("DATABASE_PASSWORD") ?? "secret"
    let database = Environment.get("DATABASE_NAME") ?? "finance_app"

    // 🔧 Configuration MySQL sans TLS (désactivation du SSL)
    var config = MySQLConfiguration(
        hostname: hostname,
        port: port,
        username: username,
        password: password,
        database: database
    )
    config.tlsConfiguration = nil // ✅ évite toute négociation SSL locale

    // ✅ Enregistrement de la base dans Fluent
    app.databases.use(.mysql(configuration: config), as: .mysql)
    print("✅ Connected to MySQL over TCP (\(hostname):\(port))")

    // MARK: - CORS
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .DELETE, .OPTIONS],
        allowedHeaders: [.accept, .authorization, .contentType, .origin],
        cacheExpiration: 800
    )
    app.middleware.use(CORSMiddleware(configuration: corsConfiguration))

    // MARK: - Gatekeeper (limiteur de requêtes)
    app.caches.use(.memory)
    app.gatekeeper.config = .init(maxRequests: 100, per: .minute)
    app.middleware.use(GatekeeperMiddleware())

    // MARK: - Routes
    try routes(app)
}
