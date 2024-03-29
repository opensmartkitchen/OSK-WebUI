import Leaf
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    if env == .development {
        
        services.register(Server.self) {
            (container: Container) -> NIOServer in
            var serverConfig = try container.make() as NIOServerConfig
            serverConfig.port = 8080 // 8080, 8989, 29***, etc.
            serverConfig.hostname = "0.0.0.0" // "localhost", "0.0.0.0",  "192.168.31.215"
            let server = NIOServer(
                config: serverConfig,
                container: container
            )
            return server
        }
    }
    
    // Register providers first
    try services.register(LeafProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    // Use Leaf for rendering views
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
}
