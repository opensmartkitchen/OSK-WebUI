import Vapor
import OskGadgetCWrapMock

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // GET / home page
    router.get { req in
        return try req.view().render("home")
    }
    
    // GET /fruitbasket
    router.get("fruitbasket") { req -> Future<View> in
        var weightStr = "unavailable"
        if let oskGadget = oskGadgetCreate() {
            let weight = oskGadgetGetScaleWeight(oskGadget)
            weightStr = String(format:"%.4f", weight)
        }
        
        return try req.view().render("fruitbasket",
                                     ["oskPageWeight": weightStr]
        )
    }

    // GET /fruitbasket/STRING
    router.get("fruitbasket", String.parameter) { req -> Future<View> in
        return try req.view().render("fruitbasket", [
            "name": req.parameters.next(String.self)
            ])
    }
    
    // POST /fruitbasket
    router.post("fruitbasket", String.parameter) { req -> Future<View> in
        
        return try req.view().render("fruitbasket", [
            "name": req.parameters.next(String.self)
            ])
    }
}
