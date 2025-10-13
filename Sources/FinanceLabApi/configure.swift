import Fluent
import FluentMySQLDriver
import Vapor
import NIOSSL

public func configure(_ app: Application) async throws {

    let hostname = Environment.get("DATABASE_HOST") ?? "127.0.0.1"
    let port = Environment.get("DATABASE_PORT").flatMap(Int.init) ?? 3306
    let username = Environment.get("DATABASE_USERNAME") ?? "root"
    let password = Environment.get("DATABASE_PASSWORD") ?? ""
    let database = Environment.get("DATABASE_NAME") ?? "finance_lab"

    // ✅ TLS moderne sans vérification de certificat
    var tls = TLSConfiguration.makeClientConfiguration()
    tls.certificateVerification = .none

    let configuration = MySQLConfiguration(
        hostname: hostname,
        port: port,
        username: username,
        password: password,
        database: database,
        tlsConfiguration: tls
    )

    app.databases.use(.mysql(configuration: configuration), as: .mysql)
    print("✅ Connected to MySQL over TCP (\(hostname):\(port))")

    // MARK: - Migrations
    app.migrations.add(CreateProject())
    app.migrations.add(RemoveStatusFromProject())
    try await app.autoMigrate()

    // MARK: - Routes
    try routes(app)
}
