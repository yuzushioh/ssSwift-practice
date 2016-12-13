import Vapor
import VaporMySQL

let drop = Droplet()

drop.preparations.append(Task.self)
try drop.addProvider(Provider.self)

drop.resource("tasks", TaskController())

drop.run()
