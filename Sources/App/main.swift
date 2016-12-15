import Vapor
import VaporPostgreSQL

let drop = Droplet()

drop.preparations.append(Task.self)
drop.preparations.append(User.self)
try drop.addProvider(VaporPostgreSQL.Provider.self)

drop.resource("users", UserController())
drop.resource("tasks", TaskController())

drop.get("version") { request in
    guard let db = drop.database?.driver as? PostgreSQLDriver else {
        throw Abort.badRequest
    }
    
    let version = try db.raw("SELECT version()")
    return try JSON(node: version)
}

drop.get("validation/username") { request in
    guard let username = request.data["username"]?.string else {
        throw Abort.badRequest
    }
    
    let users = try User.query().filter("username", username).run()
    return try JSON(node: ["is_valid": "\(users.isEmpty)"])
}

drop.run()
