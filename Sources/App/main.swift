import Vapor
import VaporPostgreSQL

let drop = Droplet()

drop.preparations.append(Task.self)
drop.preparations.append(User.self)
try drop.addProvider(VaporPostgreSQL.Provider.self)

drop.middleware.append(TaskMiddleWare())

drop.resource("users", UserController())
drop.resource("tasks", TaskController())

drop.get("validation/username") { request in
    guard let username = request.data["username"]?.string else {
        throw Abort.badRequest
    }
    
    let users = try User.query().filter("username", username).run()
    return try JSON(node: ["is_valid": "\(users.isEmpty)"])
}

drop.run()
